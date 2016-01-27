//
//  BTWCity.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"
#import "BTWCoordinate.h"

@interface BTWCity : BTWModelBase

/*! @brief The city ID. */
@property (nonatomic, strong) NSNumber *cityId;

/*! @brief The city name. */
@property (nonatomic, strong) NSString *name;

/*! @brief The coordinate of the city. */
@property (nonatomic, strong) BTWCoordinate *coordinate;

/*! @brief The country code. */
@property (nonatomic, strong) NSString *country;

@end