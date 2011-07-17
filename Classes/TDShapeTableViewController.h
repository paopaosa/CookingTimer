//
//  TDShapeTableViewController.h
//  CookingTImer
//
//  Created by user on 11-7-6.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDShapeTableViewControllerDelegate <NSObject>

@optional
- (void)selectedFigure:(int) index;

@end


@interface TDShapeTableViewController : UITableViewController {
    NSArray     *shapelists;
    int figureIndex;
    id <TDShapeTableViewControllerDelegate> delegate;
}

@property (nonatomic, assign) int figureIndex;
@property (nonatomic, assign) id <TDShapeTableViewControllerDelegate> delegate;

@end
