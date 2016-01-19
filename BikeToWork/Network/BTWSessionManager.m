//
//  BTWSessionManager.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSessionManager.h"

/*! @brief The base url for this session manager. */
static NSString *const kBaseUrl = @"http://api.openweathermap.org";

@implementation BTWSessionManager

- (instancetype)init
{
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURL *baseURL = [NSURL URLWithString:kBaseUrl];
    
    self = [super initWithBaseURL:baseURL sessionConfiguration:defaultConfiguration];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static BTWSessionManager *sessionManager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sessionManager = [self new];
    });
    
    return sessionManager;
}

@end
