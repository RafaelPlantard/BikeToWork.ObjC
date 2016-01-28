//
//  BTWCityList.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/28/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

@interface BTWCityList : BTWModelBase

/*! @brief An array with all list available on Weather Open API. */
@property (nonatomic, strong) NSArray *cities;

@end