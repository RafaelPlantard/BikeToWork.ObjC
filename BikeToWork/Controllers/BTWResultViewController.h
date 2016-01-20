//
//  BTWResultViewController.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWUserSettings.h"
#import "BTWWheatherResponse.h"

#define HyperBlueDark   [UIColor colorWithRed:(39.0 / 255.0) green:(46.0 / 255.0) blue:(63.0 / 255.0) alpha:1.0]

/*! @brief The controller for result view. */
@interface BTWResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *whenBikeLabel;

@property (weak, nonatomic) IBOutlet UIButton *showTipButton;

@property (weak, nonatomic) IBOutlet UILabel *canBikeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bikeImageView;

@property (weak, nonatomic) IBOutlet UIButton *tapForTipButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UIImageView *humidityImageView;

@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *bikeToWorkDayLabel;

/*! @brief The settings to check if the user can go to work with bike. */
@property (nonatomic, strong) BTWUserSettings *settings;

/*! @brief The response from API. */
@property (nonatomic, strong) BTWWheatherResponse *currentWeather;

- (IBAction)backToSettings;

- (IBAction)shareContent;

- (IBAction)showTip:(UIButton *)sender;

@end
