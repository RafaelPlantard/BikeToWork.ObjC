//
//  BTWUserSettings.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/20/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTWUserNotify.h"
#import "BTWWheatherResponse.h"

/*! @brief A entity that encapusates all user settings. */
@interface BTWUserSettings : NSObject

/*! @brief The initial time. */
@property (nonatomic, strong) NSString *startTime;

/*! @brief The end time. */
@property (nonatomic, strong) NSString *endTime;

/*! @brief The minimum temperature. */
@property (nonatomic, strong) NSNumber *minimumTemperature;

/*! @brief The maximum temperature. */
@property (nonatomic, strong) NSNumber *maximumTemperature;

/*! @brief The minimum pressure. */
@property (nonatomic, strong) NSNumber *minimumPressure;

/*! @brief The maximum pressure. */
@property (nonatomic, strong) NSNumber *maximumPressure;

/*! @brief The settings related with notification and its recurrence. */
@property (nonatomic, strong) BTWUserNotify *notificationSettings;

/*! @brief The current weather for compare in all logic processment. */
@property (nonatomic, strong) BTWWheatherResponse *currentWeather;

/*! @brief Contains the logic for know whether the user will can go to work with its bike. */
- (BOOL)canGoToWorkWithBike;

@end