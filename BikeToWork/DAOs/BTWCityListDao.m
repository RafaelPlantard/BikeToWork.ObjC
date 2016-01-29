//
//  BTWCityDao.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/28/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWCityListDao.h"
#import "BTWCity.h"
#import <TLJsonFactory/TLJsonFactory.h>
#import <SSZipArchive/ZipArchive.h>

@implementation BTWCityListDao

+ (NSArray *)getAllCities {
    static NSArray *cities;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSArray *jsonCityArray = [TLJsonFactory tl_jsonArrayFromFile:@"CityListFromWeatherOpenAPI"];
        
        NSError *errorsOnParse;
        cities = [MTLJSONAdapter modelsOfClass:[BTWCity class] fromJSONArray:jsonCityArray error:&errorsOnParse];
    });
    
    return cities;
}

@end
