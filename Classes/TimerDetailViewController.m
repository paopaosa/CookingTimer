//
//  TimerDetailViewController.m
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "CommonDefines.h"

@implementation TimerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        DLog(@"init the Timer detail view controller.");
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    }
    return self;
}

- (void)dealloc
{
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
}

- (void)viewDidUnload
{
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
