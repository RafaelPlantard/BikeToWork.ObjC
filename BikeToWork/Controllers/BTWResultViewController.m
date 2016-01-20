//
//  BTWResultViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWResultViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BTWResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustAllComponents];
    [self colorizeToBike:NO];
}

- (void)adjustAllComponents {
    // showTipButton
    self.showTipButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)colorizeToBike:(BOOL)canBike {
    if (canBike) {
        
    } else {
        // rgb(39,46,63)
        self.view.backgroundColor = [UIColor colorWithRed:(39.0 / 255.0) green:(46.0 / 255.0) blue:(63.0 / 255.0) alpha:1.0];
        self.canBikeLabel.text = @"no";
    }
}

@end
