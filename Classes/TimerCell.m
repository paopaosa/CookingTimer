//
//  TimerCell.m
//  CookingTImer
//
//  Created by user on 11-5-15.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "TimerCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimerCell

@synthesize innerTimer;

- (NSString *)convertSeconds:(NSNumber *)newTimer {
    NSDateComponents *components = [[NSDateComponents alloc] init]; 
    [components setDay:1]; 
    [components setMonth:1]; 
    [components setYear:2000];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSDate *newDate = [gregorian dateFromComponents:components];
    NSDate *someDate = [NSDate dateWithTimeInterval:[newTimer intValue] sinceDate:newDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *resultStr = [NSString stringWithFormat:@"%@",[df stringFromDate:someDate]];
    [df release];
    return resultStr;
}

//初始化时间
- (void)setTimer:(NSNumber *)newTimer {
    howlongLabel.text = [self convertSeconds:newTimer];
}

//开始计时器
- (void)startTimer {
    ;
}

//暂停计时器
- (void)stopTimer {
    ;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		gradientLayer.frame = CGRectMake(0, 0, 320, 60);
		gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor whiteColor].CGColor,
								(id)[UIColor lightGrayColor].CGColor,
								(id)[UIColor grayColor].CGColor,
								(id)[UIColor whiteColor].CGColor,
								nil];
		gradientLayer.locations = [NSArray arrayWithObjects:
								   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:0.005f],
								   [NSNumber numberWithFloat:0.98f],
								   [NSNumber numberWithFloat:1.0f],nil];
		[bg.layer addSublayer:gradientLayer];
        self.backgroundView = bg;
        [bg release];
        
        howlongLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 240, 45)];
        howlongLabel.font = [UIFont boldSystemFontOfSize:40];
        howlongLabel.backgroundColor = [UIColor clearColor];
        howlongLabel.textColor = [UIColor blackColor];
        howlongLabel.text = @"12:00:00";
        howlongLabel.shadowColor = [UIColor whiteColor];
        howlongLabel.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:howlongLabel];
        
        self.imageView.image = [UIImage imageNamed:@"TimerTab01.png"];
        
        //There is new test add comment.
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [innerTimer release];
    [howlongLabel release];
    [super dealloc];
}

@end
