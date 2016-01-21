//
//  BTWResultViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWResultViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kDefaultWhenBikeLabelForToday = @"is today";

static NSString *const kDefaultBikeToWorkDayLabel = @"BIKE TO WORK DAY?";

@implementation BTWResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self doRequest];
    [self adjustAllComponents];
}

- (void)doRequest {
    [self colorizeToBike:[self.settings canGoToWorkWithBike]];
}

- (void)adjustAllComponents {
    // showTipButton
    self.showTipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // temperatureImageView
    UIImage *image = [UIImage imageNamed:[self.settings.currentWeather imageNameForTemperature]];
    [self.temperatureImageView setImage:image];
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

- (IBAction)showTip:(UIButton *)sender {
    static UIFont *bigFont;
    static NSString *originalText;
    
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
    
    [self changeLabelVisibilityBasedOnText:self.whenBikeLabel WhereDefaultText:kDefaultWhenBikeLabelForToday IsToHidden:isToClose];
    [self changeLabelVisibilityBasedOnText:self.bikeToWorkDayLabel WhereDefaultText:kDefaultBikeToWorkDayLabel IsToHidden:isToClose];
}

@end