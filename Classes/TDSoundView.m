//
//  TDSoundView.m
//  CookingTImer
//
//  Created by user on 11-6-25.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "TDSoundView.h"


@implementation TDSoundView

@synthesize soundType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        soundType = soundPiano;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
