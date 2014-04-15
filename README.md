# iBeaconNotifier

[![Version](http://cocoapod-badges.herokuapp.com/v/iBeaconNotifier/badge.png)](http://cocoadocs.org/docsets/iBeaconNotifier)
[![Platform](http://cocoapod-badges.herokuapp.com/p/iBeaconNotifier/badge.png)](http://cocoadocs.org/docsets/iBeaconNotifier)

About
=====

複数のiBeaconの状態変更を NSNotificationに変換して通知するライブラリです。
主に以下の２つの機能があります。

* 各Beaconの状態変更を通知
* 「一番近くにあるBeacon」が変化すれば通知

各Beaconの状態変更を通知
-------------------

複数のBeaconを指定して、各Beaconごとに、

* 範囲に入った(IN)
* 範囲から出た(OUT)
* 遠くにいる(FAR)
* 近くにいる(NEAR)

という状態の変化を NSNotification として通知します。

「一番近くにあるBeacon」が変化すれば通知
---------------------

各BeaconのUUIDを同一にしてあれば、そのBeaconの中で最も近くにあるBeaconがどれかという通知を出します。

もし、異なるUUIDであれば、1番目のBeaconのUUIDと同じBeacon群の中で最も近いBeaconについて通知を出します。


## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Please see, `Example/IBeaconNotifierExample/{GRTAppDelegate.m,GRTExampleViewController.m}`

## Requirements

## Installation

iBeaconNotifier is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "iBeaconNotifier", :git => 'https://github.com/mokemokechicken/iBeaconNotifier.git'

## How To Use

Step1: 利用するBeaconの情報の設定
--------------

まず、利用するBeaconをTSV形式でします。
例えば、下記のような `beacon.tsv`をBundleしておきます。
このTSVは「1行目が列名」「2行目以降がデータ」です。
各列の意味は以下のようになります。

* id: Beaconの識別子。このBeaconIDがNSNotificationに含まれます。
* uuid: iBeaconのUUID
* major: iBeaconの major の値
* minor: iBeaconの minor の値

例：

```text:beacon.tsv
id	uuid	major	minorBeaconA	00000000-04B1-1001-B000-001C4D153904	1	4BeaconB	00000000-04B1-1001-B000-001C4D153904	0	2BeaconC	00000000-04B1-1001-B000-001C4D153904	1	3
```

Step2: Beacon監視サービスの起動
--------------------

まず、

```
#import "IBNBeaconService.h"
```

をimportします。

Beacon監視を開始するには以下のようにします。

```
    // start beacon service
    self.beaconService = [IBNBeaconService createWithFielname:@"beacon.tsv" bundle:nil];
    [self.beaconService start];
```

`IBNBeaconService` のインスタンスは、どこかで保持しておいてください。

Step3: Beaconの通知イベントのObserve
--------------------

あとは任意のコードで、beaconのイベントをNSNotificationCenterを経由して受け取ることができます。

まず、定数定義されているヘッダファイルをimportします。

```
#import "IBNBeaconServiceConst.h"
```

### 各Beaconの状態変更の通知を受け取る

`IBN_CHANGE_BEACON_STATE` の Notification を Observeします。

```
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(handleEvent:) 
                                             name:IBN_CHANGE_BEACON_STATE 
                                           object:nil];
```

イベントハンドラでは、 以下の情報をが取得できます。


* どのBeaconか: `note.userInfo[IBN_BEACON_ID]`
	* 前述の `beacon.tsv` で指定した `id` の文字列が入ります
* どの状態になったか:  `note.userInfo[IBN_BEACON_STATE]`
	* 以下のどれかが入ります
	* 範囲に入った(IN): `IBN_BEACON_STATE_INSIDE`
	* 範囲から出た(OUT): `IBN_BEACON_STATE_OUTSIDE`
	* 遠くにいる(FAR): `IBN_BEACON_STATE_FAR`
	* 近くにいる(NEAR): `IBN_BEACON_STATE_NEAR`



### 「一番近くにあるBeacon」が変化すれば通知

`IBN_CHANGE_NEAREST_BEACON` の Notification を Observe します。

```
[[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(handleEvent:) 
                                             name:IBN_CHANGE_NEAREST_BEACON 
                                           object:nil];
```

イベントハンドラでは、 以下の情報をが取得できます。

* どのBeaconが一番近くになったか: `note.userInfo[IBN_BEACON_ID]`
	* 前述の `beacon.tsv` で指定した `id` の文字列が入ります
	* もし、近くに一つも無ければ（全て範囲外に出たら）、 `NsNull` が入ってきます。



## Author

Ken Morishita, k_morishita@yumemi.co.jp

## License

iBeaconNotifier is available under the MIT license. See the LICENSE file for more info.

