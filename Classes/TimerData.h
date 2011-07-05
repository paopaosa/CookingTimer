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

typedef enum _soundType {
    soundPiano,
    soundGuitar,
    soundCow,
    soundElectricAlarm
} SoundType;

typedef enum _figureType {
    figureCooking,
    figureWashing,
    figureTea,
    figureBread,
    figureEgg,
    figureSoup
} FigureType;

@protocol TimerDataDelegate;

@interface TimerData : NSObject <NSCopying> {
//    NSIndexPath     *indexPath;
    NSNumber        *originTimer;   //origin howlong
    NSNumber        *howlong;       //running how long
    NSString        *content;       //content for timer
    NSString        *soundName;     //alarm sound name
    NSDate          *endDate;
    StatusResult    status;
    SoundType       soundIndex;     //alarm sound
    FigureType      figureIndex;    //figure to metion
    id <TimerDataDelegate>  delegate;
}

//@property (nonatomic,copy) NSIndexPath      *indexPath;
@property (nonatomic,copy) NSNumber         *originTimer;
@property (nonatomic,copy) NSNumber         *howlong;
@property (nonatomic,copy) NSString         *content;
@property (nonatomic,copy) NSString         *soundName;
@property (nonatomic,copy) NSDate           *endDate;
@property (nonatomic,assign) FigureType     figureIndex;
@property (nonatomic,assign) SoundType      soundIndex;
@property (nonatomic,assign) StatusResult   status;
@property (nonatomic,assign) id <TimerDataDelegate>  delegate;

+ (id)defaultData;

//Set timer for data mode.
- (void)setDataForTimer:(NSDictionary *)newDict;

//Set start or stop event.
- (void)clickEvent:(int)index;
//detach new thread
- (void)readyToStart;

- (void)start;

- (void)stop;

- (void)finished;

@end

@protocol TimerDataDelegate <NSObject>

@optional

- (void)updateTimer:(int)readTimer;

- (void)finishedTimer:(int)indexTimer;

- (void)splashTimer:(int)splashIndex;

- (int)indexOfLists:(TimerData *)data;

@end