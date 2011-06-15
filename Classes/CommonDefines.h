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

#define kDefaultTimerKey @"DefaultTimerKey"
#define kStartNextTimer  @"StartNextTimer"

#define kTimerLength @"length"
#define kTimerResult @"result"