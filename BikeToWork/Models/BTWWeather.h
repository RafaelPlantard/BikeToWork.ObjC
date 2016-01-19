//
//  BTWWeather.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief The weather transcription. */
@interface BTWWeather : BTWModelBase

@property (nonatomic, strong) NSNumber *weatherId;

/*! brief A briefly resume of the current weather. */
@property (nonatomic, strong) NSString *main;

/*! @brief A complete description of the weather. */
@property (nonatomic, strong) NSString *weatherDescription;

/*! @brief The id of the icon. */
@property (nonatomic, strong) NSString *icon;

@end
