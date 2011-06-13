//
//  LedView.m
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "LedView.h"
#import "SmallLedView.h"

@implementation LedView

//设置液晶屏内容
- (void)configLed:(NSString *)str {
    SmallLedView *ledSmall = nil;
    for (int i = 0; i < 3; ++i) {
        ledSmall = (SmallLedView *)[self viewWithTag:(321 + i)];
        [ledSmall setLedString:[str substringWithRange:NSMakeRange(3 * i, 2)]];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = frame.size.width / 3;
        
//        UIImage *backImage = [[UIImage imageNamed:@"LedBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        UIImageView *ledBackView = [[UIImageView alloc] initWithFrame:self.bounds];
//        ledBackView.image = backImage;
//        [self addSubview:ledBackView];
//        [ledBackView release];
//        CGRect rectNew;
//        UILabel *singleText = nil;
//        for (int i = 0; i < 10; ++i) {
//            singleText = [[UILabel alloc] initWithFrame:CGRectZero];
//            if ((i+1) % 3 == 0) {
//                rectNew = CGRectMake(fontSize * i, 0, fontSize/2, frame.size.height);
//                singleText.text = @":";
//            } else {
//                rectNew = CGRectMake(fontSize * i, 0, fontSize, frame.size.height);
//                singleText.text = @"8";
//            }
//            singleText.frame = rectNew;
//            singleText.font = [UIFont fontWithName:@"UnidreamLED" size:fontSize * 2];
//            singleText.textAlignment = UITextAlignmentCenter;
//            singleText.textColor = [UIColor lightGrayColor];
//            singleText.backgroundColor = [UIColor clearColor];
//            
//            singleText.tag = 320 + i;
//            [self addSubview:singleText];
//            [singleText release];
//            singleText = nil;
//        }
        SmallLedView *twoDigitalView = nil;
        for (int i = 0; i < 3; ++i) {
            
            if (i == 2) {
                twoDigitalView = [[SmallLedView alloc] initWithFrame:CGRectMake(width * i, 0, width / 1.8, frame.size.height / 1.8)];
                [twoDigitalView disableColon];
            } else {
                twoDigitalView = [[SmallLedView alloc] initWithFrame:CGRectMake(width * i, 0, width, frame.size.height)];
            }
            [self addSubview:twoDigitalView];
//            twoDigitalView.backgroundColor = [UIColor redColor];
            twoDigitalView.clipsToBounds = YES;
            twoDigitalView.tag = 321 + i;
            [twoDigitalView release];
            twoDigitalView = nil;
        }
        
        
        self.clipsToBounds = YES;
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
    [led0 release];
    [led1 release];
    [led2 release];
    [super dealloc];
}

@end
