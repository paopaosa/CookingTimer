/*
 *  CommonDefines.h
 *  CookingTImer
 *
 *  Created by user on 11-5-11.
 *  Copyright 2011 Howwly. All rights reserved.
 *
 */
#import "CookingTImerAppDelegate.h"

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define kDelegate (CookingTImerAppDelegate *)[[UIApplication sharedApplication] delegate]

//默认五分钟(以秒为单位)
#define kDefatulTimer   300
#define kTAG_DefaultTime    787

#define kDefaultListPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"DefaultLists.plist"]
#define kCurrentListsPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CurrentLists.plist"]

#define kNotificationAddCell @"NotificationAddCell"
#define kNotificationTerminalCookTimer @"NotificationTerminalCookTimer"

#define kDefaultTimerKey @"DefaultTimerKey"
#define kStartNextTimer  @"StartNextTimer"

#define kTimerLength @"length"
#define kTimerResult @"result"

#define kColor_ADD_CONTENT_BACKGROUND_GRAY			([UIColor colorWithRed:0.8941f green:0.902f blue:0.9176f alpha:0.1])
#define kColor_ADD_CONTENT_BACKGROUND_GRAY_LIGHT	([UIColor colorWithRed:0.9333f green:0.9373f blue:0.9490f alpha:1.0])
