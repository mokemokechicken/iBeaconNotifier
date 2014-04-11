//
//  IBNBeaconServiceConst.h
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#ifndef IBNStorySample_IBNBeaconServiceConst_h
#define IBNStorySample_IBNBeaconServiceConst_h

////////////// NSNotificationの userInfo にBeaconIDを含むときのKey
#define IBN_BEACON_ID               (@"IBN_BEACON_ID")

/////////////////////////////////////////////////
// IBNBeaconModel が発行するNotification
// Notification: IBN_CHANGE_BEACON_STATE
// userInfo: @{IBN_BEACON_ID: BeaconId}
// userInfo: @{IBN_BEACON_STATE: IBN_BEACON_STATE_*}
/////////////////////////////////////////////////
// Notification Name
#define IBN_CHANGE_BEACON_STATE     (@"IBN_CHANGE_BEACON_STATE")
// State Key
#define IBN_BEACON_STATE            (@"IBN_BEACON_STATE")
/////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
////////////// ShortCut to IBNBeaconModelState Object
/////////////////////////////////////////////////////////////////////////
#define IBN_BEACON_STATE_OUTSIDE      (@"Outside")
#define IBN_BEACON_STATE_INSIDE       (@"Inside")
#define IBN_BEACON_STATE_FAR          (@"Far")
#define IBN_BEACON_STATE_NEAR         (@"Near")
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////
// IBNNearestModel が発行するNotification
// Notification: IBN_NEAREST_BEACON
/////////////////////////////////////////////////
#define IBN_CHANGE_NEAREST_BEACON          (@"IBN_CHANGE_NEAREST_BEACON")

// userInfo: @{IBN_BEACON_ID: BeaconId or NsNull}
/////////////////////////////////////////////////



#endif
