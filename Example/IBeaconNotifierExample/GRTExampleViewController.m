//
//  GRTExampleViewController.m
//  IBeaconNotifierExample
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "GRTExampleViewController.h"
#import "IBNBeaconServiceConst.h"

@interface GRTExampleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSMutableArray *messageArray;
@end

@implementation GRTExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.messageArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.messageArray addObject:[self timestamp]];
    [self updateView];
    // Start Listening Beacon Event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:IBN_CHANGE_BEACON_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:IBN_CHANGE_NEAREST_BEACON object:nil];
}

- (void)handleEvent:(NSNotification *)note {
    NSString *msg = @"";
    NSString *time = [self timestamp];
    if ([IBN_CHANGE_NEAREST_BEACON isEqualToString:note.name]) {
         msg = [NSString stringWithFormat:@"%@\tNEAREST is %@", time, note.userInfo[IBN_BEACON_ID]];
    }
    if ([IBN_CHANGE_BEACON_STATE isEqualToString:note.name]) {
        msg = [NSString stringWithFormat:@"%@\t%@ State is %@", time, note.userInfo[IBN_BEACON_ID], note.userInfo[IBN_BEACON_STATE]];
    }
    [self.messageArray insertObject:msg atIndex:0];
    if ([self.messageArray count] > 10) {
        [self.messageArray removeObjectAtIndex:[self.messageArray count]-1];
    }
    [self updateView];
}

- (void)updateView {
    self.textView.text = [self.messageArray componentsJoinedByString:@"\n"];
}

- (NSString *)timestamp {
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [outputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [outputDateFormatter stringFromDate:[NSDate date]];
}

@end
