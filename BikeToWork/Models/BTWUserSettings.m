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
        self.startTime = @"8AM";
        self.endTime = @"7PM";
        self.chanceOfRaining = @10;
        self.minimumTemperature = @10;
        self.maximumTemperature = @26;
        self.minimumHumidity = @40;
        self.maximumHumidity = @70;
        self.currentWeather = [BTWWheatherResponse new];
        self.notificationSettings = [[BTWUserNotify alloc] initWithRecurrence:BTWNotificationRecurrenceEveryDay WithAlarmTime:@"7:30AM"];
    }
    
    return self;
}

- (BOOL)canGoToWorkWithBike {
    NSNumber *currentTemperature = self.currentWeather.main.temperature;
    NSNumber *currentHumidity = self.currentWeather.main.humidity;
    NSDate *currentTime = [NSDate date];
    
    BOOL temperatureOk = (currentTemperature >= self.minimumTemperature) && (currentTemperature <= self.maximumTemperature);
    
    BOOL humidityOk = (currentHumidity >= self.minimumHumidity) && (currentHumidity <= self.maximumHumidity);
    
    BOOL timeOk = (currentTime);
    
    return (temperatureOk && humidityOk && timeOk);
}

- (BOOL)isReadyToProcess {
    return ![self allErrorsOnValidation];
}

- (NSString *)allErrorsOnValidation {
    return @"Where are you? Select the city...";
}

@end