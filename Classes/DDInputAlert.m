//
//  DDInputAlert.m
//  CookingTImer
//
//  Created by user on 11-7-17.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "DDInputAlert.h"
#import "CommonDefines.h"

@implementation DDInputAlert

@synthesize title;
@synthesize delegate;

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"You have clicked:%d", buttonIndex);
    NSString *newTitleStr = [NSString stringWithFormat:@"%@",[nameField text]];
    switch (buttonIndex) {
        case 0:
            if ([delegate respondsToSelector:@selector(nothingChanged)]) {
                [delegate nothingChanged];
            };
            break;
        case 1:
            DLog(@"your changed title is:%@", newTitleStr);
            if (![newTitleStr isEqualToString:@"(null)"]) {
                if ([delegate respondsToSelector:@selector(changedTitle:)] ) {
                    [delegate changedTitle:newTitleStr];
                }
            }
            break;
        default:
            break;
    }
    if (nameField != nil) {
        [nameField resignFirstResponder];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DLog(@"range:%@",NSStringFromRange(range));
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	return (newLength > 28) ? NO : YES;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = nil;
    }
    return self;
}

- (void)showAlert:(NSString *)alertString {
    alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@'%@'",alertString, title]
                                           message:@"\n\n\n" 
                                          delegate:self 
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 60.0, 245.0, 25.0)];
    nameField.text = title;
    nameField.placeholder = NSLocalizedString(@"Input Title Here", nil);
    [nameField setDelegate:self];
    [nameField setBackgroundColor:[UIColor whiteColor]];
    [alertView addSubview:nameField];
    
    
    [alertView show];
    
}

- (void)dealloc {
    [nameField release];
    nameField = nil;
    [alertView release];
    [title release];
    [super dealloc];
}

@end
