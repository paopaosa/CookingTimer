//
//  TDSoundTableViewController.h
//  CookingTImer
//
//  Created by user on 11-6-26.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "TimerData.h"

@protocol TDSoundTableViewControllerDelegate <NSObject>

- (void)selectedSound:(TimerData *)selectedSoundData;

@end


@interface TDSoundTableViewController : UITableViewController {
    TimerData       *soundTimerData;
    NSArray         *soundLists;
    AVAudioPlayer   *audioPlayer;
    id <TDSoundTableViewControllerDelegate> delegate;
}

@property (nonatomic,copy) TimerData        *soundTimerData;
@property (nonatomic,assign) AVAudioPlayer   *audioPlayer;
@property (nonatomic,retain) NSArray *soundLists;
@property (nonatomic,assign) id <TDSoundTableViewControllerDelegate> delegate;

@end
