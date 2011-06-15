//
//  TimerData.m
//  CookingTImer
//
//  Created by user on 11-6-10.
//  Copyright 2011年 imag interactive. All rights reserved.
//

#import "TimerData.h"
#import "CommonDefines.h"

@implementation TimerData

//@synthesize indexPath;
@synthesize howlong;
@synthesize status;
@synthesize delegate;

#pragma mark -
#pragma mark METHODS

- (void)makeProgressBarMoving {
    
	int actual = [howlong intValue];

    [delegate updateTimer:[delegate indexOfLists:self]];
    
	if (actual == 0) {
		self.status = finished;
		DLog(@"TimerData,it's end! thread1");
		return;
	}
//    DLog(@"TimerData,running:%d",actual);
	self.howlong = [NSNumber numberWithInt:(actual - 1)];
}

- (void) startCount {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	while (status != stop) {
		[self performSelectorOnMainThread:@selector(makeProgressBarMoving) withObject:nil waitUntilDone:NO];
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
	}
	DLog(@"TimerData,Thread is end!");
    [NSThread exit];
	[pool release];
}

- (void)setDataForTimer:(NSDictionary *)newDict {
    NSNumber *tempNumber = [newDict objectForKey:kTimerLength];
    if (tempNumber) {
        self.howlong = tempNumber;
    };
    NSNumber *tempResult = [newDict objectForKey:kTimerResult];
    if (tempResult) {
        status = [tempResult intValue];
    }
}

- (void)readyToStart {
    status = start;
    DLog(@"TimerData, start New Thread!");
    [NSThread detachNewThreadSelector:@selector(startCount) toTarget:self withObject:nil];
}

- (void)start {
    DLog(@"TimerData, start.");
    status = start;
    [NSThread detachNewThreadSelector:@selector(startCount) toTarget:self withObject:nil];
}

- (void)stop {
    DLog(@"TimerData, stop.");
    status = stop;
    [delegate updateTimer:[delegate indexOfLists:self]];
}

- (void)finished {
    DLog(@"TimerData, finished.");
    [delegate updateTimer:[delegate indexOfLists:self]];
}

//Set start or stop event.
- (void)clickEvent:(int)index {
    switch (status) {
        case ready:
            [self readyToStart];
            break;
        case start:
            [self stop];
            break;
        case stop:
            [self start];
            break;
        case finished:
            status = finished;
            [self finished];
            break;
        default:
            status = ready;
            break;
    }
}

#pragma mark -
#pragma mark lifecyc

- (id)copyWithZone:(NSZone *)zone {
    TimerData *copyItem = [[TimerData alloc] init];
    copyItem.howlong = howlong;
    copyItem.status = status;
//    copyItem.indexPath = indexPath;
    return copyItem;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
//    indexPath = [[aDecoder decodeObjectForKey:@"indexPath"] retain];
	howlong = [[aDecoder decodeObjectForKey:@"howlong"] retain];
	status = [[aDecoder decodeObjectForKey:@"status"] intValue];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	//[super encodeWithCoder:aCoder];
//    [aCoder encodeObject:indexPath forKey:@"indexPath"];
	[aCoder encodeObject:howlong forKey:@"howlong"];
	[aCoder encodeObject:[NSNumber numberWithInt:status] forKey:@"status"];
}


- (id)init {
    self = [super init];
    if (self) {
        int defaultTimerhowlong = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey] intValue];
        self.howlong = [NSNumber numberWithInt:defaultTimerhowlong];
        status = ready;
    }
    return self;
}

- (void)dealloc {
//    [indexPath release];
    [howlong release];
    [super dealloc];
}

@end
