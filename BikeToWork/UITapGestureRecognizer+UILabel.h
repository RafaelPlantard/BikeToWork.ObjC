//
//  UITapGestureRecognizer+UILabel.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/21/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer (UILabel)

- (BOOL)didTapAttributedTextInLabel:(UILabel *)label inRange:(NSRange)targetRange;

@end
