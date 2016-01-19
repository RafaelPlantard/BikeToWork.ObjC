//
//  BTWSystemParameters.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSystemParameters.h"

@implementation BTWSystemParameters

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"systemId": @"id"
             };
}

@end