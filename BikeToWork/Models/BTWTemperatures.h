//
//  BTWWeatherTemperatures.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief All temperatures for the current weather. */
@interface BTWTemperatures : BTWModelBase

/*! @brief The current temperature. */
@property (nonatomic, strong) NSNumber *temperature;

/*! @brief The minimum tempetature. */
@property (nonatomic, strong) NSNumber *temperatureMinimum;

/*! @brief The maximum temperature. */
@property (nonatomic, strong) NSNumber *temperatureMaximum;

/*! @brief The current pressure. */
@property (nonatomic, strong) NSNumber *pressure;

/*! @brief Atmospheric pressure on the sea level, hPa. */
@property (nonatomic, strong) NSNumber *pressureOnSeaLevel;

/*! @brief Atmospheric pressure on the ground level, hPa. */
@property (nonatomic, strong) NSNumber *pressureOnGroundLevel;

/*! @brief The current humidity. */
@property (nonatomic, strong) NSNumber *humidity;

/*! @brief An internal parameter. */
@property (nonatomic, strong) NSNumber *internalParameter;

@end
