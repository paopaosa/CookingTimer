//
//  TimerCell.h
//  CookingTImer
//
//  Created by user on 11-5-15.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LedView;
@class TimerData;

@interface TimerCell : UITableViewCell {
    UIButton    *playButton;
    UILabel     *statusLabel;       //运行状态
    UILabel     *titleLabel;        //标题
//    UILabel     *howlongLabel;
    LedView     *ledView;
    TimerData   *timeData;
    NSTimer     *innerTimer;
    BOOL        isSplash;           //是否闪烁冒号
    BOOL        isStarted;          //是否启动定时器
    NSIndexPath *_indexPath;        //索引
    UITableViewController *rootViewController;
}

@property (nonatomic,retain) TimerData   *timeData;
@property (nonatomic,assign) UITableViewController *rootViewController;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) NSTimer     *innerTimer;
@property (nonatomic,assign) BOOL        isStarted;

//初始化时间
- (void)setTimer:(NSNumber *)newTimer;
//开始计时器
- (void)startTimer;
//暂停计时器
- (void)stopTimer;

- (void)playTimer;

- (void)updateTimer;

- (void)setCurrentTimer:(TimerData *)currentTimerData;

- (void)timerFinished:(NSNumber *)originTimer;

- (void)splashSeconds;

@end
