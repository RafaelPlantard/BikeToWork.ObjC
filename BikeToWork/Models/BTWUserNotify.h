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
    BTWNotificationRecurrenceEverySaturday
};

/*! @brief The settings for the time and recurrence of the user notification. */
@interface BTWUserNotify : NSObject

/*! @brief The recurrence for the notification. */
@property (nonatomic, assign) BTWNotificationRecurrence *notificationRecurrence;

/*! @brief The time for alarm the user. */
@property (nonatomic, strong) NSString *time;

@end