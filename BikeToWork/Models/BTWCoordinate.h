//
//  BTWCoordinate.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief Contains the data of longitude and latitude. */
@interface BTWCoordinate : BTWModelBase

@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *latitude;

@end
