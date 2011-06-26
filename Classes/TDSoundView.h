//
//  TDSoundView.h
//  CookingTImer
//
//  Created by user on 11-6-25.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerData.h"

@interface TDSoundView : UIView {
    SoundType   soundType;
}

@property (nonatomic,assign) SoundType   soundType;

@end
