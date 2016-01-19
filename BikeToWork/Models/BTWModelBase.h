//
//  FDCMantleBase.h
//  FirstDribbbleChallenge
//
//  Created by Douglas Barreto and Rafael Ferreira on 1/13/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <bricks-Mantle/BKMBaseMantleObj.h>

/*!
 @brief This class turn more easier the convert of a public property class to a json representation on mantle model.
 @discussion 
 It will map all public properties to a NSDictionary where the Mantle framework will get and make the bind between the properties and json properties.
 To turn a behavior of binding class property with json property see the method customJSONKeyPathsByPropertyKey.
 */
@interface BTWModelBase : BKMBaseMantleObj

/*! @brief The method that contains all properties that have different names on json property name side. */
+ (NSDictionary *)customJSONKeyPathsByPropertyKey;

/*!
 @brief Changes the scape that is used for separate words on property names.
 @discussion For standard this scape is '_'.
 @remarks This escape is used to marks the end of a break between words.
 */
+ (NSString *)JSONScapeOnConvert;

@end