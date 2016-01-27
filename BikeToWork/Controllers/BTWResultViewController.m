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

static NSString *defaultWhenBikeLabelForToday;
static NSString *defaultBikeToWorkDayLabel;
static UIFont *bigFont;
static NSString *originalText;

#pragma mark - UIView methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateStatusOfApp];
    [self saveDefaultValueOfComponents];
    [self adjustAllComponents];
}

#pragma mark - UIView helper methods

- (void)saveDefaultValueOfComponents {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultWhenBikeLabelForToday = self.whenBikeLabel.text;
        defaultBikeToWorkDayLabel = self.bikeToWorkDayLabel.text;
    });
}

- (void)updateStatusOfApp {
    [self colorizeToBike:[self.settings canGoToWorkWithBike]];
}

- (void)adjustAllComponents {
    // showTipButton
    self.showTipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // temperatureImageView
    UIImage *image = [UIImage imageNamed:[self.settings.currentWeather imageNameForTemperature]];
    [self.temperatureImageView setImage:image];
    
    // timeLabel
    NSString *timeString = [NSString stringWithFormat:@"%@ - %@", self.settings.startTime, self.settings.endTime];
    self.timeLabel.text = timeString;
    
    BTWWheatherResponse *weather = self.settings.currentWeather;
    
    // temperatureLabel
    NSString *temperatureString = [NSString stringWithFormat:@"%luº", [weather.main.temperature integerValue]];
    self.temperatureLabel.text = temperatureString;
    
    // humidityLabel
    NSString *humidityString = [NSString stringWithFormat:@"%lu%%", [weather.main.humidity integerValue]];
    self.humidityLabel.text = humidityString;
    
    // locationLabel
    self.locationLabel.text = self.settings.requestData.city;
    
    self.whenBikeLabel.text = 
}

- (void)colorizeToBike:(BOOL)canBike {
    if (!canBike) {
        self.view.backgroundColor = HyperBlueDark;
        self.canBikeLabel.text = @"no";
        [self.bikeImageView setImage:[UIImage imageNamed:@"NoIcon"]];
        self.tapForTipButton.hidden = YES;
        self.shareButton.backgroundColor = HyperBlueDark;
    }
}

#pragma mark - Action helper methods

- (void)changeLabelVisibilityBasedOnText:(UILabel *)label WhereDefaultText:(NSString *)defaultText IsToHidden:(BOOL)isToHidden {
    if (isToHidden) {
        [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                label.text = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            label.alpha = 1;
            label.text = defaultText;
        } completion:nil];
    }
}

#pragma mark - Action methods

- (IBAction)backToSettings {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareContent {
    NSString *messageToShare = @"will I bike to work today? yes! the conditions are perfect. download bike2work app.";
    
    if ([self.shareButton.backgroundColor isEqual:HyperBlueDark]) {
        messageToShare = @"will I bike to work today? no ): unfortunately the conditions are not good. download bike2work app.";
    }
    
    NSArray *itemsToShare = @[messageToShare];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePostToFlickr, UIActivityTypePostToTwitter];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)showTip:(UIButton *)sender {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bigFont = self.canBikeLabel.font;
        originalText = self.canBikeLabel.text;
    });
    
    UIImage *image = [UIImage imageNamed:@"TapForTip"];
    
    BOOL isToClose = [sender.currentImage isEqual:image];
    
    if (isToClose) {
        [self.showTipButton setImage:[UIImage imageNamed:@"CloseTip"] forState:UIControlStateNormal];
    } else {
        [self.showTipButton setImage:image forState:UIControlStateNormal];
    }
    
    NSString *newCanBikeText = (isToClose) ? [self.settings.currentWeather seeCurrentTip] : originalText;
    UIFont *font = (isToClose) ? self.whenBikeLabel.font : bigFont;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.canBikeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.canBikeLabel.font = font;
            [self.canBikeLabel setText: newCanBikeText];
            self.canBikeLabel.alpha = 1;
        }
    }];
    
    [self changeLabelVisibilityBasedOnText:self.whenBikeLabel WhereDefaultText:defaultWhenBikeLabelForToday IsToHidden:isToClose];
    [self changeLabelVisibilityBasedOnText:self.bikeToWorkDayLabel WhereDefaultText:defaultBikeToWorkDayLabel IsToHidden:isToClose];
}

@end