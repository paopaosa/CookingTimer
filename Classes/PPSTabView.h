//
//  PPSTabView.h
//  CookingTImer
//
//  Created by user on 11-6-23.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPSTabViewDelegate <NSObject>

@optional

- (void)tabViewSelected:(int)index;

@end


@interface PPSTabView : UIView {
    NSArray *buttons;
    int     selectedIndex;
    id <PPSTabViewDelegate> delegate;
}

@property (nonatomic,retain) NSArray *buttons;
@property (nonatomic,assign) int     selectedIndex;
@property (nonatomic,assign) id <PPSTabViewDelegate> delegate;

- (id)initWithNumbers:(NSArray *)numbers andFrame:(CGRect)newFrame;

@end
