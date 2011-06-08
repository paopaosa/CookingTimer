//
//  SettingsTableViewController.h
//  CookingTImer
//
//  Created by user on 11-5-15.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsTableViewController : UITableViewController {
    NSDictionary    *lists;
}

@property (nonatomic,retain) NSDictionary    *lists;

@end
