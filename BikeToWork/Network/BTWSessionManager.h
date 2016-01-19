//
//  BTWSessionManager.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

/*! @brief A custom session manager for network requests. */
@interface BTWSessionManager : AFHTTPSessionManager

/*! @brief A singleton object for this session manager. */
+ (instancetype)sharedManager;

@end
