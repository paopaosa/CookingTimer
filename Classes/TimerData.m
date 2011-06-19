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
@synthesize originTimer;
@synthesize howlong;
@synthesize status;
@synthesize delegate;

#pragma mark -
#pragma mark METHODS

- (void)makeProgressBarMoving {
    
	float actual = [howlong floatValue];

	if (actual == 0) {
		self.status = finished;
        if ([delegate respondsToSelector:@selector(finishedTimer:)]) {
            DLog(@"TimerData,it's end! thread1");
            [delegate finishedTimer:[delegate indexOfLists:self]];
        }
		return;
	} else {
        float a = actual - (int)actual;
        if (a == 0.5f) {
//            DLog(@"a is %.2f",a);
            [delegate splashTimer:[delegate indexOfLists:self]];
        } else {
            [delegate updateTimer:[delegate indexOfLists:self]];
        }
    }
//    DLog(@"TimerData,running:%.2f",actual);
	self.howlong = [NSNumber numberWithFloat:(actual - 0.5f)];
}

- (void) startCount {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	while (status == start) {
		[self performSelectorOnMainThread:@selector(makeProgressBarMoving) withObject:nil waitUntilDone:NO];
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
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
    copyItem.originTimer = originTimer;
    copyItem.howlong = howlong;
    copyItem.status = status;
//    copyItem.indexPath = indexPath;
    return copyItem;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
//    indexPath = [[aDecoder decodeObjectForKey:@"indexPath"] retain];
    originTimer = [[aDecoder decodeObjectForKey:@"originTimer"] retain];
	howlong = [[aDecoder decodeObjectForKey:@"howlong"] retain];
	status = [[aDecoder decodeObjectForKey:@"status"] intValue];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	//[super encodeWithCoder:aCoder];
//    [aCoder encodeObject:indexPath forKey:@"indexPath"];
    [aCoder encodeObject:originTimer forKey:@"originTimer"];
	[aCoder encodeObject:howlong forKey:@"howlong"];
	[aCoder encodeObject:[NSNumber numberWithInt:status] forKey:@"status"];
}


- (id)init {
    self = [super init];
    if (self) {
        int defaultTimerhowlong = [[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTimerKey] intValue];
        self.originTimer = [NSNumber numberWithFloat:defaultTimerhowlong];
        self.howlong = [NSNumber numberWithFloat:defaultTimerhowlong];
        status = ready;
    }
    return self;
}

- (void)dealloc {
//    [indexPath release];
    [originTimer release];
    [howlong release];
    [super dealloc];
}

@end
