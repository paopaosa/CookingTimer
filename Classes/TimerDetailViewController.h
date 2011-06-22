//
//  TimerDetailViewController.h
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerData;

typedef enum _viewIndex {
    timer = 0,
    title,
    sound
} ViewIndex;

@protocol TimerDetailViewControllerDelegate

@optional
- (void)selectedTimer:(TimerData *)newTimerData;

@end



@interface TimerDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIPickerView *timerSetter;
    IBOutlet UIScrollView *bigScrollView;
    IBOutlet UINavigationBar *titleBar;
    IBOutlet UINavigationBar *soundBar;
    NSNumber    *originTimer;              //origin timer
    NSNumber    *selectedTimer;            //current Timer
    NSArray     *demoLists;
    TimerData   *changeTimerData;
    ViewIndex   viewIndex;
    id <TimerDetailViewControllerDelegate> delegate;
}

@property (nonatomic,retain) TimerData   *changeTimerData;
@property (nonatomic,copy) NSNumber *originTimer; 
@property (nonatomic,copy) NSNumber *selectedTimer;
@property (nonatomic,assign) id <TimerDetailViewControllerDelegate> delegate;

//setup string for current timer
- (void)setTimer:(TimerData *)newData animated:(BOOL)yesOrNo;

- (IBAction)setNewTimer:(id)sender;

@end
