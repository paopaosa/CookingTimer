//
//  TimerCell.m
//  CookingTImer
//
//  Created by user on 11-5-15.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "TimerCell.h"
#import "LedView.h"
#import "TimerData.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonDefines.h"
#import "CookTimerTableViewController.h"

@interface TimerCell (LocalExtend)

- (void) startThread;

- (void) clickCellPlay:(id)sender;

- (void) loadTimerStatus;

- (void) loadTitleForTimer;

@end

@implementation TimerCell

@synthesize timeData;
@synthesize rootViewController;
@synthesize isStarted;
@synthesize innerTimer;
@synthesize indexPath = _indexPath;

#pragma mark -
#pragma mark LocalExtend
- (void) loadTimerStatus {
    if (!statusLabel) {
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 + 10, 1, 100, 20)];
    }
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.shadowColor = [UIColor grayColor];
    statusLabel.shadowOffset = CGSizeMake(0, 1);
    statusLabel.font = [UIFont fontWithName:@"UnidreamLED" size:12];
    statusLabel.text = @"READY";
    [self.contentView addSubview:statusLabel];
}

- (void) loadTitleForTimer {
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 1, 120, 20)];
    };
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor grayColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.font = [UIFont fontWithName:@"UnidreamLED" size:12];
    titleLabel.text = [timeData content];
    [self.contentView addSubview:titleLabel];
}

- (void) clickCellPlay:(id)sender {
    [(CookTimerTableViewController *)rootViewController clickPlay:(int)[(CookTimerTableViewController *)rootViewController indexOfLists:timeData]];
}

- (void)updateTimer {
    [ledView configLed:[kDelegate convertSeconds:[timeData howlong]]];
//    [self setNeedsDisplay];
}

- (void)timerFinished:(NSNumber *)originTimer {
    DLog(@"reset finished Cell. %@", [timeData originTimer]);
    [self setCurrentTimer:self.timeData];
    statusLabel.text = @"FINISHED";
}

#pragma mark -
#pragma mark public methods

- (void)splashSeconds {
    DLog(@"Splash Seconds.");
    isSplash = !isSplash;
    isSplash ? [ledView hideColon]: [ledView showColon];
}

- (void)setCurrentTimer:(TimerData *)currentTimerData {
    self.timeData = currentTimerData;
    [ledView configLed:[kDelegate convertSeconds:[timeData howlong]]];
    if ([timeData status] != start) {
        [ledView showColon];
    }
    titleLabel.text = [timeData content];
    switch ([timeData status]) {
        case ready:
            statusLabel.text = @"READY";
            playButton.selected = NO;
            break;
        case start:
            statusLabel.text = @"RUNNING...";
            playButton.selected = YES;
            break;
        case stop:
            statusLabel.text = @"PAUSE";
            playButton.selected = NO;
            break;
        case finished:
            statusLabel.text = @"FINISHED";
//            [self performSelectorInBackground:@selector(playFinishedSound) withObject:nil];
            playButton.selected = NO;
            break;
        default:
            playButton.selected = NO;
            break;
    }
}

//初始化时间
- (void)setTimer:(NSNumber *)newTimer {
//    howlongLabel.text = [self convertSeconds:newTimer];
    timeData.howlong = newTimer;
    [ledView configLed:[kDelegate convertSeconds:newTimer]];
    if (isStarted) {
        playButton.selected = YES;
    } else {
        playButton.selected = NO;
    }
}

- (void)makeProgressBarMoving {
    
	int actual = [[timeData howlong] intValue];
//    DLog(@"%@,actual:%d",_indexPath,actual);
//    [self setTimer:timeData.howlong];
    if ([rootViewController respondsToSelector:@selector(updateListsTimer:row:)]) {
        [rootViewController updateListsTimer:timeData row:self.indexPath];
    }
	if (actual == 0) {
		isStarted = NO;
		DLog(@"it's end! thread1");
		playButton.selected = NO;
		return;
	}
	//threadValueLabel.text = [NSString stringWithFormat:@"%.2f", actual];
	timeData.howlong = [NSNumber numberWithInt:(actual - 1)];
}

- (void) startThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	while (isStarted) {
		[self performSelectorOnMainThread:@selector(makeProgressBarMoving) withObject:nil waitUntilDone:NO];
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
	}
	DLog(@"Thread is end!");
    [NSThread exit];
	[pool release];
	
}

//开始计时器
- (void)startTimer {
    DLog(@"Start timer.");
    playButton.selected = YES;
    [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}

//暂停计时器
- (void)stopTimer {
    DLog(@"Stop timer.");
    playButton.selected = NO;
}

- (void)playTimer {
    isStarted = !isStarted;
    if (isStarted) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

#pragma mark -
#pragma mark lifecyc

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isStarted = NO;
        isSplash = NO;
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        bg.backgroundColor = [UIColor blackColor];
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//		gradientLayer.frame = CGRectMake(0, 0, 320, 60);
//		gradientLayer.colors = [NSArray arrayWithObjects:
//                                (id)[UIColor whiteColor].CGColor,
//								(id)[UIColor lightGrayColor].CGColor,
//								(id)[UIColor grayColor].CGColor,
//								(id)[UIColor whiteColor].CGColor,
//								nil];
//		gradientLayer.locations = [NSArray arrayWithObjects:
//								   [NSNumber numberWithFloat:0.0f],
//                                   [NSNumber numberWithFloat:0.005f],
//								   [NSNumber numberWithFloat:0.98f],
//								   [NSNumber numberWithFloat:1.0f],nil];
//		[bg.layer addSublayer:gradientLayer];
        
        UIImageView *newLedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 320, 59)];
        newLedView.image = [[UIImage imageNamed:@"LedBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [bg addSubview:newLedView];
        [newLedView release];
        
        self.backgroundView = bg;
        [bg release];
        
        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(0, 0, 60, 59);
        playButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.2 alpha:0.8];
        [playButton addTarget:self action:@selector(clickCellPlay:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setBackgroundImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
        playButton.contentMode = UIViewContentModeScaleToFill;
        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [playButton setTitle:@"▶" forState:UIControlStateNormal];
        [playButton setTitle:@"〓" forState:UIControlStateSelected];
        [self.contentView addSubview:playButton];
        
//        howlongLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 240, 45)];
//        howlongLabel.font = [UIFont fontWithName:@"UnidreamLED" size:46];;
//        howlongLabel.backgroundColor = [UIColor clearColor];
//        howlongLabel.textColor = [UIColor blackColor];
//        howlongLabel.text = @"12:00:00";
//        howlongLabel.shadowColor = [UIColor whiteColor];
//        howlongLabel.shadowOffset = CGSizeMake(0, 1);
//        [self.contentView addSubview:howlongLabel];
        ledView = [[LedView alloc] initWithFrame:CGRectMake(70, 24, 168, 32)];
        [self.contentView addSubview:ledView];
//        self.imageView.image = [UIImage imageNamed:@"TimerTab01.png"];
        timeData = [[TimerData alloc] init];
        
        [self loadTimerStatus];
        
        [self loadTitleForTimer];
        
        //There is new test add comment.
//        self.layer.cornerRadius = 6;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 1);
//        self.layer.shadowOpacity = 1.0f;
//        self.layer.shadowRadius = 1;
        
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
    [_indexPath release];
    [statusLabel release];
    [titleLabel release];
    [innerTimer release];
    [ledView release];
    [timeData release];
    [super dealloc];
}

@end
