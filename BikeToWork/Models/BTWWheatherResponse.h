//
//  BTWWheatherResponse.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"
#import "BTWCoordinate.h"
#import "BTWTemperatures.h"
#import "BTWWind.h"
#import "BTWClouds.h"
#import "BTWRain.h"
#import "BTWSnow.h"
#import "BTWSystemParameters.h"

@interface BTWWheatherResponse : BTWModelBase

/*! @brief The coordinates data. */
@property (nonatomic, strong) BTWCoordinate *coordinate;

/*! @brief An array with the weather itself. */
@property (nonatomic, strong) NSArray *weather;

/*! @brief The base that this data was captured. */
@property (nonatomic, strong) NSString *base;

/*! @brief All temperatures. */
@property (nonatomic, strong) BTWTemperatures *main;

/*! @brief The wind data. */
@property (nonatomic, strong) BTWWind *wind;

/*! @brief The cloud data. */
@property (nonatomic, strong) BTWClouds *clouds;

/*! @brief The current rain data. */
@property (nonatomic, strong) BTWRain *rain;

/*! @brief The current snow data. */
@property (nonatomic, strong) BTWSnow *snow;

/*! @brief Time of data forecasted, unix, UTC. */
@property (nonatomic, strong) NSNumber *timeCalculation;

/*! @brief The name of the city. */
@property (nonatomic, strong) NSString *name;

/*! @brief The city id. */
@property (nonatomic, strong) NSNumber *cityId;

/*! @brief The internal parameters. */
@property (nonatomic, strong) BTWSystemParameters *internalParameters;

/*! @brief  Data/time of calculation, UTC. */
@property (nonatomic, strong) NSString *dateTimeString;

/*! @brief Based on the current weather return a tip. */
- (NSString *)seeCurrentTip;

/*! @brief Based on the current temperature returns the better image for show it. */
- (NSString *)imageNameForTemperature;

@end