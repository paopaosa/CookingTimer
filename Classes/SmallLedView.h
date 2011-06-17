//
//  SmallLedView.h
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SmallLedView : UIView {
    UILabel *text0;
    UILabel *text1;
    UILabel *text2;
}

//set two digital.
- (void)setLedString:(NSString *)ledString;

//close colon
- (void)disableColon;
//show colon
- (void)enableColon;

@end
