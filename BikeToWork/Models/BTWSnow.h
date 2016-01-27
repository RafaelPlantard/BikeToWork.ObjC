//
//  BTWSnow.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/27/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief The data related with snow on current weather. */
@interface BTWSnow : BTWModelBase

/*! @brief The snow volume for the last 3 hours. */
@property (nonatomic, strong) NSNumber *snowVolume;

@end
