//
//  BTWWind.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWWind.h"

@implementation BTWWind

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"degrees": @"deg"
             };
}

@end