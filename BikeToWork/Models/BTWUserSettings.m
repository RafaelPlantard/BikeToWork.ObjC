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
    return YES;
}

@end