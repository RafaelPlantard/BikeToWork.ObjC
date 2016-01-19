//
//  BTWSystemParameters.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*! @brief Some details related more with the wheather. */
@interface BTWSystemParameters : BTWModelBase

/*! @brief A type information. */
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSNumber *systemId;

@property (nonatomic, strong) NSNumber *message;

@property (nonatomic, strong) NSString *country;

/*! @brief The sunrise time. */
@property (nonatomic, strong) NSNumber *sunrise;

/*! @brief The sunset time. */
@property (nonatomic, strong) NSNumber *sunset;

@end