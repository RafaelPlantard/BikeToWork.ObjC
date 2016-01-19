//
//  BTWSessionManager+OpenWeatherApi.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSessionManager.h"

/*! @brief The block that is called when a request returns a success response. */
typedef void(^BTWSuccessBlock)(id response);

/*! @brief The block that is called when the request failed. */
typedef void(^BTWFailureBlock)(NSError * error);

/*! @brief The method set for requests and responses from Open Weather Api. */
@interface BTWSessionManager (OpenWeatherApi)

- (NSURLSessionDataTask *)getWeather;

@end
