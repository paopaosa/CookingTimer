//
//  CookTimerTableViewController.m
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import "CookTimerTableViewController.h"
#import "CommonDefines.h"
#import "AddTimerViewController.h"
#import "TimerCell.h"
#import "AddCell.h"
#import "TimerDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CookTimerTableViewController (PrivateMethods)

//初始化时间表
- (void)initDemoList;

- (void)addCellMethod:(NSNotification *)newNotifi;

@end

@implementation CookTimerTableViewController

@synthesize lists;

#pragma mark -
#pragma mark PRVIATE

- (void)addCellMethod:(NSNotification *)newNotification {
    DLog(@"Ready to add New Cell.");
    BOOL isAdd = YES;
#ifdef MAKE_LITE
    if ([lists count] > 4) {
        isAdd = NO;
    }
#else
    isAdd = YES;
#endif
    if (isAdd) {
        [lists addObject:[NSNumber numberWithInt:300]];
        NSUInteger lastIndex = [lists count] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        [kDelegate showMessage:@"It's lite version,No more than 5 timers!"];
    }
}

//初始化时间表
- (void)initDemoList {
    NSString *path = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:kDefaultListPath]) {
        NSLog(@"No file exist.");
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"TimerDemo" ofType:@"plist"]; 
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        self.lists = [NSMutableArray arrayWithArray:[dict objectForKey:@"Demo"]];
    }
}

- (IBAction)addTimerItem:(id)sender {
	DLog(@"Cooker Timer ViewController, add timer Item.");
	AddTimerViewController *addVC = [[AddTimerViewController alloc] initWithNibName:@"AddTimerViewController" bundle:nil];
	UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addVC];
	[addVC release];
	[self.navigationController presentModalViewController:addNavigation animated:YES];
	[addNavigation release];
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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addTimerItem:)];
    self.navigationItem.rightBarButtonItem = addItem;
	[addItem release];
	
	UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
    self.navigationItem.leftBarButtonItem = editItem;
	[editItem release];
    
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
    
    [self configTitleView];
    
    [self initDemoList];
    
//    UIView *topview = [[[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)] autorelease];
//    topview.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
//    [self.tableView addSubview:topview];
        
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:nil 
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
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
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[TimerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:AddIdentifier];
        if (cell == nil) {
            cell = [[[AddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIdentifier] autorelease];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
//	cell.textLabel.text = [NSString stringWithFormat:@"Timer(%d)",indexPath.row];
    if (indexPath.section == 0) {
        [(TimerCell *)cell setTimer:[lists objectAtIndex:indexPath.row]];
    }
    
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
        [lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        NSNumber *tempNumber = [[lists objectAtIndex:oldPlace] retain];
        [lists removeObjectAtIndex:oldPlace];
        [lists insertObject:tempNumber atIndex:toIndexPath.row];
        [tempNumber release];
//        DLog(@"list:%@",lists);
    } else {
//        DLog(@"Bad move.");
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
    
    TimerDetailViewController *detailViewController = [[TimerDetailViewController alloc] 
                                                       initWithNibName:@"TimerDetailViewController" bundle:nil];
    detailViewController.title = NSLocalizedString(@"设定闹钟时间", nil);
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
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

