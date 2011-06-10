//
//  AddTimerViewController.h
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddTimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIPickerView *timerPicker;
    NSMutableDictionary *listDict;
}

- (IBAction) confirm: (id)sender;

@end
