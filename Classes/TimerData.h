//
//  TimerData.h
//  CookingTImer
//
//  Created by user on 11-6-10.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _status {
    ready = 0,
    start,
    stop,
    finished
} StatusResult;


@interface TimerData : NSObject {
    NSNumber        *length;
    StatusResult    result;
}

@property (nonatomic,copy) NSNumber *length;

//设置数据原
- (void)setDataForTimer:(NSDictionary *)newDict;

@end
