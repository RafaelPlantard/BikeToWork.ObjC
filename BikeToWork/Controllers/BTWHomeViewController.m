//
//  ViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWHomeViewController.h"

@interface BTWHomeViewController ()

@end

@implementation BTWHomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
}

@end
