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
#import "BTWWeatherRequest.h"

/*! @brief A entity that encapusates all user settings. */
@interface BTWUserSettings : NSObject

/*! @brief The initial time. */
@property (nonatomic, strong) NSString *startTime;

/*! @brief The end time. */
@property (nonatomic, strong) NSString *endTime;

/*! @brief The acceptable chance of raining. */
@property (nonatomic, strong) NSNumber *chanceOfRaining;

/*! @brief The minimum temperature. */
@property (nonatomic, strong) NSNumber *minimumTemperature;

/*! @brief The maximum temperature. */
@property (nonatomic, strong) NSNumber *maximumTemperature;

/*! @brief The minimum humidity. */
@property (nonatomic, strong) NSNumber *minimumHumidity;

/*! @brief The maximum humidity. */
@property (nonatomic, strong) NSNumber *maximumHumidity;

/*! @brief The settings related with notification and its recurrence. */
@property (nonatomic, strong) BTWUserNotify *notificationSettings;

/*! @brief The current weather for compare in all logic processment. */
@property (nonatomic, strong) BTWWheatherResponse *currentWeather;

/*! @brief The current request information. */
@property (nonatomic, strong) BTWWeatherRequest *requestData;

/*! @brief Contains the logic for know whether the user will can go to work with its bike. */
- (BOOL)canGoToWorkWithBike;

- (BOOL)isTodayGoToWorkWithBike;

/*! @brief Will proccess a verification in all values to be sure that all fields are filled. */
- (BOOL)isReadyToProcess;

/*! @brief Will return the first error that we found in the verification. */
- (NSString *)allErrorsOnValidation;

@end