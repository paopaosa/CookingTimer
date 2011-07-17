//
//  SchemaTableViewController.m
//  CookingTImer
//
//  Created by user on 11-6-13.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "SchemaTableViewController.h"
#import "TimerData.h"
#import "CommonDefines.h"
#import <QuartzCore/QuartzCore.h>

@implementation SchemaTableViewController

@synthesize listDict;
@synthesize titleAlert;
@synthesize currentTitle;
@synthesize currentLists;
@synthesize selectedItemIndex;
@synthesize delegate;

#pragma mark -
#pragma mark privte 

//load data from local
- (void)loadSchemaData {
    DLog(@"Load Schema Data.");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimerLists" ofType:@"plist"];
    DLog(@"path:%@",path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:kUserDefinationPath]) {
        //if defination exist
        listDict = [[NSMutableDictionary dictionaryWithContentsOfFile:kUserDefinationPath] retain];
    } else {
        //load default and copy to defination.
        listDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        NSMutableArray *tempLists = [[NSMutableDictionary dictionaryWithContentsOfFile:path] objectForKey:@"lists"];
        [listDict setObject:tempLists forKey:@"lists"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:1];
        [listDict setObject:tempArray forKey:kUserDefination];
        [tempArray release];
        [listDict writeToFile:kUserDefinationPath atomically:YES];
    }
}

- (void)saveSchemaData {
    DLog(@"save schema data.");
    [listDict writeToFile:kUserDefinationPath atomically:YES];
}

- (void) exitView {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)addNewsList:(id)sender {
    DLog(@"add news lists to schemaList.");
    if (currentLists) {
        int indexNum = [currentLists count];
        if (indexNum > 0) {
            NSMutableArray *userDefinationArray = [[NSMutableArray alloc] initWithArray:[listDict objectForKey:kUserDefination]];
//            int userDefines = [userDefinationArray count];
            DLog(@"userDefination:%@",[userDefinationArray class]);
            NSDictionary *bigItem = nil;
            NSDictionary *itemDict = nil;
            NSString *insertString = NSLocalizedString(@"Untitled", nil);
            if (currentTitle) {
                insertString = currentTitle;
            }
            
            NSString *bigNameStr = [NSString stringWithFormat:@"%@",insertString];
            //每组时钟的保存位置
            NSMutableArray *tempArray = [NSMutableArray array];
            for (TimerData *item in currentLists) {
                DLog(@"item: %@", item);
                itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            [item originTimer],@"timer",
                            [item content],@"title",
                            [NSNumber numberWithInt:[item figureIndex]],@"type",nil];
                [tempArray addObject:itemDict];
            }
            bigItem = [NSDictionary dictionaryWithObjectsAndKeys:
                       tempArray,@"contents",
                       bigNameStr, @"name",nil];
            [userDefinationArray addObject:bigItem];
            [listDict setObject:userDefinationArray forKey:kUserDefination];
            [self saveSchemaData];
//            [self.tableView reloadData];
            int section = [[listDict objectForKey:@"lists"] count];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[userDefinationArray count]-1 inSection:section];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.currentLists = nil;
            [userDefinationArray release];
        }
    }
}

- (void)deleteItem:(NSIndexPath *)newIndexPath {
    NSMutableArray *userArray = [listDict objectForKey:kUserDefination];
    [userArray removeObjectAtIndex:newIndexPath.row];
   
    // Delete the row from the data source
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self saveSchemaData];
}

#pragma mark -
#pragma mark DDInputAlertDelegate
- (void)nothingChanged {
    DLog(@"nothingChanged");
    //    [newInput release];
    self.titleAlert = nil;
}


