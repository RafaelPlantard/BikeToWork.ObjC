//
//  BTWWheatherResponse.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWWheatherResponse.h"

@implementation BTWWheatherResponse

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"coordinate": @"cord",
             @"timeCalculation": @"dt",
             @"cityId": @"id"
             };
}

@end
