//
//  AddCell.h
//  CookingTImer
//
//  Created by user on 11-5-18.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCell : UITableViewCell <UIGestureRecognizerDelegate> {
    UIButton        *addButton;         //add new one.
    UIButton        *deleteAllButton;   //delete all of the timers.
    UIButton        *removeLastButton;  //remove last timer.
    UIViewController *rootViewController;
}

@property (nonatomic,assign) UIViewController *rootViewController;

@end
