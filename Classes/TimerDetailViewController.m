//
//  TimerDetailViewController.m
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "CommonDefines.h"

@interface TimerDetailViewController (LocalExtend)

- (void)loadTitleForTimerPicker;

- (void)loadLabel:(NSString *)titleStr withFrame:(CGRect)newRect;

@end

@implementation TimerDetailViewController

- (void)loadTitleForTimerPicker {
    //Hour
    CGRect hourRect = CGRectMake(50, 92, 46, 30);
    [self loadLabel:@"小时" withFrame:hourRect];
    
    //Minute
    CGRect minuteRect = CGRectMake(150, 92, 46, 30);
    [self loadLabel:@"分" withFrame:minuteRect];
    
    //Second
    CGRect secondRect = CGRectMake(250, 92, 46, 30);
    [self loadLabel:@"秒" withFrame:secondRect]; 
}

- (void)loadLabel:(NSString *)titleStr withFrame:(CGRect)newRect {
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:newRect];
    hourLabel.textColor = [UIColor blackColor];
    hourLabel.backgroundColor = [UIColor clearColor];
    hourLabel.font = [UIFont boldSystemFontOfSize:20];
    hourLabel.text = titleStr;
    hourLabel.textAlignment = UITextAlignmentCenter;
    hourLabel.alpha = 0.9;
    hourLabel.shadowColor = [UIColor whiteColor];
    hourLabel.shadowOffset = CGSizeMake(0, 1);
    [self.view addSubview:hourLabel];
    [hourLabel release];
}



#pragma mark -
#pragma mark SYSTEM

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 24;
        case 1:
            return 60;
        case 2:
            return 60;
        default:
            break;
    }
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",row];
}

#pragma mark -
#pragma mark lifecyc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        DLog(@"init the Timer detail view controller.");
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", nil) style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
        
        timerSetter.showsSelectionIndicator = YES;
    }
    return self;
}

- (void)dealloc
{
    [timerSetter release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadTitleForTimerPicker];
}

- (void)viewDidUnload
{
    [timerSetter release];
    timerSetter = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
