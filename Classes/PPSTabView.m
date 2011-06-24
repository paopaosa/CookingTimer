//
//  PPSTabView.m
//  CookingTImer
//
//  Created by user on 11-6-23.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "PPSTabView.h"
#import "CommonDefines.h"

@interface PPSTabView (KIExtended)

//- (void)tapHere:(UITapGestureRecognizer *)sender;

- (void)clickButtonIndex:(id)sender;

@end

@implementation PPSTabView

@synthesize buttons;
@synthesize selectedIndex;
@synthesize delegate;

//- (void)tapHere:(UITapGestureRecognizer *)sender {
//    DLog(@"You have tap here:%@", [sender view]);
//}

- (void)clickButtonIndex:(id)sender {
    int _index = [sender tag];
    DLog(@"You have clicked:%d",_index);
    UIButton *selectedButton = nil;
    for (int i = 0; i < [buttons count]; ++i) {
        selectedButton = (UIButton *)[self viewWithTag:(430 + i)];
        if (i == (_index - 430)) {
//            DLog(@"Set %d",i);
            selectedButton.selected = YES;
        } else {
//            DLog(@"UnSet %d", i);
            selectedButton.selected = NO;
        }
    }
    [delegate tabViewSelected:(_index - 430)];
}

- (id)initWithNumbers:(NSArray *)numbers andFrame:(CGRect)newFrame {
    self = [self initWithFrame:newFrame];
    if (self) {
        int count = [numbers count];
        int buttonWidth = newFrame.size.width / count;
        self.buttons = numbers;
        UIButton *newButton = nil;
        for (int i = 0; i < count; ++i) {
            newButton = [UIButton buttonWithType:UIButtonTypeCustom];
            newButton.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, newFrame.size.height);
            newButton.backgroundColor = [UIColor colorWithRed:0.1f*i green:0.1f*i blue:0.1f*i alpha:1.0];
            newButton.tag = 430 + i;
            [newButton setBackgroundImage:[[UIImage imageNamed:@"TabSelectedBackground.png"] stretchableImageWithLeftCapWidth:22 
                                                                                                         topCapHeight:22]
                                 forState:UIControlStateNormal];
            [newButton setBackgroundImage:[[UIImage imageNamed:@"TabBackground.png"] stretchableImageWithLeftCapWidth:22 
                                                                                                         topCapHeight:22]
                                 forState:UIControlStateSelected];
            [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [newButton setTitle:[numbers objectAtIndex:i] forState:UIControlStateNormal];
            [newButton addTarget:self action:@selector(clickButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:newButton];
            
            if (i == selectedIndex) {
                newButton.selected = YES;
            } else {
                newButton.selected = NO;
            }
        }
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        selectedIndex = 0;
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
//        [tapGesture addTarget:self action:@selector(tapHere:)];
//        [self addGestureRecognizer:tapGesture];
//        [tapGesture release];
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
    [buttons release];
    [super dealloc];
}

@end
