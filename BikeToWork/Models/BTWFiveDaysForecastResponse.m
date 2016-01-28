//
//  BTWFiveDaysForecast.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWFiveDaysForecastResponse.h"
#import "BTWWheatherResponse.h"

@implementation BTWFiveDaysForecastResponse

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"code": @"cod",
             @"numberOfLines": @"cnt",
             @"forecast": @"list"
             };
}

+ (NSValueTransformer *)forecastJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:BTWWheatherResponse.class];
}

@end