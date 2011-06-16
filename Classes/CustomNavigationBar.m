//
//  CustomNavigationController.m
//  JinChaoApp
//
//  Created by user on 11-3-7.
//  Copyright 2011 imag interactive. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "CommonDefines.h"

@implementation CustomNavigationBar

@synthesize backgroundImage;

-(void)drawRect:(CGRect)rect
{
    //Nothing to do
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	
	int i = 0;
	for (id navigationController in [[kDelegate tabBarController] viewControllers]) {
		if ([[navigationController navigationBar] isEqual:self]) {
			DLog(@"index:%d",i);
			break;
		}
		++i;
	}
	NSString *backImage = [NSString stringWithFormat:@"app_%d_banner.png",i];
	DLog(@"background image:%@",backImage);
	UIImage *image;
	if (i > 3) {
		image = [UIImage imageNamed:@"app_4_banner.png"];
	} else {
        image = [UIImage imageNamed:backImage];
        if (!image) {
            DLog(@"Nav back is not exist.");
            image = [UIImage imageNamed:@"Nav_Load_320x44.png"];
        }
	}
    CGContextClip(ctx);
    CGContextTranslateCTM(ctx, 0, image.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), image.CGImage);
}

- (void)dealloc {
	[backgroundImage release];
	[super dealloc];
}

@end
