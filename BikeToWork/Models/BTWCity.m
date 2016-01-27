//
//  BTWCity.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWCity.h"

@implementation BTWCity

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"cityId": @"id",
             @"coordinate": @"coord"
             };
}

@end