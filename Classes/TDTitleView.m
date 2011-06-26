//
//  TDTitleView.m
//  CookingTImer
//
//  Created by user on 11-6-25.
//  Copyright 2011年 Howwly. All rights reserved.
//

#import "TDTitleView.h"
#import "CommonDefines.h"

@interface TDTitleView (LocalExtand)

- (void)changeTitleTextField:(id)sender;

@end

@implementation TDTitleView

@synthesize titleInput;
@synthesize delegate;

#pragma mark -
#pragma mark innLOcal

- (void)changeTitleTextField:(id)sender {
//    int anIndex = (UIButton *)[sender tag];
    NSString *selectedString = [(UIButton *)sender titleForState:UIControlStateNormal];
    DLog(@"changeText field, %@", selectedString);
    titleInput.text = selectedString;
    [delegate titleViewChangeTo:selectedString];
}

- (void)setupButtons {
    DLog(@"setup Buttons for Title View.");
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TitleButtons" ofType:@"plist"];
    if (!buttons) {
        buttons = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"lists"] retain];
    }
    
    UIButton *testButton = nil;
    UIImage *backImage = [[UIImage imageNamed:@"BlackButtonBackground.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    for (int i = 0 ; i < [buttons count]; ++i) {
        testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        testButton.frame = CGRectMake((int)(i%3 * (80 + 30) + 10),
                                      (int)(floor(i/3) * (40 + 10) + 60),
                                      80,
                                      40);
        testButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        testButton.tag = i;
        testButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        testButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
        [testButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [testButton addTarget:self action:@selector(changeTitleTextField:) forControlEvents:UIControlEventTouchUpInside];
        [testButton setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:testButton];
    }
}

#pragma mark -
#pragma mark TextFiled delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	DLog(@"ramge:%@",NSStringFromRange(range));
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	return (newLength > 20) ? NO : YES;;
}

#pragma mark -
#pragma mark lifecyc

- (void)hideKeyboard {
    [titleInput resignFirstResponder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, 28)];
        titleInput.font = [UIFont systemFontOfSize:15];
        titleInput.placeholder = @"Input title herer.";
        titleInput.borderStyle = UITextBorderStyleBezel;
        titleInput.backgroundColor = [UIColor whiteColor];
        titleInput.delegate = self;
        [self addSubview:titleInput];

        [self setupButtons];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [buttons release];
    [titleInput release];
    [super dealloc];
}

@end
