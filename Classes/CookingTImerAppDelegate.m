//
//  CookingTImerAppDelegate.m
//  CookingTImer
//
//  Created by user on 11-5-11.
//  Copyright 2011 Howwly. All rights reserved.
//

#import "CookTimerTableViewController.h"
#import "CookingTImerAppDelegate.h"
#import "CommonDefines.h"

@interface CookingTImerAppDelegate (MyPrivateMethods)

//初始化时间表
- (void)initDemoList;
//设置默认值
- (void)initDatas;

@end

@implementation CookingTImerAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize settingItem;
@synthesize timerItem;

#pragma mark -
#pragma mark MY PRIVATE

#pragma mark EarthQuake Methods

- (void)earthquake:(UIView*)itemView
{
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
    
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:itemView];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([finished boolValue]) 
    {
        UIView* item = (UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

- (void)timerExercute:(SEL)newSelector {
    UINavigationController *nav1 = [[tabBarController viewControllers] objectAtIndex:0];
    CookTimerTableViewController *cookTVC = (CookTimerTableViewController *)[[nav1 viewControllers] objectAtIndex:0];
    if ([cookTVC respondsToSelector:(SEL)newSelector]) {
        [cookTVC performSelector:newSelector];
    }
}

//stop cooking timer running.
- (void)stopCookTimer {
    [self timerExercute:@selector(saveAndStopCookTimer)];
}

//resume cooking timer
- (void)resumeCookingTimer {
    [self timerExercute:@selector(resumeAllCookTimer)];
}

- (void)clearLocalQueueForLocalNotifications {
    DLog(@"clear Local Queue For Local Notifications");
    UIApplication *app = [UIApplication sharedApplication];
	NSArray *oldNotifications = [app scheduledLocalNotifications];
	
	// Clear out the old notification before scheduling a new one.
	if (0 < [oldNotifications count]) {
		[app cancelAllLocalNotifications];
	}
}

- (NSString *)convertSeconds:(NSNumber *)newTimer {
    NSDateComponents *components = [[NSDateComponents alloc] init]; 
    [components setDay:1]; 
    [components setMonth:1]; 
    [components setYear:2000];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSDate *newDate = [gregorian dateFromComponents:components];
    NSDate *someDate = [NSDate dateWithTimeInterval:[newTimer intValue] sinceDate:newDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *resultStr = [NSString stringWithFormat:@"%@",[df stringFromDate:someDate]];
    [df release];
    [gregorian release];
    [components release];
    return resultStr;
}

- (void)initDatas {
    //Default length of timer is seconds.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kDefatulTimer] forKey:kDefaultTimerKey];
    }
    //set defulat invoke next timer on.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kStartNextTimer]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kStartNextTimer];
    }
}

- (void)showMessage:(NSString *)messStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil)
                                                    message:NSLocalizedString(messStr, nil)
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK",nil) 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	// Set the tab bar controller as the window's root view controller and display.
    
    [self initDatas];

    timerItem.title = NSLocalizedString(@"定时器", nil);
    settingItem.title = NSLocalizedString(@"设置", nil);

    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    isFirstLoad = YES;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self stopCookTimer];
    
    // Request permission to run in the background. Provide an 
	// expiration handler in case the task runs long.
	NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
	
	self->bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
		// Synchronize the cleanup call on the main thread in case
		// the task catully finished at around the same time.
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (UIBackgroundTaskInvalid != self->bgTask) {
				
				[application endBackgroundTask:self->bgTask];
				self->bgTask = UIBackgroundTaskInvalid;
			}
		});
	}];
	
	// Start the long-running task and return immediately.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
				   ^{
					   // Do the work assoicated with the task.
					   
					   // Synchronize the cleanup all on the main thread in case
					   // the task catully finished at around the same time. 
					   dispatch_async(dispatch_get_main_queue(), ^{
						   
						   if (UIBackgroundTaskInvalid != self->bgTask) {
                               
							   [application endBackgroundTask:self->bgTask];
							   self->bgTask = UIBackgroundTaskInvalid;
						   }
					   });
				   });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [self clearLocalQueueForLocalNotifications];
    [self resumeCookingTimer];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    if (isFirstLoad) {
        ;
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
// it's wont call when terminate.
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTerminalCookTimer object:self];
    [self clearLocalQueueForLocalNotifications];
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [timerItem release];
    [settingItem release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

