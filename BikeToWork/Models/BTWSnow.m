//
//  BTWSnow.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSnow.h"

@implementation BTWSnow

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"snowVolume": @"3h"
             };
}

@end