- (void)changedTitle:(NSString *)newTitle {
    if ([newTitle length] > 0) {
        NSString *newCopyTitle = [NSString stringWithString:newTitle];
        
        NSMutableArray *userArray = [listDict objectForKey:kUserDefination];
        NSDictionary *changedItem = [userArray objectAtIndex:selectedItemIndex.row];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:changedItem];
        [tempDict setObject:newCopyTitle forKey:@"name"];
        [userArray replaceObjectAtIndex:selectedItemIndex.row withObject:tempDict];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedItemIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self saveSchemaData];
    }
    //    [newInput release];
    self.titleAlert = nil;
}

- (void)changeItemTitle:(NSIndexPath *)newIndexPath {
    
    self.titleAlert = [[DDInputAlert alloc] init];
    titleAlert.title = currentTitle;
    titleAlert.delegate = self;
    [titleAlert showAlert:NSLocalizedString(@"修改列表名称", nil)];
    
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            DLog(@"delete the item.%@", selectedItemIndex);
            [self deleteItem:selectedItemIndex];
            break;
        case 1:
            DLog(@"rename the item.");
            [self changeItemTitle:selectedItemIndex];
            break;
        default:
            break;
    }
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
    [listDict release];
    [selectedItemIndex release];
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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"闹钟模板",nil);
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(exitView)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    [cancelItem release];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"+", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewsList:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    [self loadSchemaData];
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
    int count = [[listDict objectForKey:@"lists"] count];
    DLog(@"number section:%d",count);
    return count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    NSString *selectedKey;
