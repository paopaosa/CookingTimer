//
//  CookTimerTableViewController.h
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CookTimerTableViewController : UITableViewController {
    NSMutableArray *lists;  //闹钟列表 (刻录每个闹钟的长度,起始时间随开始时设定)
    IBOutlet    UISegmentedControl *seg;
    BOOL                            yesOrNO;
}

@property (nonatomic,retain) NSMutableArray *lists;

@end
