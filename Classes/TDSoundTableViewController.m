//
//  TDSoundTableViewController.m
//  CookingTImer
//
//  Created by user on 11-6-26.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "TDSoundTableViewController.h"
#import "CommonDefines.h"

@implementation TDSoundTableViewController

@synthesize soundTimerData;
@synthesize soundLists;
@synthesize audioPlayer;
@synthesize delegate;

- (void)playAudioFile:(NSString *)path {
    if (!path) {
        DLog(@"Audio file is not exsit.");
        return;
    }
    if (audioPlayer) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
        }
    }
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
//    audioPlayer.delegate = self;
    [audioPlayer play];
    if (error) DLog(@"play audio error:%@", error);
    [url release];
}

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
    [soundTimerData release];
    [audioPlayer release];
    [soundLists release];
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SoundButtons" ofType:@"plist"];
    soundLists = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"lists"] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.soundLists = nil;
    DLog(@"TDSound displayer");
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [soundLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [soundLists objectAtIndex:indexPath.row];
    if ([indexPath row] == soundTimerData.soundIndex) {
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
//    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:soundTimerData.soundIndex inSection:0]];
//    int oldIndex = soundTimerData.soundIndex;
    
    NSString *soundStr = [soundLists objectAtIndex:indexPath.row];
    soundTimerData.soundName = soundStr;
    soundTimerData.soundIndex = indexPath.row;
    NSString *path = [[NSBundle mainBundle] pathForResource:soundStr ofType:@"caf"];
    DLog(@"You have selected sound:%@", path);
//    UIViewController *cookTimerViewController = [[[[[kDelegate tabBarController] viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:oldIndex inSection:0]] 
//                     withRowAnimation:UITableViewRowAnimationNone]; 
    [tableView reloadData];
    [self playAudioFile:path];
    if ([delegate respondsToSelector:@selector(selectedSound:)]) 
        [delegate selectedSound:soundTimerData];
}

@end
