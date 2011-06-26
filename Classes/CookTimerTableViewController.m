//
//  CookTimerTableViewController.m
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import "CookTimerTableViewController.h"
#import "CommonDefines.h"
#import "TimerCell.h"
#import "AddCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CookTimerTableViewController (PrivateMethods)

- (void)playAudioFile:(NSString *)filePath;

//初始化时间表
- (void)initDemoList;

- (void)addCellMethod:(NSNotification *)newNotifi;

- (IBAction)loadTimerSchema:(id)sender;

- (IBAction)touchTheSeg:(id)sender;

- (void)updateCell:(TimerCell *)cell atIndexPath:(NSIndexPath *)indexPath;

//start timer methods 
- (void)delayStart;

- (void)customRefreshTitle;

- (void)stopListsRunning;

@end

@implementation CookTimerTableViewController

@synthesize lists;
@synthesize player;

#pragma mark -
#pragma mark PullTableViewController Methods
//start timer methods 
- (void)delayStart {
    DLog(@"We start Timer all.");
    [self stopLoading];
    TimerData *item = nil;
    for (int i = 0; i < [lists count]; ++i) {
        item = [lists objectAtIndex:i];
        [item clickEvent:i];
    }
}

- (void)refresh {
    if ([lists count] > 0) {
        [self performSelector:@selector(delayStart) withObject:nil afterDelay:0.8f];
    } else {
        [self stopLoading];
    }
}

#pragma mark-
#pragma mark Public Methods

- (void)stopListsRunning {
    TimerData *item = nil;
    for (int i = 0; i < [lists count]; ++i) {
        item = [lists objectAtIndex:i];
        [item stop];
    }
}

