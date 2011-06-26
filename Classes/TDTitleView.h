//
//  TDTitleView.h
//  CookingTImer
//
//  Created by user on 11-6-25.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDTitleViewDelegate <NSObject>

@optional

- (void)titleViewChangeTo:(NSString *)newTitleStr;

@end


@interface TDTitleView : UIView <UITextFieldDelegate>{
    UITextField     *titleInput;
    NSArray         *buttons;
    id <TDTitleViewDelegate> delegate;
}

@property (nonatomic,readonly)  UITextField     *titleInput;
@property (nonatomic,assign)    id <TDTitleViewDelegate> delegate;

- (void)hideKeyboard;

@end
