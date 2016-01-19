//
//  BTWWeatherRequest.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief An object that encapsulates the data to request whether informations. */
@interface BTWWeatherRequest : BTWModelBase

/*! @brief Name of city of the location. */
@property (nonatomic, strong) NSString *city;

/*! @brief Flag for indicate whether the results will be in imperial or metric standard. */
@property (nonatomic, assign) BOOL isInCelsius;

/*! @brief A custom initializer for this class. */
- (instancetype)initOn:(NSString *)city WithResultsOnCelsius:(BOOL)isCelsius;

@end
