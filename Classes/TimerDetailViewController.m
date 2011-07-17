//
//  TimerDetailViewController.m
//  CookingTImer
//
//  Created by user on 11-6-9.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "TimerData.h"
#import "CommonDefines.h"

@interface TimerDetailViewController (LocalExtend)

- (void)loadTabbar;

- (void)loadTitleForTimerPicker;

- (void)loadLabel:(NSString *)titleStr withFrame:(CGRect)newRect;

- (void)setupButtonsForTimer;

- (void)readyToChange:(id)sender;

- (void)resetDefault:(id)sender;

//read current timer from picker
- (NSNumber *)currentTimerFromPicker;

- (void)slideToDurationView;

- (void)slideToTitleView;

- (void)slideToShapeSelectView;

- (void)slideToSoundView;

- (void)slideToFigureView;

- (void)modifyBarLocation;

- (void)hiddenAllSubViews;

@end

@implementation TimerDetailViewController

@synthesize soundTableViewController;
@synthesize shapeTableViewController;
@synthesize changeTimerData;
@synthesize delegate;
@synthesize selectedTimer;
@synthesize originTimer;
#pragma mark -
#pragma mark PRIVATE

- (void)modifyBarLocation {
    DLog(@"modify Bar location.");
    CGRect oldBarFrame = titleBar.frame;
    oldBarFrame.origin.y += 120;
    titleBar.frame = oldBarFrame;
    
    oldBarFrame = soundBar.frame;
    oldBarFrame.origin.y += 300;
    soundBar.frame = oldBarFrame;
}

- (IBAction)setNewTimer:(id)sender {
//    NSNumber *aTimer = nil;
    changeTimerData.howlong = [NSNumber numberWithInt:0];
    [delegate selectedTimer:changeTimerData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)resetDefault:(id)sender {
    DLog(@"Reset default.");
    if (changeTimerData) {
        changeTimerData.howlong = [NSNumber numberWithInt:[[changeTimerData originTimer] intValue]];
        [self setTimer:changeTimerData animated:YES];
    }
}

- (void)readyToChange:(id)sender {
    int tagForButton = [(UIButton *)sender tag];
    DLog(@"You have selected button. tag:%d", tagForButton);
    if (tagForButton < 6) {
        int value = [[demoLists objectAtIndex:[sender tag]] intValue];
        DLog(@"Ready to change:%d\nchange timer Data:%@",value , changeTimerData);
        changeTimerData.howlong = [NSNumber numberWithInt:value];
        [self setTimer:changeTimerData animated:YES];
    }
    else {
        switch (tagForButton) {
            case 6:
                [self slideToDurationView];
                break;
            case 7:
                [self slideToTitleView];
                break;
            case 8:
                [self slideToSoundView];
                break;
            default:
                break;
        }
    }
}

- (void)hiddenAllSubViews {
    DLog(@"Hidden all the subviews.");
    [bigScrollView setHidden:YES];
    if (titleView) {
        [titleView setHidden:YES];
        [titleView hideKeyboard];
    }
    if (soundTableViewController) {
        [[soundTableViewController view] removeFromSuperview];
        self.soundTableViewController = nil;
    }
    if (shapeTableViewController) {
        [[shapeTableViewController view] removeFromSuperview];
        self.shapeTableViewController = nil;
    }
    if (shapeTitle) {
        [shapeTitle removeFromSuperview];
        [shapeTitle release];
        shapeTitle = nil;
    }
}

- (void)slideToDurationView {
    DLog(@"slide to duration view");
    [bigScrollView setHidden:NO];
}

- (void)slideToTitleView {
    DLog(@"slide to title view");
    if (!titleView) {
        titleView = [[TDTitleView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 20 - 44 - 44)];
        titleView.delegate = self;
        [self.view addSubview:titleView];
    }
    titleView.titleInput.text = changeTimerData.content;
    [titleView setHidden:NO];
}

- (void)slideToShapeSelectView {
    DLog(@"slide to shape select view.");
    if (!shapeTitle) {
        shapeTitle = [[UITextField alloc] initWithFrame:
                      CGRectMake(4, 48, self.view.bounds.size.width - 8, 30)];
        shapeTitle.borderStyle = UITextBorderStyleBezel;
        shapeTitle.text = [changeTimerData content];
        [self.view addSubview:shapeTitle];
    }
    
    if (!shapeTableViewController) {
        self.shapeTableViewController = [[TDShapeTableViewController alloc] initWithNibName:@"TDShapeTableViewController" bundle:nil];
        int figureIndex = changeTimerData.figureIndex;
        DLog(@"figureIndex: %d", figureIndex);
        shapeTableViewController.figureIndex = figureIndex;
        shapeTableViewController.delegate = self;
        [self.view addSubview:shapeTableViewController.view];
    }
    shapeTableViewController.view.frame = CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height - 84);
}

