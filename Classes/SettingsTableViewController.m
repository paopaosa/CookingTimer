//
//  SettingsTableViewController.m
//  CookingTImer
//
//  Created by user on 11-5-15.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "CommonDefines.h"
#import "HelpTableViewController.h"

@interface SettingsTableViewController (LOcaleExtend)

- (void)pushToTimerSettings;
- (void)pushToHelpView;

@end

@implementation SettingsTableViewController

@synthesize lists;

#pragma mark -
#pragma mark TimerDetailViewControllerDelegate
- (void)selectedTimer:(int)newTimer {
    NSNumber *oldDefaultTimer = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey];
    NSNumber *newDefaultTimer = [NSNumber numberWithInt:newTimer];
    if ([oldDefaultTimer intValue] != newTimer) {
        [[NSUserDefaults standardUserDefaults] setObject:newDefaultTimer forKey:kDefaultTimerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *newDefaultTimerStr = [kDelegate convertSeconds:[NSNumber numberWithInt:newTimer]];
    DLog(@"You have reset default to New Value:%@",newDefaultTimerStr);
    UILabel *timerDefaultLabel = [self.tableView viewWithTag:kTAG_DefaultTime];
    timerDefaultLabel.text = newDefaultTimerStr;
}

#pragma mark -
#pragma mark PRIVATE

- (void)loadLists {
    DLog(@"load lists for Settings.");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setuplists" ofType:@"plist"];
    self.lists = [NSDictionary dictionaryWithContentsOfFile:path];
    DLog(@"lists:'%@',path'%@'",lists,path);
    DLog(@"version:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
}

- (IBAction)switchStartNextTimer:(id)sender {
    DLog(@"Switch Start next timer.");
    BOOL startNextTimer = ![[[NSUserDefaults standardUserDefaults] objectForKey:kStartNextTimer] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:startNextTimer] forKey:kStartNextTimer];
}

#pragma mark -
#pragma mark lifecyc

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [lists release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = NSLocalizedString(@"设置", nil);
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadLists];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [[lists objectForKey:@"lists"] count];
        case 1:
            return [[lists objectForKey:@"version"] count];   
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *nameLabel = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 12, 140, 20)];
        nameLabel.tag = 200 + indexPath.row;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.textAlignment = UITextAlignmentLeft;
        [[cell contentView] addSubview:nameLabel];
        [nameLabel release];
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 8, 80, 20)];
            newSwitch.tag = 203;
            [newSwitch addTarget:self action:@selector(switchStartNextTimer:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:newSwitch];
            [newSwitch release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1 && indexPath.section == 0) {
            UILabel *defaultTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 80, 30)];
            defaultTimerLabel.text = [kDelegate convertSeconds:[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey]];
            defaultTimerLabel.font = [UIFont boldSystemFontOfSize:16];
            defaultTimerLabel.textColor = [UIColor lightGrayColor];
            defaultTimerLabel.tag = kTAG_DefaultTime;
            defaultTimerLabel.textAlignment = UITextAlignmentRight;
            [cell addSubview:defaultTimerLabel];
            [defaultTimerLabel release];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else if (indexPath.row == 0 && indexPath.section == 1) {
            UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 80, 30)];
            versionLabel.textAlignment = UITextAlignmentRight;
            versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            [cell addSubview:versionLabel];
            [versionLabel release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1 && indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // Configure the cell...
    nameLabel = (UILabel *)[cell viewWithTag:(200 + indexPath.row)];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UISwitch *newSwitch = (UISwitch *)[cell viewWithTag:203];
            BOOL yesOrNo = NO;
            NSNumber *startNextTimer = [[NSUserDefaults standardUserDefaults] objectForKey:kStartNextTimer];
            if (newSwitch) {
                if (startNextTimer) {
                    yesOrNo = [startNextTimer boolValue];
                } else {
                    //set Default startNextTimer to YES:
                    yesOrNo = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kStartNextTimer];
                }
                [newSwitch setOn:yesOrNo];
            }
        }
        nameLabel.text = [[[lists objectForKey:@"lists"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    } else {
        nameLabel.text = [[[lists objectForKey:@"version"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"设置",nil);
    } else {
        return NSLocalizedString(@"其它",nil);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)pushToTimerSettings {
    TimerDetailViewController *detailViewController = [[TimerDetailViewController alloc] 
                                                       initWithNibName:@"TimerDetailViewController" 
                                                       bundle:nil];
    detailViewController.hidesBottomBarWhenPushed = YES;
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController setTimer:[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey] animated:NO];
    [detailViewController release];
}

- (void)pushToHelpView {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleDone target:nil action:nil];
    HelpTableViewController *helpTVC = [[HelpTableViewController alloc] initWithNibName:@"HelpTableViewController" bundle:nil];
    helpTVC.hidesBottomBarWhenPushed = YES;
    helpTVC.title = NSLocalizedString(@"Help", nil);
    [self.navigationController pushViewController:helpTVC animated:YES];
    [helpTVC release];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    ;
                    break;
                case 1:
                    [self pushToTimerSettings];
                    break;
                default:
                    break;
            };
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    ;
                    break;
                case 1:
                    [self pushToHelpView];
                    break;
                default:
                    break;
            };
            break;
        default:
            break;
    }
    
    
}


@end
