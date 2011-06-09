//
//  LedView.h
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SmallLedView;

@interface LedView : UIView {
    SmallLedView    *led0;
    SmallLedView    *led1;
    SmallLedView    *led2;
}

//设置液晶屏内容
- (void)configLed:(NSString *)str;

@end
