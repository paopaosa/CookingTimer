//
//  SchemaTableViewController.m
//  CookingTImer
//
//  Created by user on 11-6-13.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "SchemaTableViewController.h"
#import "CommonDefines.h"

@implementation SchemaTableViewController

@synthesize listDict;

#pragma mark -
#pragma mark privte 

//load data from local
- (void)loadSchemaData {
    DLog(@"Load Schema Data.");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DemoTImerLists" ofType:@"plist"];
    DLog(@"path:%@",path);
    listDict = [[NSMutableDictionary dictionaryWithContentsOfFile:path] retain];
}

- (void) exitView {
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    int count = [[listDict allKeys] count];
    DLog(@"number section:%d",count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *selectedKey = [[listDict allKeys] objectAtIndex:section];
    int count = [[[listDict objectForKey:selectedKey] allKeys] count];
    DLog(@"count:%d",count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSArray *array = [listDict allKeys];
    NSString *selectedKey = [array objectAtIndex:indexPath.section];
    NSDictionary *selectedDict = [listDict objectForKey:selectedKey];
    NSString *keyString = [[selectedDict allKeys] objectAtIndex:indexPath.row];
    NSArray *selectedArray = [selectedDict objectForKey:keyString];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d", keyString,[selectedArray count]];
//    DLog(@"%@, %d",[selectedArray class], [selectedArray count]);
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleString = nil;
    NSArray *array = [listDict allKeys];
    titleString = [array objectAtIndex:section];
    
    return titleString;
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
}

@end
