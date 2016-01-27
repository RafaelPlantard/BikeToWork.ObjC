//
//  BTWFiveDaysForecast.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"
#import "BTWCity.h"

/*! @brief 5 day forecast is available at any location or city. It includes weather data every 3 hours. */
@interface BTWFiveDaysForecastResponse : BTWModelBase

/*! @brief The code, an internal parameter. */
@property (nonatomic, strong) NSString *code;

/*! @brief The message, an internal parameter. */
@property (nonatomic, strong) NSNumber *message;

/*! @brief The set of city data. */
@property (nonatomic, strong) BTWCity *city;

/*! @brief Number of lines returned by this API call. */
@property (nonatomic, strong) NSNumber *numberOfLines;

/*! @brief An array with all weather returned on this forecast. */
@property (nonatomic, strong) NSArray *forecast;

@end