- (void)updateSectionZero {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (IBAction)deleteAllTheTimers:(id)sender {
    DLog(@"CookTimer TableViewController,delete all timers.");
    [self stopListsRunning];

    self.lists = [NSMutableArray array];
    [self updateSectionZero];
    
}

- (IBAction)deleteLastTimer:(id)sender {
    DLog(@"CookTimer TableViewController,delete last timer.");
    TimerData *lastItem = [lists lastObject];
    if (lastItem) {
        int lastIndex = [lists count] - 1;
        [lastItem stop];
        [lists removeLastObject];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:lastIndex inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (IBAction)addTemplateTimer:(id)sender {
    DLog(@"CookTimer TableViewController,add template timer.");
    [self addCellMethod:nil];
}

#pragma mark -
#pragma mark Local Notifications
- (void)scheduleAlarmForDate:(NSDate *)theDate withContent:(NSString *)warnningStr{
	
	UIApplication *app = [UIApplication sharedApplication];
//	NSArray *oldNotifications = [app scheduledLocalNotifications];
//	
//	// Clear out the old notification before scheduling a new one.
//	if (0 < [oldNotifications count]) {
//		
//		[app cancelAllLocalNotifications];
//	}
	
	// Create a new notification
	UILocalNotification *alarm = [[UILocalNotification alloc] init];
	if (alarm) {
        
		alarm.fireDate = theDate;
		alarm.timeZone = [NSTimeZone defaultTimeZone];
		alarm.repeatInterval = 0;
		alarm.soundName = @"rington01.caf";//@"default";
//		alarm.alertBody = [NSString stringWithFormat:@"Time to wake up!Now is\n[%@]", 
//						   [NSDate dateWithTimeIntervalSinceNow:10]];
        alarm.alertBody = warnningStr;
		
		[app scheduleLocalNotification:alarm];
		[alarm release];
	}
}

- (void)customRefreshTitle
{
    self.textPull = NSLocalizedString(@"Pull down to start timers all...", nil);
    self.textRelease = NSLocalizedString(@"Release to start timers all...", nil);
    self.textLoading = NSLocalizedString(@"Loading...", nil);
}


- (void)startTimer:(int)index {
    DLog(@"CookTimerTVC,start Timer.");
    TimerData *currentData = [lists objectAtIndex:index];
    if ([currentData status] == ready) {
        [currentData startNewThread];
    }
    [currentData setStatus:start];
}

- (void)stopTimer:(int)index {
    DLog(@"CookTimerTVC,Stop Timer.");
    TimerData *currentData = [lists objectAtIndex:index];
    [currentData setStatus:stop];
}

- (void)clickPlay:(int)index {
    if (index != NSNotFound) {
        DLog(@"CookTimerTVC, click Play.%d,\n%@",index, (TimerData *)[lists objectAtIndex:index]);
        [(TimerData *)[lists objectAtIndex:index] clickEvent:index];
    } else {
        DLog(@"CookTimerTVC, click Play not found.");
    }
}

- (int)indexOfLists:(TimerData *)data {
    int index = [lists indexOfObject:data];
    DLog(@"TimerData:%@,\nindex:%d",data ,index);
    return index;
}

- (void)playAudioFile:(NSString *)filePath {
    if (!filePath) {
        DLog(@"Audio file is not exsit.");
        return;
    }
    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath:filePath] autorelease];
    //NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sample2ch" ofType:@"m4a"]];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.numberOfLoops = 0;
    if ([player isPlaying]) {
        [player stop];
    }
    [player play];
}

- (void)playFinshedSound {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    DLog(@"Play finished sound!");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rington01" ofType:@"caf"];
    [self playAudioFile:filePath];
    [pool release];
}
#pragma mark -
#pragma mark Notification Methods

- (void)addCellMethod:(NSNotification *)newNotification {
    NSNumber *defaultTime = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey];
    DLog(@"Ready to add New Cell.'%@'",defaultTime);
    BOOL isAdd = YES;
#ifdef MAKE_LITE
    if ([lists count] > 5) {
        isAdd = NO;
    }
#else
    isAdd = YES;
#endif
    if (isAdd) {
        tableViewStatus = addMode;
        TimerData *newTimer = [NSKeyedUnarchiver unarchiveObjectWithData:
                               [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerDataKey]];
        newTimer.delegate = self;
//        newTimer.howlong = defaultTime;
//        newTimer.status = ready;
        [lists addObject:newTimer];
//        [newTimer release];
        DLog(@"lists count:%d",[lists count]);
        DLog(@"We will add:%@", newTimer);
        [self.tableView beginUpdates];
        NSUInteger lastIndex = [lists count] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        [(TimerCell *)cell updateTimer];
        
        [self performSelectorInBackground:@selector(saveCurrentLists) withObject:nil];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
//        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        [kDelegate showMessage:NSLocalizedString(@"It's lite version,No more than 6 timers!", nil)];
    }
}

#pragma mark -
#pragma mark PRVIATE
//save current lists for timers.
- (void)loadDemoTimerLists {
    self.lists = [NSMutableArray array];
    NSString *pathDemo = [[NSBundle mainBundle] pathForResource:@"TimerLists" ofType:@"plist"];
    NSDictionary *demoDict = [NSDictionary dictionaryWithContentsOfFile:pathDemo];
    NSMutableArray *tempArray = [[demoDict objectForKey:@"Cooking"] objectForKey:@"Cook Fish"];
    TimerData *item = nil;
    if (tempArray) {
        for (int i = 0; i < [tempArray count]; ++i) {
            item = [[TimerData alloc] init];
            item.howlong = [[tempArray objectAtIndex:i] objectForKey:@"timer"];
            item.originTimer = [[tempArray objectAtIndex:i] objectForKey:@"timer"];
            item.content = [[tempArray objectAtIndex:i] objectForKey:@"type"];
            item.status = ready;
            item.endDate = nil;
            item.delegate = self;
            [lists addObject:item];
            [item release];
        }
    }
}

- (void)loadSavedLists {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    DLog(@"save current lists.");
    tableViewStatus = none;
    self.lists = [NSKeyedUnarchiver unarchiveObjectWithFile:kCurrentListsPath];
    TimerData *item = nil;
    for (item in lists) {
        DLog(@"item:%@",item);
        item.delegate = self;
    }
    [pool release];
}

