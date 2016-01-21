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
             @"cityId": @"id",
             @"internalParameters": @"sys"
             };
}

- (NSString *)seeCurrentTip {
    self.internalParameters = [BTWSystemParameters new];
    
    self.internalParameters.sunset = @1453413479;
    self.internalParameters.sunrise = @1453412289;
    
    NSDate *sunsetDateTime = [NSDate dateWithTimeIntervalSince1970:self.internalParameters.sunset.longValue];
    NSDate *sunriseDateTime = [NSDate dateWithTimeIntervalSinceNow:self.internalParameters.sunrise.longValue];
    
    NSDate *now = [NSDate date];
    
    if (([now compare:sunsetDateTime] == NSOrderedDescending) || ([now compare:sunriseDateTime] == NSOrderedAscending)) {
        return @"it's night. be careful on traffic, and use flashlights.";
    }
    
    if ([self.weather.main isEqualToString:@"Rain"]) {
        return @"it's rainy day. don't forget your umbrella.";
    }
    
    if (self.main.humidity.integerValue <= 30) {
        return @"it's low humidity today. remember to drink a lot of water.";
    }
    
    return @"it's sunny today. remember to use sunscreen!";
}

- (NSString *)imageNameForTemperature {
    if ([self.weather.main isEqualToString:@"Clear"]) {
        return @"Sun";
    }
    
    if ([self.weather.main isEqualToString:@"Rain"]) {
        return @"Rain";
    }
    
    return @"Cloud";
}

@end
