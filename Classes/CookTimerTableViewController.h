//
//  CookTimerTableViewController.h
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerDetailViewController.h"
#import "TimerData.h"

typedef enum _tableStatus {
    none = 0,
    addMode,
    editMode
} TableViewStatus;

@interface CookTimerTableViewController : UITableViewController <TimerDetailViewControllerDelegate, TimerDataDelegate>{
    NSMutableArray  *lists;  //闹钟列表 (刻录每个闹钟的长度,起始时间随开始时设定)
    IBOutlet        UISegmentedControl *seg;
    BOOL            yesOrNO;
    TableViewStatus tableViewStatus;
}

@property (nonatomic,retain) NSMutableArray *lists;

//save current lists for timers.
- (void)saveCurrentLists;

- (void)updateListsTimer:(TimerData *)data row:(NSIndexPath *)nexIndexPath;

- (void)startTimer:(int)index;

- (void)stopTimer:(int)index;

- (void)clickPlay:(int)index;

- (int)indexOfLists:(TimerData *)data;

@end