- (void)saveCurrentLists {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    tableViewStatus = none;
    [NSKeyedArchiver archiveRootObject:lists toFile:kCurrentListsPath];
    DLog(@"save current lists.\n%@",lists);
    [pool release];
}

- (void)saveAndStopCookTimer {
    DLog(@"CookTimer TableViewController. save and stop cook timer.");
    NSDate *endDate = nil;
    NSTimeInterval endHowlong = 0;
    BOOL running = NO;
    [kDelegate clearLocalQueueForLocalNotifications];

    BOOL startNextTimer = [[[NSUserDefaults standardUserDefaults] objectForKey:kStartNextTimer] boolValue];
    for (TimerData *item in self.lists) {
        switch ([(TimerData *)item status]) {
            case ready:
                if (running && startNextTimer) {
                    endHowlong = endHowlong + [[(TimerData *)item howlong] floatValue];
                    DLog(@"Running howlong:%.2f",endHowlong);
                    endDate = [NSDate dateWithTimeIntervalSinceNow:endHowlong];
                    [(TimerData *)item setEndDate:endDate];
                    [self scheduleAlarmForDate:endDate withContent:
                     [NSString stringWithFormat:@"wake up!%@",[(TimerData *)item content]]];
                }
                break;
            case start:
                running = YES;
                [(TimerData *)item setStatus:stop];
                endHowlong = [[(TimerData *)item howlong] floatValue];
                DLog(@"Ending howlong:%.2f",endHowlong);
                endDate = [NSDate dateWithTimeIntervalSinceNow:endHowlong];
                [(TimerData *)item setEndDate:endDate];
                [self scheduleAlarmForDate:endDate withContent:[NSString stringWithFormat:@"wake up!%@",[(TimerData *)item content]]];
                break;
            case stop:
//                [(TimerData *)item setEndDate:nil];
                running = NO;
                endHowlong = 0;
                break;
            case finished:
//                [(TimerData *)item setEndDate:nil];
                running = NO;
                endHowlong = 0;
                break;
            default:
                running = NO;
                endHowlong = 0;
//                [(TimerData *)item setEndDate:nil];
                break;
        }
    }
    
    [self saveCurrentLists];
}

//When active we resume all the clock.
- (void)resumeAllCookTimer {
    [self loadSavedLists];
    DLog(@"resume all cook timer.%@",lists);
    NSTimeInterval betweenTime;
    NSDate *endDate = nil;
    NSDate *startDate = nil;
    NSDate *nowDate = [NSDate date];
    TimerData *item = nil;
    
    //already clear local notification in kDelegate methods.
    if (lists != nil) {
        for (int i = 0; i < [lists count]; ++i) {
            item = [lists objectAtIndex:i];
            endDate = [(TimerData *)item endDate];
            if (endDate != nil) {
                startDate = [endDate dateByAddingTimeInterval:(- [[(TimerData *)item howlong] floatValue])];
                betweenTime = [endDate timeIntervalSinceDate:nowDate] - [[(TimerData *)item howlong] floatValue];
                if ([nowDate compare:startDate] == NSOrderedDescending) {
                    if ([nowDate compare:endDate] == NSOrderedAscending) {
                        /* cut float to int. if not will slpash colon wrong. beause the float is not .000*/
                        betweenTime = (int)[endDate timeIntervalSinceDate:nowDate];
                        DLog(@"YES, In(%.2f)", betweenTime);
                        item.status = start;
                        item.howlong = [NSNumber numberWithFloat:betweenTime];
                        [item start];
                    } else {
                        DLog(@"NO, expired.");
                        item.status = finished;
                        item.howlong = item.originTimer;
                        [item finished];
                    }
                } else {
                    DLog(@"NO, not reached!");
                }
                DLog(@"startDate:%@,endDate:%@,between Time:%.2f", startDate, endDate, betweenTime);
            } else {
                DLog(@"The origin is not fired!");
                
            }
            item.endDate = nil;
        }
        [self saveCurrentLists];
    }
    [self.tableView reloadData];
}

