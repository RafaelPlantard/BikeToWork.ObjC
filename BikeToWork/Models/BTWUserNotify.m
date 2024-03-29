//
//  BTWUserNotify.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/20/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWUserNotify.h"

@implementation BTWUserNotify

static NSArray *notificationRecurrenceStrings;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        notificationRecurrenceStrings = @[@"Every day", @"Every work day", @"Every sunday", @"Every monday", @"Every tuesday", @"Every wednesday", @"Every thursday", @"Every friday", @"Every saturday", @"Once time"];
    }
    
    return self;
}

- (instancetype)initWithRecurrence:(BTWNotificationRecurrence)recurrence WithAlarmTime:(NSString *)time {
    self = [self init];
    
    if (self) {
        self.notificationRecurrence = recurrence;
        self.time = time;
    }
    
    return self;
}

+ (NSString *)stringRepresentation:(BTWNotificationRecurrence)recurrence {
    return notificationRecurrenceStrings[recurrence];
}

+ (NSArray *)allStringRepresentation {
    return notificationRecurrenceStrings;
}

+ (BTWNotificationRecurrence)enumRepresentationFromIndex:(NSUInteger)index {
    return (BTWNotificationRecurrence)index;
}

+ (BTWNotificationRecurrence)enumRepresentationFromString:(NSString *)string {
    return [notificationRecurrenceStrings indexOfObject:string];
}

@end