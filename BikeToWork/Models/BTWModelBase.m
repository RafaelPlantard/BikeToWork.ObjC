//
//  FDCMantleBase.m
//  FirstDribbbleChallenge
//
//  Created by Douglas Barreto and Rafael Ferreira on 1/13/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWModelBase.h"

/*!@brief The character that marks other word in the property name on json file. */
static NSString *const kDefaultScape = @"_";

/*! @brief The pattern that is used to represent the property name with a scaped character before it. */
static NSString *const kPatternToReplacement = @"%@$1";

/*! @brief The Regular Expression that matches only letters in upper case. */
static NSString *const kRegexPattern = @"([A-Z])";

@implementation BTWModelBase

#pragma mark - Static variables

/*!
 @brief The current scape character.
 @remarks For default its value is '_'.
 */
static NSString *scapeCharacter;

#pragma mark - Public methods

+ (NSDictionary *)customJSONKeyPathsByPropertyKey {
    return [NSDictionary new];
}

+ (NSString *)JSONScapeOnConvert {
    return kDefaultScape;
}

#pragma mark - Private helpers methods

+ (NSDictionary *) convertDictionaryPropertiesToJsonProperties {
    NSDictionary *mantleMap = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    
    NSMutableDictionary *customMantleMap = [NSMutableDictionary new];
    
    [mantleMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [customMantleMap setObject:[self convertPropertyClassToJSONProperty:key toEscape:[self JSONScapeOnConvert]]forKey:key];
    }];
    
    [customMantleMap addEntriesFromDictionary:[self customJSONKeyPathsByPropertyKey]];
    
    return [NSDictionary dictionaryWithDictionary:customMantleMap];
}

+ (NSString *)convertPropertyClassToJSONProperty:(NSString *)propertyName toEscape:(NSString *)escapeString {
    NSString *replaceString = [NSString stringWithFormat:kPatternToReplacement, escapeString];
    
    NSError *errorsOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexPattern options:0 error:&errorsOnRegex];
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:propertyName options:0 range:NSMakeRange(0, [propertyName length]) withTemplate:replaceString];
    
    return [modifiedString lowercaseString];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self convertDictionaryPropertiesToJsonProperties];
}

@end