- (void)updateListsTimer:(TimerData *)data row:(NSIndexPath *)indexPath {
//    DLog(@"update list timer:%@, indexPath:%@",[data howlong], indexPath);
    [lists replaceObjectAtIndex:indexPath.row withObject:data];
    if (!self.tableView.editing) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isDescendantOfView:[kDelegate window]]) {
            DLog(@"CookTimer update~~~~");
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
//    
}

//初始化时间表
- (void)initDemoList {
    NSString *path = nil;
    TimerData *tempItem = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:kCurrentListsPath]) {
        DLog(@"Current file exist.");
        [self loadSavedLists];
    } else {
        self.lists = [NSMutableArray array];
        [self loadDemoTimerLists];
//        path = [[NSBundle mainBundle] pathForResource:@"TimerDemo" ofType:@"plist"]; 
//        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"Demo"]];
//        for (int i = 0; i < [tempArray count]; ++i) {
//            tempItem = [[TimerData alloc] init];
//            tempItem.delegate = self;
//            tempItem.howlong = [tempArray objectAtIndex:i];
//            tempItem.originTimer = [tempArray objectAtIndex:i];
//            tempItem.status = ready;
//            [lists addObject:tempItem];
//            [tempItem release];
//        }
        [self saveCurrentLists];
    }
}

- (IBAction)touchTheSeg:(id)sender {
    DLog(@"You have touch the segment.%@",sender);
}

- (IBAction)addTimerItem:(id)sender {
	DLog(@"Cooker Timer ViewController, add timer Item.");
//	AddTimerViewController *addVC = [[AddTimerViewController alloc] initWithNibName:@"AddTimerViewController" bundle:nil];
//	UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addVC];
//	[addVC release];
//	[self.navigationController presentModalViewController:addNavigation animated:YES];
//	[addNavigation release];
}

- (IBAction)loadTimerSchema:(id)sender {
    DLog(@"try to load timer schema.");
    SchemaTableViewController *schemaTVC = [[SchemaTableViewController alloc] initWithStyle:UITableViewStylePlain];
    schemaTVC.delegate = self;
//    schemaTVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Nav_Load_320x44.png"]];
    UINavigationController *loadSchemaNavigationController = [[UINavigationController alloc] initWithRootViewController:schemaTVC];
    [schemaTVC release];
    loadSchemaNavigationController.navigationBar.tintColor = [UIColor colorWithRed:0.03921f green:0.03921f blue:0.03921f alpha:1.0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nav_Load_320x44.png"]];
    [loadSchemaNavigationController.navigationBar addSubview:imageView];
    [loadSchemaNavigationController.navigationBar sendSubviewToBack:imageView];
    [imageView release];
//    loadSchemaNavigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Nav_Load_320x44.png"]];
    [self.navigationController presentModalViewController:loadSchemaNavigationController animated:YES];
    [loadSchemaNavigationController release];
}

- (void)delayReload {
    [self.tableView setEditing:yesOrNO animated:YES];
}

- (void)editTable {
    yesOrNO = !self.tableView.editing;
//    NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView endUpdates];
    [self.tableView setEditing:yesOrNO animated:YES];
    
//	[self performSelector:@selector(delayReload) withObject:nil afterDelay:0.3f];
}

- (void)configTitleView {
    [seg setTitle:NSLocalizedString(@"Stop", nil) forSegmentAtIndex:0];
    [seg setTitle:NSLocalizedString(@"Play", nil) forSegmentAtIndex:1];
    [seg setTitle:NSLocalizedString(@"Clear", nil) forSegmentAtIndex:2];
    [seg addTarget:self action:@selector(touchTheSeg:) forControlEvents:UIControlEventValueChanged];
}

- (void)updateCell:(TimerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell setTimer:[[lists objectAtIndex:[indexPath row]] howlong]];
}

#pragma mark -
#pragma mark View lifecycle

