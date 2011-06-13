//
//  SchemaTableViewController.h
//  CookingTImer
//
//  Created by user on 11-6-13.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SchemaTableViewController : UITableViewController {
    NSMutableDictionary *listDict;
}

@property (nonatomic,retain) NSMutableDictionary *listDict;

//load data from local
- (void)loadSchemaData;

@end
