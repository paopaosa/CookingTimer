//
//  SchemaTableViewController.h
//  CookingTImer
//
//  Created by user on 11-6-13.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInputAlert.h"

@protocol SchemaTableViewControllerDelegate <NSObject>

@optional

- (void)selectedArray:(NSArray *)array title:(NSString *)titleStr;

@end

@interface SchemaTableViewController : UITableViewController 
<
UIActionSheetDelegate, DDInputAlertDelegate
>
{
    NSMutableDictionary                     *listDict;
    NSMutableArray                          *currentLists; //current user's lists
    NSIndexPath                             *selectedItemIndex;
    NSString                                *currentTitle;
    DDInputAlert                            *titleAlert;
    id <SchemaTableViewControllerDelegate>  delegate;
}

@property (nonatomic,retain) NSMutableDictionary    *listDict;
@property (nonatomic,copy)   NSMutableArray         *currentLists;
@property (nonatomic,copy) NSIndexPath              *selectedItemIndex;
@property (nonatomic,copy) NSString                 *currentTitle;
@property (nonatomic,retain) DDInputAlert           *titleAlert;
@property (nonatomic,assign) id <SchemaTableViewControllerDelegate> delegate;

//load data from local
- (void)loadSchemaData;

- (void)saveSchemaData;

- (IBAction)addNewsList:(id)sender;

@end