- (void) loadBarButoonItem {
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(loadTimerSchema:)];
    self.navigationItem.rightBarButtonItem = addItem;
	[addItem release];
	
	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    self.navigationItem.leftBarButtonItem = editItem;
	[editItem release];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",nil) 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:nil 
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDemoList];
    
    [self loadBarButoonItem];
    
    [self customRefreshTitle];
    
//    UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
//    bg.backgroundColor = [UIColor blackColor];
//    self.tableView.backgroundView = bg;
//    [bg release];
    
//    UIImageView *pbcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
//    pbcView.image = [UIImage imageNamed:@"PBC_02.png"];
//    pbcView.contentMode = UIViewContentModeScaleAspectFill;
//    pbcView.alpha = 0.1f;
//    [self.tableView setBackgroundView:pbcView];
//    [pbcView release];
    
    self.navigationItem.hidesBackButton = NO;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    
    
//    [self configTitleView];
    self.navigationItem.title = NSLocalizedString(@"EeeTimer", nil);
    
    
    
//    UIView *topview = [[[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)] autorelease];
//    topview.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
//    [self.tableView addSubview:topview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCellMethod:) name:kNotificationAddCell object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentLists) name:kNotificationTerminalCookTimer object:nil];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [lists count];
        case 1:
            return 1;
    }
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *AddIdentifier = @"Add";
    UITableViewCell *cell = nil;
    TimerData *currentData = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[TimerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [(TimerCell *)cell setRootViewController:self];
        }
        //Configure the Timer Cell. only get current date to display.
        currentData = [lists objectAtIndex:indexPath.row];
