//
//  AddCell.m
//  CookingTImer
//
//  Created by user on 11-5-18.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "AddCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonDefines.h"

@implementation AddCell

- (void)swipe:(UISwipeGestureRecognizer *)swipGesture {
    DLog(@"Swipe guesture happended.");
    
}

- (void)tapMethod:(UITapGestureRecognizer *)tapGesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddCell object:nil];
}

- (IBAction)callAddContent:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddCell object:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(4, 2, 312, 52)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		gradientLayer.frame = CGRectMake(0, 2, 312, 52);
		gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor whiteColor].CGColor,
								(id)[UIColor lightGrayColor].CGColor,
								(id)[UIColor darkGrayColor].CGColor,
								(id)[UIColor whiteColor].CGColor,
								nil];
		gradientLayer.locations = [NSArray arrayWithObjects:
								   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:0.005f],
								   [NSNumber numberWithFloat:0.98f],
								   [NSNumber numberWithFloat:1.0f],nil];
		[bg.layer addSublayer:gradientLayer];
        gradientLayer.cornerRadius = 5;
        gradientLayer.borderWidth = 2;
        gradientLayer.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.85 alpha:1.0].CGColor;
        [self.contentView addSubview: bg];
        [bg release];
        
        UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 2, 80, 40)];
        addLabel.backgroundColor = [UIColor clearColor];
        addLabel.text = @"+";
        addLabel.textColor = [UIColor whiteColor];
        addLabel.font = [UIFont boldSystemFontOfSize:54];
        addLabel.shadowColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        addLabel.shadowOffset = CGSizeMake(2, 0);
        [self.contentView addSubview:addLabel];
        [addLabel release];
        
        UIView *fg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        [swip setDelegate:self];
        swip.direction = UISwipeGestureRecognizerDirectionRight;
        [fg addGestureRecognizer:swip];
        [swip release];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
//        tapGesture.delegate = self;
//        [fg addGestureRecognizer:tapGesture];
//        [tapGesture release];
        
        [self addSubview:fg];
        [fg release];
        
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickButton addTarget:self action:@selector(callAddContent:) forControlEvents:UIControlEventTouchUpInside];
        clickButton.frame = self.bounds;
        [self addSubview:clickButton];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
