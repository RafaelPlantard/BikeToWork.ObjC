//
//  BTWCityDao.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/28/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWCityListDao.h"
#import <SSZipArchive/ZipArchive.h>

@implementation BTWCityListDao

+ (NSArray *)getAllCities {
    static NSArray *cities;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [SSZipArchive unzipFileAtPath:@"Resources/city.list.json.zip" toDestination:@"Resources/city.list.json" progressHandler:nil completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            NSLog(@"path = %@, succeeded = %i, error = %@", path, succeeded, error);
            
            
        }];
    });
    
    return nil;
}

@end
