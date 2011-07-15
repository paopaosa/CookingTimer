//
//  HelpTableViewController.m
//  CookingTImer
//
//  Created by user on 11-6-14.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "HelpTableViewController.h"
#import "CommonDefines.h"

#define PADDING 10.0f

@interface HelpTableViewController (LocalExtended)

- (void)loadDatas;

@end

@implementation HelpTableViewController

#pragma mark -
#pragma mark LOCAL extended

- (void)loadDatas
{
    DLog(@"Help Load local datas.");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PSHelp" ofType:@"plist"];
    DLog(@"path:'%@'", filePath);
    lists = [[[NSMutableDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"lists"] retain];
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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadDatas];
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
    return [lists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *answerString = [[lists objectAtIndex:section] objectForKey:@"picture"];
    if ([answerString length] == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    int row = indexPath.row;
    int section = indexPath.section;
    NSDictionary *item = [lists objectAtIndex:section];
    NSString *pictureStr = nil;
    UIImage *helpImage = nil;
    UIImageView *helpImageView = nil;
    CGSize newSize;
    float ratio;
//    NSLog(@"itemDict:%@", item);
    cell.textLabel.numberOfLines = 0;
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"aide.png"];
            cell.textLabel.text = NSLocalizedString([item objectForKey:@"topic"], nil);
            helpImageView = (UIImageView *)[cell.contentView viewWithTag:178];
            if (helpImageView) {
//                DLog(@"haveing.................");
                [helpImageView removeFromSuperview];
            }
            break;
        case 1:
            cell.imageView.image = nil;
            cell.textLabel.text = NSLocalizedString([item objectForKey:@"answer"], nil);
            helpImageView = (UIImageView *)[cell.contentView viewWithTag:178];
            if (helpImageView) {
//                DLog(@"haveing.................");
                [helpImageView removeFromSuperview];
            }
            break;
        case 2:
            cell.imageView.image = nil;
            pictureStr = NSLocalizedString([item objectForKey:@"picture"], nil);
            cell.textLabel.text = pictureStr;
            if ([pictureStr length] > 0) {
                helpImage = [UIImage imageNamed:pictureStr];
                ratio = 280 / helpImage.size.width;
                newSize = [kDelegate makeImageAutoFit:helpImage ratio:ratio];
                helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
                helpImageView.image = helpImage;
                helpImageView.contentMode = UIViewContentModeScaleAspectFill;
                helpImageView.tag = 178;
                [cell.contentView addSubview:helpImageView];
                [helpImageView release];
            } else {
                helpImageView = (UIImageView *)[cell.contentView viewWithTag:178];
                if (helpImageView) {
                    DLog(@"haveing.................");
                    [helpImageView removeFromSuperview];
                }
            }
            break;
        default:
            cell.imageView.image = nil;
            cell.textLabel.text = NSLocalizedString(@"Title", nil);
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    NSString *answerString;
    float newHeightForImage;
    CGSize newSize;
    UIImage *helpImage = nil;
    switch (row) {
        case 0:
            answerString = [[lists objectAtIndex:indexPath.section] objectForKey:@"topic"];
            break;
        case 1:
            answerString = [[lists objectAtIndex:indexPath.section] objectForKey:@"answer"];
            break;
        case 2:
            answerString = [[lists objectAtIndex:indexPath.section] objectForKey:@"picture"];
            if ([answerString length] > 0) {
                helpImage = [UIImage imageNamed:answerString];
                newSize = [kDelegate makeImageAutoFit:helpImage ratio:( 280 / helpImage.size.width )];
                return newSize.height + PADDING * 2;
            }
            break;
        default:
            answerString = @"";
    }
    CGSize textSize = [answerString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 3, 1000.0f)];
    return textSize.height + PADDING * 3;
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
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
