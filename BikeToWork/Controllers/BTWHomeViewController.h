//
//  ViewController.h
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BTWUserSettings.h"
#import "BTWWheatherResponse.h"

#define ToCelsius(f)                    ((f - 32.0) / 1.8)

#define ToFahrenheit(c)                 ((c * 1.8) + 32.0)

#define LinkedTextUIColor               [UIColor colorWithRed:(144.0 / 255.0) green:(219.0 / 255.0) blue:(135.0 / 255.0) alpha:1.0]

#define UsedUnitOnTemperatureUIColor    [UIColor colorWithRed:(149.0 / 255.0) green:(219.0 / 255.0) blue:(135.0 / 255.0) alpha:1.0]

typedef NS_ENUM(NSInteger, BTWLabelLinkClicked)
{
    BTWLabelLinkClickedStartTime,
    BTWLabelLinkClickedEndTime,
    BTWLabelLinkClickedChanceOfRaining,
    BTWLabelLinkClickedMinimumTemperature,
    BTWLabelLinkClickedMaximumTemperature,
    BTWLabelLinkClickedMinimumHumidity,
    BTWLabelLinkClickedMaximumHumidity,
    BTWLabelLinkClickedRecurrenceAlarm,
    BTWLabelLinkClickedTimeToAlarm
};

/*! @brief The controller for orchestres the home view. */
@interface BTWHomeViewController : UIViewController<UITextViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *celsiusButton;

@property (weak, nonatomic) IBOutlet UIButton *fahrenheitButton;

@property (weak, nonatomic) IBOutlet UITextView *mainDataTextView;

@property (weak, nonatomic) IBOutlet UITextView *repeatIntervalTextView;

@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;

@property (weak, nonatomic) IBOutlet UIView *settingsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UISlider *currentSlider;

@property (weak, nonatomic) IBOutlet UILabel *currentValueOnSliderLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabelForSettingsView;

@property (weak, nonatomic) IBOutlet UIDatePicker *currentDatePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *currentPickerView;

#pragma mark - Actions methods

- (IBAction)choiceCity:(UIButton *)sender;

- (IBAction)viewResult;

- (IBAction)changeTemperatureUnit:(UIButton *)sender;

- (IBAction)currentSliderValueChanged:(UISlider *)sender;

- (IBAction)saveChangeOnLabel:(UIButton *)sender;

@end