//    if (section < [[listDict allKeys] count]) {
//        selectedKey = [[listDict allKeys] objectAtIndex:section];
//        int count = [[[listDict objectForKey:selectedKey] allKeys] count];
//        DLog(@"count:%d",count);
//        return count;
//    }
//    return 0;
    int count;
    NSArray *listsArray = [listDict objectForKey:@"lists"];
    NSArray *UsersArray = [listDict objectForKey:kUserDefination];
    if (section < [listsArray count]) {
        count = [[[listsArray objectAtIndex:section] objectForKey:@"lists"] count];
    } else {
        count = [UsersArray count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIView *bgColorView = [[UIView alloc] init];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		gradientLayer.frame = CGRectMake(0, 0, 320, cell.frame.size.height);
		gradientLayer.colors = [NSArray arrayWithObjects:
								(id)[UIColor whiteColor].CGColor,
								(id)kColor_ADD_CONTENT_BACKGROUND_GRAY_LIGHT.CGColor,
								(id)kColor_ADD_CONTENT_BACKGROUND_GRAY.CGColor,
								nil];
		gradientLayer.locations = [NSArray arrayWithObjects:
								   [NSNumber numberWithFloat:0.0f],
								   [NSNumber numberWithFloat:0.9f],
								   [NSNumber numberWithFloat:1.1f],nil];
		[bgColorView.layer addSublayer:gradientLayer];
		
		//[bgColorView setBackgroundColor:[UIColor colorWithRed:0.6 green:0.0 blue:0.6 alpha:1.0]];
		[cell setBackgroundView:bgColorView];
		[bgColorView release];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.shadowColor = [UIColor whiteColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    }
    
    // Configure the cell...
//    NSArray *array = [listDict allKeys];
//    NSString *selectedKey = [array objectAtIndex:indexPath.section];
//    NSDictionary *selectedDict = [listDict objectForKey:selectedKey];
//    NSString *keyString = [[selectedDict allKeys] objectAtIndex:indexPath.row];
//    NSArray *selectedArray = [selectedDict objectForKey:keyString];
    
//    DLog(@"%@, %d",[selectedArray class], [selectedArray count]);
    NSString *selectedTitleStr = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    if ([selectedTitleStr isEqualToString:NSLocalizedString(kUserDefination, nil)]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    if (indexPath.section == [[[listDict objectForKey:selectedKey] allKeys] count] - 1) {
//        cell.textLabel.text = @"Default";
//    } else {
////        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d", keyString,[selectedArray count]];
//        cell.textLabel.text = [NSString stringWithFormat:@"ROW -%d",indexPath.row];
//    }
    NSArray *array = [listDict objectForKey:@"lists"];
    NSArray *userArray = [listDict objectForKey:kUserDefination];
    NSString *titleStr = nil;
    NSDictionary *item = nil;
    int section = indexPath.section;
    int row = indexPath.row;
    if (indexPath.section > [array count] - 1) {
        item = [userArray objectAtIndex:row];
        titleStr = [NSString stringWithFormat:@"%@ - %d",
                    NSLocalizedString([item objectForKey:@"name"], nil),
                    [[item objectForKey:@"contents"] count]];
        cell.textLabel.text = titleStr;
    } else {
        item = [[[array objectAtIndex:section] objectForKey:@"lists"] objectAtIndex:row];
        titleStr = [NSString stringWithFormat:@"%@ - %d",
                    NSLocalizedString([item objectForKey:@"name"], nil),
                    [[item objectForKey:@"contents"] count]];
        cell.textLabel.text = titleStr;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 8;
//    cell.textLabel.numberOfLines = 0;
    return cell;
}



- (void)choseActionSheet:(int)index 
{
    DLog(@"chose current:%d", index);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"chose user defination action!" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:NSLocalizedString(@"Rename", nil), nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DLog(@"You have clicked button:%@", indexPath);
//    NSString *selectedTitleStr = [self tableView:tableView titleForHeaderInSection:indexPath.section];
//    if ([selectedTitleStr isEqualToString:NSLocalizedString(kUserDefination, nil)]) {
//        DLog(@"This user defination!");
//    }
    self.selectedItemIndex = indexPath;
    [self choseActionSheet:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleString = nil;
    NSArray *array = [listDict objectForKey:@"lists"];
    if (section > [array count] - 1) {
        titleString = NSLocalizedString(kUserDefination,nil);
    } else {
        titleString = NSLocalizedString([[array objectAtIndex:section] objectForKey:@"name"], nil);
    }
    
    return titleString;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleString = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    if ([titleString isEqualToString:NSLocalizedString(kUserDefination, nil)]) {
        return YES;
    }
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *titleString = [self tableView:tableView titleForHeaderInSection:indexPath.section];
//    DLog(@"titleString:%@", titleString);
//    if ([titleString isEqualToString:NSLocalizedString(kUserDefination, nil)]) {
//        
//    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItem:indexPath];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } 
}


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cell.frame.size.height)];
        redView.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.1 alpha:1.0];
        cell.selectedBackgroundView = redView;
        [redView release];
        cell.textLabel.shadowOffset = CGSizeMake(0, 0);
    } else {
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    }
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    NSArray *listsArray = [listDict objectForKey:@"lists"];
    NSArray *userArray = [listDict objectForKey:kUserDefination];
    NSArray *selectedArray = nil;
    NSString *titleStr = nil;
    NSDictionary *itemDict = nil;
    if (section > [listsArray count] - 1) {
        itemDict = [userArray objectAtIndex:row];
        selectedArray = [itemDict objectForKey:@"contents"];
        titleStr = [itemDict objectForKey:@"name"];
        
    } else {
        itemDict = [[[listsArray objectAtIndex:section] objectForKey:@"lists"] objectAtIndex:row];
        selectedArray = [itemDict objectForKey:@"contents"];
        titleStr = [itemDict objectForKey:@"name"];
    }
    DLog(@"SchemaTVC, title:%@",titleStr);
//    NSArray *array = [listDict objectForKey:@"lists"];
//    NSString *selectedKey = [array objectAtIndex:indexPath.section];
//    NSDictionary *selectedDict = [listDict objectForKey:selectedKey];
//    NSString *keyString = [[selectedDict allKeys] objectAtIndex:indexPath.row];
//    NSArray *selectedArray = [selectedDict objectForKey:keyString];
    if ([delegate respondsToSelector:@selector(selectedArray:title:)]) {
        [delegate selectedArray:selectedArray title:titleStr];
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
