//
//  SmallLedView.m
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "SmallLedView.h"

#define _fontWidth 1.8f

@implementation SmallLedView

- (void)disableColon {
    text2.text = nil;
}

- (void)setLedString:(NSString *)ledString {
    text0.text = [ledString substringWithRange:NSMakeRange(0, 1)];
    text1.text = [ledString substringWithRange:NSMakeRange(1, 1)];
}

- (void)addBackLed:(CGRect)newRect {
    UILabel *shadowLabel = [[UILabel alloc] initWithFrame:newRect];
    shadowLabel.textColor = [UIColor colorWithRed:0.9 green:1.0 blue:1.0 alpha:0.2];
    shadowLabel.text = @"8";
    shadowLabel.textAlignment = UITextAlignmentRight;
    shadowLabel.backgroundColor = [UIColor clearColor];
    shadowLabel.font = [UIFont fontWithName:@"UnidreamLED" size:newRect.size.width * _fontWidth];
    [self addSubview:shadowLabel];
    [shadowLabel release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = frame.size.width / 2.5;
        CGFloat height = frame.size.height;
        
        [self addBackLed:CGRectMake(0, 0, width, height)];
        
        [self addBackLed:CGRectMake(width, 0, width, height)];
        
        text0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        text0.textColor = [UIColor blackColor];
        text0.textAlignment = UITextAlignmentRight;
        text0.font = [UIFont fontWithName:@"UnidreamLED" size:width * _fontWidth];
        text0.text = @"8";
        text0.shadowColor = [UIColor grayColor];
        text0.shadowOffset = CGSizeMake(-1, 1);
        text0.backgroundColor = [UIColor clearColor];
        [self addSubview:text0];
        
        CGRect text0Frame = text0.frame;
        
        text1 = [[UILabel alloc]initWithFrame:CGRectMake(text0Frame.origin.x + text0Frame.size.width,
                                                         0, width, height)];
        text1.backgroundColor = [UIColor clearColor];
        text1.textColor = [UIColor blackColor];
        text1.textAlignment = UITextAlignmentRight;
        text1.font = [UIFont fontWithName:@"UnidreamLED" size:width * _fontWidth];
        text1.text = @"8";
        text1.shadowColor = [UIColor grayColor];
        text1.shadowOffset = CGSizeMake(-1, 1);
        [self addSubview:text1];
        
        CGRect text1Frame = text1.frame;
        
        text2 = [[UILabel alloc]initWithFrame:CGRectMake(text1Frame.origin.x + text1Frame.size.width,
                                                         0, width/2, height)];
        text2.backgroundColor = [UIColor clearColor];
        text2.textColor = [UIColor blackColor];
        text2.textAlignment = UITextAlignmentCenter;
        text2.font = [UIFont fontWithName:@"UnidreamLED" size:width * _fontWidth];
        text2.text = @":";
        text2.shadowColor = [UIColor grayColor];
        text2.shadowOffset = CGSizeMake(-1, 1);
        [self addSubview:text2];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [text0 release];
    [text1 release];
    [text2 release];
    [super dealloc];
}

@end
