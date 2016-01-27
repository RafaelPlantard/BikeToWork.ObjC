//
//  BTWRain.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief Data for rain volume for the last 3 hours.*/
@interface BTWRain : BTWModelBase

/*! @brief The rain volume for the last 3 hours. */
@property (nonatomic, strong) NSNumber *rainVolume;

@end