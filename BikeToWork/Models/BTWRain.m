//
//  BTWRain.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWRain.h"

@implementation BTWRain

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"rainVolume": @"3h"
             };
}

@end