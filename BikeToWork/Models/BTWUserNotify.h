//
//  BTWUserNotify.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/20/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTWNotificationRecurrence) {
    BTWNotificationRecurrenceEveryDay,
    BTWNotificationRecurrenceEveryWorkDay,
    BTWNotificationRecurrenceEverySunday,
    BTWNotificationRecurrenceEveryMonday,
    BTWNotificationRecurrenceEveryTuesday,
    BTWNotificationRecurrenceEveryWednesday,
    BTWNotificationRecurrenceEveryThursday,
    BTWNotificationRecurrenceEveryFriday,
    BTWNotificationRecurrenceEverySaturday,
    BTWNotificationRecurrenceOnceTime
};

/*! @brief The settings for the time and recurrence of the user notification. */
@interface BTWUserNotify : NSObject

/*! @brief The recurrence for the notification. */
@property (nonatomic, assign) BTWNotificationRecurrence notificationRecurrence;

/*! @brief The time for alarm the user. */
@property (nonatomic, strong) NSString *time;

- (instancetype)initWithRecurrence:(BTWNotificationRecurrence)recurrence WithAlarmTime:(NSString *)time;

/*! @brief Returns a string representation for a specific element of the enum of recurrences.*/
+ (NSString *)stringRepresentation:(BTWNotificationRecurrence)recurrence;

/*! @brief Returns a enum representation based on the index of the array that storages all options. */
+ (BTWNotificationRecurrence)enumRepresentationFromIndex:(NSUInteger)index;

/*! @brief Returns the enum representation based on the string value. */
+ (BTWNotificationRecurrence)enumRepresentationFromString:(NSString *)string;

/*! @brief Returns an array of strings that represents all strings representation of the enum of recurrence. */
+ (NSArray *)allStringRepresentation;

@end