//        currentData.indexPath = indexPath;
        [(TimerCell *)cell setCurrentTimer:currentData];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:AddIdentifier];
        if (cell == nil) {
            cell = [[[AddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIdentifier] autorelease];
            [(AddCell *)cell setRootViewController:self];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (yesOrNO && indexPath.row == [lists count]) {
        if (indexPath.section == 0) {
            return 0;
        }
    }
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 60;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    UIButton *addMeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [footView addSubview:addMeButton];
//    addMeButton.frame = CGRectMake(4, 4, 312, 52);
//    addMeButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
//    [addMeButton setTitle:@"+" forState:UIControlStateNormal];
//    return footView;
//}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
//    DLog(@"Edit BOOL.");
    if (indexPath.section == 1) {
        
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
//        DLog(@"delete cell, %@,%@",lists,indexPath);
        [self.tableView beginUpdates];
        [(TimerData *)[lists objectAtIndex:indexPath.row] stop];
        [lists removeObjectAtIndex:indexPath.row];
        [self performSelectorInBackground:@selector(saveCurrentLists) withObject:nil];
//        [[tableView cellForRowAtIndexPath:indexPath] setReuseIdentifier:Nil];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        DLog(@"After delete cell, %@,%@",lists,indexPath);
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    int count = [lists count];
    if (fromIndexPath.row < count && toIndexPath.row < count) {
        int oldPlace = fromIndexPath.row;
        DLog(@"OK move.from:'%d' to:'%d'",fromIndexPath.row, toIndexPath.row);
        TimerData *tempData = [[lists objectAtIndex:oldPlace] retain];
//        [tempData setIndexPath:toIndexPath];
        [lists removeObjectAtIndex:oldPlace];
        [lists insertObject:tempData atIndex:toIndexPath.row];
        [tempData release];
        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:fromIndexPath];
//        [(TimerCell *)cell setIndexPath:toIndexPath];
//        DLog(@"list:%@",lists);
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
//    DLog(@"Can MOve BOOL.");
//    if (indexPath.row == [lists count]) {
//        return NO;
//    }
    return YES;
}

#pragma mark -
#pragma mark Schema TableView delegate
- (void)selectedArray:(NSArray *)array {
    DLog(@"CookTimer, load array:%@",array);
    
    [self stopListsRunning];
    
    TimerData *item = nil;
    self.lists = [NSMutableArray array];
    NSDictionary *itemDict = nil;
    for (int a = 0 ; a < [array count]; ++a) {
        item = [[TimerData alloc] init];
        itemDict = [array objectAtIndex:a];
        item.originTimer = [itemDict objectForKey:@"timer"];
        item.howlong = [itemDict objectForKey:@"timer"];
        item.content = [itemDict objectForKey:@"type"];
        item.delegate = self;
        [self.lists addObject:item];
        [item release];
        item = nil;
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    TimerData *currentItem = [lists objectAtIndex:indexPath.row];
    if ([currentItem status] != start) {
        TimerDetailViewController *detailViewController = [[TimerDetailViewController alloc] 
                                                           initWithNibName:@"TimerDetailViewController" bundle:nil];
        detailViewController.title = NSLocalizedString(@"设定闹钟时间", nil);
        detailViewController.hidesBottomBarWhenPushed = YES;
        detailViewController.delegate = self;
        detailViewController.changeTimerData = [lists objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController setTimer:[lists objectAtIndex:indexPath.row] animated:NO];
        [detailViewController release];
    } 
    else {
        [kDelegate earthquake:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark -
#pragma mark TimerDetailViewControllerDelegate

//Callback for selected Timer
- (void)selectedTimer:(TimerData *)newTimerData {
    NSIndexPath *lastIndexPath = [self.tableView indexPathForSelectedRow];
    DLog(@"CookTimerVC have received:%@",newTimerData);
    DLog(@"seletecd:%@",lastIndexPath);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
    if ([cell respondsToSelector:@selector(setTimer:)]) {
        TimerData *item = (TimerData *)[lists objectAtIndex:[lastIndexPath row]];
//        if ([[newTimerData howlong] intValue] != [item.howlong intValue]) {
////            item.status = ready;
////            [item setOriginTimer:newTimerData.originTimer];
////            [item setHowlong:newTimerData.howlong];
////            [item setContent:newTimerData.content];
////            [(TimerCell *)cell setCurrentTimer:item];
//            
//        } else {
//            DLog(@"There are same. no update timer.");
//        }
        newTimerData.delegate = self;
        [lists replaceObjectAtIndex:[lastIndexPath row] withObject:newTimerData];
        [(TimerCell *)cell setCurrentTimer:[lists objectAtIndex:[lastIndexPath row]]];
        [self saveCurrentLists];
    }
}

#pragma mark -
#pragma mark TimerDataDelegate

- (void)updateTimer:(int)index {
//    DLog(@"CookTimerTVC, update Timer at '%d'",index);
    [self updateListsTimer:[lists objectAtIndex:index] row:[NSIndexPath indexPathForRow:index inSection:0]];
}

//When the timer is finished, we call it to deal with the finished things.
- (void)finishedTimer:(int)index {
    DLog(@"finished timer:%d",index);
    [self updateTimer:index];
    [self performSelectorInBackground:@selector(playFinshedSound) withObject:nil];
    TimerData *newData = [self.lists objectAtIndex:index];
    newData.howlong = newData.originTimer;
    newData.status = finished;
    //reset the cell config. tag to finished!
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [(TimerCell *)cell setTimeData:newData];
    [(TimerCell *)cell performSelector:@selector(timerFinished:) 
                            withObject:newData.originTimer
                            afterDelay:1.0f];
    //start Next Timer
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kStartNextTimer] boolValue]) {
        DLog(@"Start NextTimer.");
        if ((index + 1) < [lists count]) {
            TimerData *nextItem = [lists objectAtIndex:(index + 1)];
            switch ([nextItem status]) {
                case ready:
                    [nextItem start];
                    break;
                case start:
                    ;
                    break;
                case stop:
                    ;
                    break;
                case finished:
                    ;
                    break;
                default:
                    break;
            }
        }
    } else {
        DLog(@"Don't start nextimer.");
    }
}

- (void)splashTimer:(int)splashIndex {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:splashIndex inSection:0]];
    if (!self.tableView.editing) {
        if ([cell isDescendantOfView:[kDelegate window]]) {
            [(TimerCell *)cell splashSeconds];
        }
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [seg release];
    seg = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [player release];
    [lists release];
    [seg release];
    [super dealloc];
}


@end

