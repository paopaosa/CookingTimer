//
//  TimerDetailViewController.h
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerDetailViewControllerDelegate

@optional
- (void)selectedTimer:(int)newTimer;

@end

@interface TimerDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIPickerView *timerSetter;
    NSNumber *originTimer;              //origin timer
    NSNumber *selectedTimer;            //current Timer
    NSArray  *demoLists;
    id <TimerDetailViewControllerDelegate> delegate;
}

@property (nonatomic,copy) NSNumber *originTimer; 
@property (nonatomic,retain) NSNumber *selectedTimer;
@property (nonatomic,assign) id <TimerDetailViewControllerDelegate> delegate;

//setup string for current timer
- (void)setTimer:(NSNumber *)newTimerString animated:(BOOL)yesOrNo;

- (IBAction)setNewTimer:(id)sender;

@end
