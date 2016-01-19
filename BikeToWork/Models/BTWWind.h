//
//  BTWWind.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief The current data of wind. */
@interface BTWWind : BTWModelBase

/*! @brief The speed of wind. */
@property (nonatomic, strong) NSNumber *wind;

/*! @brief The wind direction */
@property (nonatomic, strong) NSNumber *degrees;

@end