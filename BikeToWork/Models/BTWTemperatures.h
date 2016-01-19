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

/*! @brief The current pressure. */
@property (nonatomic, strong) NSNumber *pressure;

/*! @brief The current humidity. */
@property (nonatomic, strong) NSNumber *humidity;

/*! @brief The minimum tempetature. */
@property (nonatomic, strong) NSNumber *temperatureMinimum;

/*! @brief The maximum temperature. */
@property (nonatomic, strong) NSNumber *temperatureMaximum;

@end
