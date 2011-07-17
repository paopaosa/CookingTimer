//
//  CookTimerTableViewController.h
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import "PullRefreshTableViewController.h"
#import "TimerDetailViewController.h"
#import "TimerData.h"
#import "SchemaTableViewController.h"
#import "DDInputAlert.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef enum _tableStatus {
    none = 0,
    addMode,
    editMode
} TableViewStatus;

@interface CookTimerTableViewController : PullRefreshTableViewController 

<TimerDetailViewControllerDelegate,SchemaTableViewControllerDelegate,TimerDataDelegate, DDInputAlertDelegate>

{
    NSMutableArray  *lists;  //闹钟列表 (刻录每个闹钟的长度,起始时间随开始时设定)
    IBOutlet        UISegmentedControl *seg;
    BOOL            yesOrNO;
    TableViewStatus tableViewStatus;
    AVAudioPlayer   *player;
    DDInputAlert    *newInput;
}

@property (nonatomic,retain) NSMutableArray *lists;
@property (nonatomic,assign) AVAudioPlayer   *player;
@property (nonatomic,retain) DDInputAlert    *newInput;

- (IBAction)deleteAllTheTimers:(id)sender;

- (IBAction)deleteLastTimer:(id)sender;

- (IBAction)addTemplateTimer:(id)sender;

- (void)scheduleAlarmForDate:(NSDate *)theDate withContent:(TimerData *)warnningStr;

- (void)loadDemoTimerLists;

- (void)loadSavedLists;

//save current lists for timers.
- (void)saveCurrentLists;

//When enter background we call it.
- (void)saveAndStopCookTimer;

//When active we resume all the clock.
- (void)resumeAllCookTimer;

- (void)updateListsTimer:(TimerData *)data row:(NSIndexPath *)nexIndexPath;

- (void)startTimer:(int)index;

- (void)stopTimer:(int)index;

- (void)clickPlay:(int)index;

- (int)indexOfLists:(TimerData *)data;

- (void)playFinshedSound;

- (void)playAudioFile:(NSString *)filePath;

- (void)stopPlayingAudio;

@end
