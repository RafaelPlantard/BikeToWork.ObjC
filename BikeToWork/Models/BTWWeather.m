//
//  BTWWeather.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWWeather.h"

@implementation BTWWeather

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"wheatherId": @"id",
             @"wheatherDescription": @"description"
             };
}

@end
