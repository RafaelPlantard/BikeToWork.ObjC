//
//  BTWSessionManager+OpenWeatherApi.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWSessionManager+OpenWeatherApi.h"
#import "BTWWheatherResponse.h"
#import "BTWFiveDaysForecastResponse.h"

/*! @brief The app id for access the open wheather api. */
static NSString *const kAppId = @"02a53a355fef3cbb8fa0898fbba375b4";

static NSString *const kWeatherApiEndPointBase = @"/data/2.5/%@";

@implementation BTWSessionManager (OpenWeatherApi)

- (NSURLSessionDataTask *)getResponseFromWeatherApiToEndPoint:(NSString *)apiEndPoint WhereParameters:(BTWWeatherRequest *)requestParameters AndResponseTypeIs:(BTWModelBase *)className OnSuccess:(BTWSuccessBlock)success OnFailure:(BTWFailureBlock)failure {
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestParameters error:nil];
    
    NSMutableDictionary *parametersWithAppId = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parametersWithAppId setValue:kAppId forKey:@"APPID"];
    
    NSString *endPoint = [NSString stringWithFormat:kWeatherApiEndPointBase, apiEndPoint];
    
    return [self GET:endPoint parameters:parametersWithAppId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *errorsOnParse;
        
        id response = [className.class parse:responseDictionary error:&errorsOnParse];
        
        if (response) {
            success(response);
        } else {
            failure(errorsOnParse);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)getWeatherWith:(BTWWeatherRequest *)requestParameters OnSuccess:(BTWSuccessBlock)success OnFailure:(BTWFailureBlock)failure {
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestParameters error:nil];
    
    NSMutableDictionary *parametersWithAppId = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parametersWithAppId setValue:kAppId forKey:@"APPID"];
    
    NSString *endPoint = [NSString stringWithFormat:kWeatherApiEndPointBase, @"weather"];
    
    return [self GET:endPoint parameters:parametersWithAppId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        
        NSError *errorsOnParse;
        
        BTWWheatherResponse *response = [BTWWheatherResponse parse:responseDictionary error:&errorsOnParse];
        
        if (response) {
            success(response);
        } else {
            failure(errorsOnParse);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)getForecastForFiveDaysWith:(BTWWeatherRequest *)requestParameters OnSuccess:(BTWSuccessBlock)success OnFailure:(BTWFailureBlock)failure {
    return [self getResponseFromWeatherApiToEndPoint:@"forecast" WhereParameters:requestParameters AndResponseTypeIs:[BTWWheatherResponse new] OnSuccess:success OnFailure:failure];
}

@end
