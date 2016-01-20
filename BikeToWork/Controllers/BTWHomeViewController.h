//
//  ViewController.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWUserSettings.h"
#import "BTWWheatherResponse.h"

#define ToCelsius(f)    ((f - 32.0) / 1.8)

#define ToFahrenheit(c) ((c * 1.8) + 32.0)

/*! @brief The controller for orchestres the home view. */
@interface BTWHomeViewController : UIViewController {
    BTWUserSettings *settings;
    BTWWheatherResponse *weather;
}

- (IBAction)choiceCity:(UIButton *)sender;

- (IBAction)viewResult;

- (IBAction)changeTemperatureUnit:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *celsiusButton;

@property (weak, nonatomic) IBOutlet UIButton *fahrenheitButton;

@property (weak, nonatomic) IBOutlet UILabel *mainDataField;

@property (weak, nonatomic) IBOutlet UILabel *repeatIntervalField;

@end