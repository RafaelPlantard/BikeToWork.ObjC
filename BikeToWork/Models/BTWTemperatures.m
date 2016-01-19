//
//  BTWWeatherTemperatures.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWTemperatures.h"

@implementation BTWTemperatures

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"temperature": @"temp",
             @"temperatureMinimum": @"temp_min",
             @"temperatureMaximum": @"temp_max"
             };
}

@end