- (void)slideToSoundView {
    DLog(@"slide to sound view");
    if (!soundTableViewController) {
        soundTableViewController = [[TDSoundTableViewController alloc] initWithNibName:@"TDSoundTableViewController" bundle:nil];
//        soundTableViewController = [[TDSoundTableViewController alloc] initWithStyle:UITableViewStylePlain];
        soundTableViewController.soundTimerData = changeTimerData;
        soundTableViewController.delegate = self;
        soundTableViewController.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        [self.view addSubview:soundTableViewController.view];
    }
    soundTableViewController.view.hidden = NO;
}

- (void)slideToFigureView {
    DLog(@"slide to figure view");
}

- (void)setupButtonsForTimer {
    DLog(@"setup Buttons for timer.");

    NSString *path = [[NSBundle mainBundle] pathForResource:@"DemoSixTimer" ofType:@"plist"];
    if (!demoLists) {
        demoLists = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"lists"] retain];
    }
    
    UIButton *testButton = nil;
    UIImage *backImage = [[UIImage imageNamed:@"BlackButtonBackground.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    for (int i = 0 ; i < 6; ++i) {
        testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        testButton.frame = CGRectMake((int)(i%3 * (80 + 30) + 10),
                                      (int)(floor(i/3) * (40 + 10) + 230),
                                      80,
                                      40);
        testButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        testButton.tag = i;
//        [testButton setValue:[NSNumber numberWithInt:(i * 60)] forKey:kTimerLength];
        testButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        testButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
        
        if (i < 6) {
            [testButton setTitle:[kDelegate convertSeconds:[demoLists objectAtIndex:i]] forState:UIControlStateNormal];
        } else {
            NSString *title = nil;
            switch (i) {
                case 6:
                    title = NSLocalizedString(@"Timer", nil);
                    break;
                case 7:
                    title = NSLocalizedString(@"Title", nil);
                    break;
                case 8:
                    title = NSLocalizedString(@"Sound", nil);
                    break;
                default:
                    title = NSLocalizedString(@"Cooking", nil);
                    break;
            }
            [testButton setTitle:title forState:UIControlStateNormal];
        }
        [testButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [testButton addTarget:self action:@selector(readyToChange:) forControlEvents:UIControlEventTouchUpInside];
        [bigScrollView addSubview:testButton];
    }
}

- (void)loadTabbar {
    NSArray *newArray = [NSArray arrayWithObjects:NSLocalizedString(@"Duration", nil),
                         NSLocalizedString(@"Title & Figure",nil),
                         NSLocalizedString(@"Sound",nil),
//                         NSLocalizedString(@"Figure",nil),
                         nil];
    PPSTabView *newTabbar = [[PPSTabView alloc] initWithNumbers:newArray andFrame:CGRectMake(0, 0, 320, 44)];
    newTabbar.delegate = self;
    [self.view addSubview:newTabbar];
    [newTabbar release];
}

- (void)loadTitleForTimerPicker {
    CGFloat height = 94;
    //Hour
    CGRect hourRect = CGRectMake(50, height, 46, 30);
    [self loadLabel:@"小时" withFrame:hourRect];
    
    //Minute
    CGRect minuteRect = CGRectMake(150, height, 46, 30);
    [self loadLabel:@"分" withFrame:minuteRect];
    
    //Second
    CGRect secondRect = CGRectMake(250, height, 46, 30);
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
    [bigScrollView addSubview:hourLabel];
    [hourLabel release];
}

- (void)setTimer:(TimerData *)newData animated:(BOOL)yesOrNo {
    self.changeTimerData = newData;
    if (!originTimer) {
        self.originTimer = [newData originTimer];
    }
    self.selectedTimer = [newData howlong];
    NSString *resultStr = [kDelegate convertSeconds:self.selectedTimer];
    DLog(@"Timer Detail, get'%@'",resultStr);
    NSArray *array = [resultStr componentsSeparatedByString:@":"]; 
    for (int i = 0; i < 3; ++i) {
//        DLog(@"compont:%i,set value:%d", i,[[array objectAtIndex:i] intValue]);
        [timerSetter selectRow:[[array objectAtIndex:i] intValue] inComponent:i animated:yesOrNo];
    }
}

#pragma mark -
#pragma mark TDFigureTableViewControllerDelegate
- (void)selectedFigure:(int)index
{
    DLog(@"delegate, selected figure.%d", index);
    changeTimerData.figureIndex = index;
}

#pragma mark -
#pragma mark TDTitleViewDelegate

- (void)titleViewChangeTo:(NSString *)newTitleStr {
    DLog(@"TimeDetail,title view changed.%@", newTitleStr);
    changeTimerData.content = newTitleStr;
}

#pragma mark -
#pragma mark PPSTabViewDelegate
- (void)tabViewSelected:(int)index {
    DLog(@"TimeDetail VC, index:%d",index);
    [self hiddenAllSubViews];
    switch (index) {
        case 0:
            [self slideToDurationView];
            break;
        case 1:
            [self slideToShapeSelectView];
            break;
        case 2:
            [self slideToSoundView];
            break;
        case 4:
            [self slideToFigureView];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark PickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *result = nil;
    int numI = [pickerView selectedRowInComponent:0];
    int numII = [pickerView selectedRowInComponent:1];
    int numIII = [pickerView selectedRowInComponent:2];
    int sum = numI * 3600 + numII * 60 + numIII;
    result = [NSNumber numberWithInt:sum];
    self.selectedTimer = result;
    changeTimerData.howlong = result;
}

#pragma mark -
#pragma mark TDSoundTableViewDelegate

- (void)selectedSound:(TimerData *)typeData {
    DLog(@"Timer Detail selected:%@", typeData);
    changeTimerData.soundName = typeData.soundName;
    changeTimerData.soundIndex = typeData.soundIndex;
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

#pragma mark -
#pragma mark lifecyc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        DLog(@"init the Timer detail view controller.");
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Default", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(resetDefault:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
        
        timerSetter.showsSelectionIndicator = YES;
    }
    return self;
}

- (void)dealloc
{
    [soundTableViewController release];
    [shapeTableViewController release];
    [titleView release];
    [changeTimerData release];
    [originTimer release];
    [demoLists release];
    [selectedTimer release];
    [timerSetter release];
    [bigScrollView release];
    [titleBar release];
    [soundBar release];
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
    bigScrollView.contentSize = CGSizeMake(320, 800);
    bigScrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTitleForTimerPicker];
    
    viewIndex = timer;
    
    [self loadTabbar];
    
    [self setupButtonsForTimer];
    
//    [self modifyBarLocation];
}

- (void)viewDidUnload
{
    [timerSetter release];
    timerSetter = nil;
    [bigScrollView release];
    bigScrollView = nil;
    [titleBar release];
    titleBar = nil;
    [soundBar release];
    soundBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"Timer Detail View will disappear");
    [self hiddenAllSubViews];
//    changeTimerData.howlong = selectedTimer;
    changeTimerData.originTimer = selectedTimer;
    changeTimerData.status = ready;
    [delegate selectedTimer:changeTimerData];
}

@end
