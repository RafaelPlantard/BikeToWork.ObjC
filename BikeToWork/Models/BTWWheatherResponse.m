//
//  BTWWheatherResponse.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWWheatherResponse.h"

@implementation BTWWheatherResponse

static NSDictionary* tips;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"coordinate": @"cord",
             @"timeCalculation": @"dt",
             @"cityId": @"id"
             };
}

- (NSString *)seeCurrentTip {
    return @"it's sunny today. remember to use sunscreen!";
}

- (NSString *)imageNameForTemperature {
    return @"Cloud";
}

@end
