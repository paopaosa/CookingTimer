//
//  AddTimerViewController.m
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import "AddTimerViewController.h"

@interface AddTimerViewController (LocalExtend)

- (void)loadDefaultList;

@end

@implementation AddTimerViewController

#pragma mark -
#pragma mark MY LOCAL EXTEND
- (void)loadDefaultList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimerLists" ofType:@"plist"];
    listDict = [[NSMutableDictionary dictionaryWithContentsOfFile:path] retain];
//    [timerPicker reloadAllComponents];
}
#pragma mark -
#pragma mark IBAction

- (IBAction) confirm: (id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Picker DataSource and Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger selectedNumber;
    NSString *selectedKey;
    switch (component) {
        case 0:
//            switch ([pickerView selectedRowInComponent:0]) {
//                case 0:
//                    return 2;
//                case 1:
//                    return 23;
//                case 2:
//                    return 2;
//                default:
//                    break;
//            }
            return [[listDict allKeys] count];
        case 1:
            //return different value.
            selectedNumber = [pickerView selectedRowInComponent:0];
            selectedKey = [[listDict allKeys] objectAtIndex:selectedNumber];
            return [[[listDict objectForKey:selectedKey] allKeys] count];
        default:
            return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *resultString = nil;
    if (component == 0) {
        resultString = [[listDict allKeys] objectAtIndex:row];
    } else {
        resultString = [NSString stringWithFormat:@"%d",row];
    }
    return resultString;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    NSString *titleStr = nil;
//    switch (component) {
//        case 0:
//            titleStr = @"小时";
//            break;
//        case 1:
//            titleStr = @"分";
//            break;
//        case 2:
//            titleStr = @"秒";
//            break;
//        default:
//            break;
//    }
//    titleLabel.text = titleStr;
//    return titleLabel;
//}


#pragma mark -
#pragma mark SYSTEM
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"载入闹钟模板",nil);
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirm:)];
    self.navigationItem.rightBarButtonItem = editItem;
	[editItem release];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(confirm:)];
    self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
    
    [self loadDefaultList];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)dealloc {
    [listDict release];
    [timerPicker release];
    [super dealloc];
}

- (void)viewDidUnload {
    [timerPicker release];
    timerPicker = nil;
    [super viewDidUnload];
}
@end
