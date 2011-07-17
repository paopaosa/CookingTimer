//
//  DDInputAlert.h
//  CookingTImer
//
//  Created by user on 11-7-17.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDInputAlertDelegate <NSObject>

@optional
- (void)changedTitle:(NSString *)newTitle;

- (void)nothingChanged;

@end


@interface DDInputAlert : NSObject 
<UIAlertViewDelegate,
UITextFieldDelegate>
{
    UIAlertView *alertView;
    NSString    *title;
    UITextField *nameField;
    id <DDInputAlertDelegate> delegate;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,assign) id <DDInputAlertDelegate> delegate;

- (void)showAlert:(NSString *)alertString;

@end
