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
        self.view.backgroundColor = HyperBlueDark;
        self.canBikeLabel.text = @"no";
        [self.bikeImageView setImage:[UIImage imageNamed:@"NoIcon"]];
        self.tapForTipButton.hidden = YES;
        self.shareButton.backgroundColor = HyperBlueDark;
    }
}

- (IBAction)backToSettings {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
