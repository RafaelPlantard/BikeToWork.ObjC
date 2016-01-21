//
//  BTWUserSettings.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/20/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWUserSettings.h"

@implementation BTWUserSettings

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.currentWeather = [BTWWheatherResponse new];
    }
    
    return self;
}

- (BOOL)canGoToWorkWithBike {
    NSNumber *currentTemperature = self.currentWeather.main.temperature;
    NSNumber *currentHumidity = self.currentWeather.main.humidity;
    NSNumber *currentTime = [NSDate date];
    
    BOOL temperatureOk = (currentTemperature >= self.minimumTemperature) && (currentTemperature <= self.maximumTemperature);
    
    BOOL humidityOk = (currentHumidity >= self.minimumHumidity) && (currentHumidity <= self.maximumHumidity);
    
    BOOL timeOk = YES;
    
    return (temperatureOk && humidityOk);
}

@end