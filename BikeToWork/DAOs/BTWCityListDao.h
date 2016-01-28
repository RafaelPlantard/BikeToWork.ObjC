//
//  BTWCityDao.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/28/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief A data access object to get all city object from a json file compressed on a zip file.*/
@interface BTWCityListDao : NSObject

+ (NSArray *)getAllCities;

@end
