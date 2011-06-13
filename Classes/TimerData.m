//
//  TimerData.m
//  CookingTImer
//
//  Created by user on 11-6-10.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TimerData.h"
#import "CommonDefines.h"

@implementation TimerData

@synthesize length;

- (void)setDataForTimer:(NSDictionary *)newDict {
    NSNumber *tempNumber = [newDict objectForKey:kTimerLength];
    if (tempNumber) {
        self.length = tempNumber;
    };
    NSNumber *tempResult = [newDict objectForKey:kTimerResult];
    if (tempResult) {
        result = [tempResult intValue];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        int defaultTimerLength = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey] intValue];
        self.length = [NSNumber numberWithInt:defaultTimerLength];
        result = ready;
    }
    return self;
}

- (void)dealloc {
    [length release];
    [super dealloc];
}
@end
