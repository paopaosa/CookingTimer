//
//  CookingTImerAppDelegate.h
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookingTImerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UITabBarItem *settingItem;
    UITabBarItem *timerItem;
    BOOL         isFirstLoad;
    UIBackgroundTaskIdentifier	bgTask;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UITabBarItem *settingItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *timerItem;

- (void)showMessage:(NSString *)messStr;

- (NSString *)convertSeconds:(NSNumber *)newTimer;

- (void)earthquake:(UIView*)itemView;

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

//stop cooking timer running.
- (void)stopCookTimer;

//resume cooking timer
- (void)resumeCookingTimer;

- (void)clearLocalQueueForLocalNotifications;

@end
