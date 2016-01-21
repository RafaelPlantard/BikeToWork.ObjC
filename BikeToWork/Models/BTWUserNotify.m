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
        notificationRecurrenceStrings = @[@"Every work day", @"Every sunday", @"Every monday", @"Every tuesday", @"Every wednesday", @"Every thursday", @"Every friday", @"Every saturday", @"Once time"];
    }
    
    return self;
}

+ (NSString *)stringRepresentation:(BTWNotificationRecurrence)recurrence {
    return notificationRecurrenceStrings[recurrence];
}

+ (NSArray *)allStringRepresentation {
    return notificationRecurrenceStrings;
}

@end