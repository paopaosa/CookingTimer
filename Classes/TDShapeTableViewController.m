//
//  TDShapeTableViewController.m
//  CookingTImer
//
//  Created by user on 11-7-6.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TDShapeTableViewController.h"
#import "CommonDefines.h"

@interface TDShapeTableViewController (LocalExtended)

- (void)loadShapeLists;

@end

@implementation TDShapeTableViewController

@synthesize figureIndex, delegate;

#pragma mark -
#pragma mark LocalExtended
- (void)loadShapeLists {
    DLog(@"load shape lists.");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TitleButtons" ofType:@"plist"];
    NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:path];
    shapelists = [[tempDict objectForKey:@"lists"] retain];
    DLog(@"shapelists:'%@'", shapelists);
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
    [shapelists release];
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
    
    [self loadShapeLists];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [shapelists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = indexPath.section;
    NSString *nameString = [shapelists objectAtIndex:section];
    NSString *picString = [NSString stringWithFormat:@"%@.png", nameString];
    // Configure the cell...
    cell.textLabel.text = nameString;
    cell.imageView.image = [UIImage imageNamed:picString];
    if (indexPath.section == figureIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
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

- (void)deselectCell {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    int lastSection = figureIndex;
    figureIndex = newIndexPath.section;
//    DLog(@"You have selected '%d' figure", figureIndex);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:newIndexPath];
    
    if ([cell accessoryType] == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView beginUpdates];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:lastSection] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    if ([delegate respondsToSelector:@selector(selectedFigure:)]) {
        [delegate selectedFigure:figureIndex];
    }
    
    [self performSelector:@selector(deselectCell) withObject:nil afterDelay:0.5];
}

@end
