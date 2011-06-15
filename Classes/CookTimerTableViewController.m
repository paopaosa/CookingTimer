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
#import "SchemaTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CookTimerTableViewController (PrivateMethods)

//初始化时间表
- (void)initDemoList;

- (void)addCellMethod:(NSNotification *)newNotifi;

- (IBAction)loadTimerSchema:(id)sender;

- (IBAction)touchTheSeg:(id)sender;

- (void)updateCell:(TimerCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CookTimerTableViewController

@synthesize lists;

#pragma mark-
#pragma mark Public Methods

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
    DLog(@"CookTimerTVC, click Play.%d",index);
    [(TimerData *)[lists objectAtIndex:index] clickEvent:index];
}

- (int)indexOfLists:(TimerData *)data {
    int index = [lists indexOfObject:data];
    return index;
}

#pragma mark -
#pragma mark Notification Methods

- (void)addCellMethod:(NSNotification *)newNotification {
    NSNumber *defaultTime = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey];
    DLog(@"Ready to add New Cell.'%@'",defaultTime);
    BOOL isAdd = YES;
#ifdef MAKE_LITE
    if ([lists count] > 4) {
        isAdd = NO;
    }
#else
    isAdd = YES;
#endif
    if (isAdd) {
        tableViewStatus = addMode;
        TimerData *newTimer = [[TimerData alloc] init];
        newTimer.delegate = self;
        newTimer.howlong = defaultTime;
        newTimer.status = ready;
        [lists addObject:newTimer];
        [newTimer release];
        DLog(@"lists count:%d",[lists count]);
        
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
        [kDelegate showMessage:NSLocalizedString(@"It's lite version,No more than 5 timers!", nil)];
    }
}

#pragma mark -
#pragma mark PRVIATE
//save current lists for timers.
- (void)saveCurrentLists {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    tableViewStatus = none;
    [NSKeyedArchiver archiveRootObject:lists toFile:kCurrentListsPath];
    [pool release];
}

- (void)updateListsTimer:(TimerData *)data row:(NSIndexPath *)indexPath {
//    DLog(@"update list timer:%@, indexPath:%@",[data howlong], indexPath);
    [lists replaceObjectAtIndex:indexPath.row withObject:data];
    if (!self.tableView.editing) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
//    
}

//初始化时间表
- (void)initDemoList {
    NSString *path = nil;
    TimerData *tempItem = nil;
    self.lists = [NSMutableArray array];
    if ([[NSFileManager defaultManager] fileExistsAtPath:kDefaultListPath]) {
        DLog(@"No file exist.");
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"TimerDemo" ofType:@"plist"]; 
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"Demo"]];
        for (int i = 0; i < [tempArray count]; ++i) {
            tempItem = [[TimerData alloc] init];
            tempItem.delegate = self;
            tempItem.howlong = [tempArray objectAtIndex:i];
            tempItem.status = ready;
            [lists addObject:tempItem];
            [tempItem release];
        }
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

    [self loadBarButoonItem];

    [seg addTarget:self action:@selector(touchTheSeg:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
    bg.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundView = bg;
    [bg release];
    
    self.navigationItem.hidesBackButton = NO;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *pbcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    pbcView.image = [UIImage imageNamed:@"PBC_02.png"];
    pbcView.contentMode = UIViewContentModeScaleAspectFill;
    pbcView.alpha = 0.1f;
    self.tableView.backgroundView = pbcView;
    [pbcView release];
    
//    [self configTitleView];
    self.title = NSLocalizedString(@"EeeTimer", nil);
    
    [self initDemoList];
    
//    UIView *topview = [[[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)] autorelease];
//    topview.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
//    [self.tableView addSubview:topview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCellMethod:) name:kNotificationAddCell object:nil];
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
        [tempData setIndexPath:toIndexPath];
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
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController setTimer:[[lists objectAtIndex:indexPath.row] howlong] animated:NO];
        [detailViewController release];
    } 
    else {
        [kDelegate earthquake:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark -
#pragma mark TimerDetailViewControllerDelegate

//Callback for selected Timer
- (void)selectedTimer:(int)newTimer {
    NSIndexPath *lastIndexPath = [self.tableView indexPathForSelectedRow];
    DLog(@"CookTimerVC have received:%d",newTimer);
    DLog(@"seletecd:%@",lastIndexPath);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
    if ([cell respondsToSelector:@selector(setTimer:)]) {
        [(TimerCell *)cell setTimer:[NSNumber numberWithInt:newTimer]];
        [[lists objectAtIndex:[lastIndexPath row]] setHowlong:[NSNumber numberWithInt:newTimer]];
        [self saveCurrentLists];
    }
}

#pragma mark -
#pragma mark TimerDataDelegate

- (void)updateTimer:(int)index {
    DLog(@"CookTimerTVC, update Timer at '%d'",index);
    [self updateListsTimer:[lists objectAtIndex:index] row:[NSIndexPath indexPathForRow:index inSection:0]];
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
    [super viewDidUnload];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [lists release];
    [seg release];
    [super dealloc];
}


@end

