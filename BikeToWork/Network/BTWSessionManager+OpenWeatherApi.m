//
//  BTWSessionManager+OpenWeatherApi.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSessionManager+OpenWeatherApi.h"
#import "BTWWheatherResponse.h"

/*! @brief The app id for access the open wheather api. */
static NSString *const kAppId = @"02a53a355fef3cbb8fa0898fbba375b4";

static NSString *const kWeatherApiEndPointBase = @"/data/2.5/%@";

@implementation BTWSessionManager (OpenWeatherApi)

- (NSURLSessionDataTask *)getWeatherWith:(BTWWeatherRequest *)requestParameters OnSuccess:(BTWSuccessBlock)success OnFailure:(BTWFailureBlock)failure {
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestParameters error:nil];
    
    NSMutableDictionary *parametersWithAppId = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parameters setValue:kAppId forKey:@"APPID"];
    
    NSString *endPoint = [NSString stringWithFormat:kWeatherApiEndPointBase, @"weather"];
    
    return [self GET:endPoint parameters:parametersWithAppId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *errorsOnParse;
        BTWWheatherResponse *response = [MTLJSONAdapter modelOfClass:[BTWWheatherResponse class] fromJSONDictionary:responseDictionary error:&errorsOnParse];
        
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
