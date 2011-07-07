//
//  SchemaTableViewController.h
//  CookingTImer
//
//  Created by user on 11-6-13.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SchemaTableViewControllerDelegate <NSObject>

@optional

- (void)selectedArray:(NSArray *)array;

@end

@interface SchemaTableViewController : UITableViewController {
    NSMutableDictionary                     *listDict;
    NSMutableArray                          *currentLists; //current user's lists
    id <SchemaTableViewControllerDelegate>  delegate;
}

@property (nonatomic,retain) NSMutableDictionary    *listDict;
@property (nonatomic,copy) NSMutableArray         *currentLists;
@property (nonatomic,assign) id <SchemaTableViewControllerDelegate> delegate;

//load data from local
- (void)loadSchemaData;

- (IBAction)addNewsList:(id)sender;

@end
