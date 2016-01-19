//
//  BTWCoordinate.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWCoordinate.h"

@implementation BTWCoordinate

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"longitude": @"lon",
             @"latitude": @"lat"
             };
}

@end
