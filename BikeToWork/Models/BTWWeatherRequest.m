//
//  BTWWeatherRequest.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWWeatherRequest.h"

@implementation BTWWeatherRequest

- (instancetype)initOn:(NSString *)city WithResultsOnCelsius:(BOOL)isCelsius {
    self = [super init];
    
    if (self) {
        self.city = city;
        self.isInCelsius = isCelsius;
    }
    
    return self;
}

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return @{
             @"city": @"q",
             @"isInCelsius": @"units"
             };
}

+ (NSValueTransformer *)isInCelsiusJSONTransformer {
    NSDictionary *transformerDictionary = @{
                                            @"metric": @YES,
                                            @"imperial": @NO
                                            };
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transformerDictionary];
}

@end