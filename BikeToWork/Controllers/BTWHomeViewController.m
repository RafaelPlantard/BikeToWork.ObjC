//
//  ViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWHomeViewController.h"
#import "BTWResultViewController.h"
#import <TSMessages/TSMessage.h>

static NSString *const kRegexForTemperatureDegrees = @"(\\d+)º([A-Z])";

static NSString *const kRegexForFindStringAttributes = @"((\\d+)(%|º[C|F])|Every .* day|\\d+:\\d+[A|P]M)";

@interface BTWHomeViewController ()

@property (nonatomic, strong) BTWUserSettings *settings;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, assign) NSString *currentLinkTapped;

@end

@implementation BTWHomeViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        self.settings = [BTWUserSettings new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLocationManager];
    [self adjustSwipeGestureForBack];
    [self adjustAllComponents];
}

- (void)setUpLocationManager {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.geoCoder = [CLGeocoder new];
}

- (void)adjustSwipeGestureForBack {
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
}

- (void)adjustAllComponents {
    // currentLocationButton
    [self.currentLocationButton setTitle:@"City" forState:UIControlStateNormal];
    
    // mainDataField
    [self processPlaceholdersOnTextView:self.mainDataTextView];
    
    // repeatIntervalField
    [self processPlaceholdersOnTextView:self.repeatIntervalTextView];
    
    // settingsView
    [self changeVisibilityOfSettingsViewToShow];
}

- (void)processPlaceholdersOnTextView:(UITextView *)textView {
    NSError *errorsOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForFindStringAttributes options:0 error:&errorsOnRegex];
    
    NSArray *matches = [regex matchesInString:textView.text options:0 range:NSMakeRange(0, textView.text.length)];
    
    NSDictionary *currentTextFormat = @{
                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: textView.font,
                                        NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]
                                        };
    
    NSDictionary *linkAttributes = @{
                                     NSForegroundColorAttributeName: LinkedTextUIColor,
                                     NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text attributes:currentTextFormat];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = match.range;
        NSString *stringTapped = [textView.text substringWithRange:range];
        stringTapped = [stringTapped stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [attributedString addAttribute:NSLinkAttributeName value:stringTapped range:range];
        textView.linkTextAttributes = linkAttributes;
    }
    
    textView.attributedText = attributedString;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString *stringPassed = [[NSString stringWithFormat:@"%@", URL] stringByRemovingPercentEncoding];
    
    self.currentLinkTapped = stringPassed;
    
    NSLog(@"%@", stringPassed);
    
    [self showSettingsView];
    
    return NO;
}

- (void)showSettingsView {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self changeVisibilityOfSettingsViewToShow];
        [self.settingsView layoutIfNeeded];
        
    } completion:nil];
}

- (void)changeVisibilityOfSettingsViewToShow{
    BOOL isToOpen = (self.settingsViewHeightConstraint.constant == 0);
    
    self.settingsViewHeightConstraint.constant = isToOpen ? 250 : 0;
    
    if (isToOpen) {
        [self performAnActionBasedLabelLinkTappedIsToChangeView:YES];
    }
}

- (IBAction)choiceCity:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
}

- (void)updateCityNameBasedOnLocation:(CLLocation *)currentLocation {
    [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placemark = [placemarks lastObject];
        
        if (error || !self.placemark) {
            [TSMessage showNotificationWithTitle:@"Bike 2 Work" subtitle:@"Impossible resolve your city based on your location" type:TSMessageNotificationTypeError];
        } else {
            [self.currentLocationButton setTitle:self.placemark.locality forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)viewResult {
}

- (IBAction)changeTemperatureUnit:(UIButton *)sender {
    UIColor *newColor = self.celsiusButton.titleLabel.textColor;
    
    [self.celsiusButton setTitleColor:self.fahrenheitButton.titleLabel.textColor forState:UIControlStateNormal];
    [self.fahrenheitButton setTitleColor:newColor forState:UIControlStateNormal];
    
    [self updateTemperatureUnitsOnText];
}

- (void)updateTemperatureUnitsOnText {
    NSError *errorsOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForTemperatureDegrees options:0 error:&errorsOnRegex];
    
    __block NSString *string = self.mainDataTextView.text;
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    [matches enumerateObjectsUsingBlock:^(id  _Nonnull match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange temperatureRange = [match rangeAtIndex:1];
        NSRange unitRange = [match rangeAtIndex:2];
        
        double temperature = [string substringWithRange:temperatureRange].doubleValue;
        NSString *unit = [string substringWithRange:unitRange];
        
        temperature = ([unit isEqualToString:@"C"]) ? ToFahrenheit(temperature) : ToCelsius(temperature);
        
        NSString *temperatureString = [NSString stringWithFormat:@"%.0f", temperature];
        NSString *newUnit = ([unit isEqualToString:@"C"]) ? @"F" : @"C";
        
        string = [string stringByReplacingCharactersInRange:temperatureRange withString:temperatureString];
        string = [string stringByReplacingCharactersInRange:unitRange withString:newUnit];
    }];
    
    self.mainDataTextView.text = string;
    
    [self processPlaceholdersOnTextView:self.mainDataTextView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BTWResultViewController *controller = (BTWResultViewController *)segue.destinationViewController;
    
    controller.settings = self.settings;
}

#pragma mark - Settings View Change Selectors

- (void)changeToChanceOfRaining {
    
}

#pragma mark - Settings View Save Selectors

- (void)saveChanceOfRaining {
    
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [TSMessage showNotificationWithTitle:@"Bike 2 Work" subtitle:@"Error on location services." type:TSMessageNotificationTypeError];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.userLocation = [locations lastObject];
    
    [self updateCityNameBasedOnLocation:self.userLocation];
    
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)currentSliderValueChanged:(UISlider *)sender {
    [sender setValue:((int)((sender.value + 5) / 10) * 10) animated:YES];
    
    NSString *valueComplement;
    
    switch ([self convertLinkClickedFromString:self.currentLinkTapped]) {
        case BTWLabelLinkClickedMinimumTemperature:
        case BTWLabelLinkClickedMaximumTemperature:
            valueComplement = @"ºC";
            break;
            
        default:
            valueComplement = @"%";
            break;
    }
    
    self.currentValueOnSliderLabel.text = [NSString stringWithFormat:@"%.0f%@", sender.value, valueComplement];
}

- (BTWLabelLinkClicked)convertLinkClickedFromString:(NSString *)stringTapped {
    BTWLabelLinkClicked toReturn = BTWLabelLinkClickedTimeToAlarm;
    
    if ([self.currentLinkTapped isEqualToString:@"10%"]) {
        toReturn = BTWLabelLinkClickedChanceOfRaining;
    } else if ([self.currentLinkTapped isEqualToString:@"10ºC"]) {
        toReturn = BTWLabelLinkClickedMinimumTemperature;
    } else if ([self.currentLinkTapped isEqualToString:@"26ºC%"]) {
        toReturn = BTWLabelLinkClickedMaximumTemperature;
    } else if ([self.currentLinkTapped isEqualToString:@"40%"]) {
        toReturn = BTWLabelLinkClickedMinimumHumidity;
    } else if ([self.currentLinkTapped isEqualToString:@"70%"]) {
        toReturn = BTWLabelLinkClickedMaximumHumidity;
    } else if ([self.currentLinkTapped isEqualToString:@"Every work day"]) {
        toReturn = BTWLabelLinkClickedRecurrenceAlarm;
    }
    
    return toReturn;
}

- (IBAction)saveChangeOnLabel:(UIButton *)sender {
    [self performAnActionBasedLabelLinkTappedIsToChangeView:NO];
    
    [self showSettingsView];
}

- (void) performAnActionBasedLabelLinkTappedIsToChangeView:(BOOL)isToChangeView {
    BTWLabelLinkClicked referenceLink = [self convertLinkClickedFromString:self.currentLinkTapped];
    
    if (isToChangeView) {
        switch (referenceLink) {
            case BTWLabelLinkClickedChanceOfRaining:
                [self performSelector:@selector(changeToChanceOfRaining)];
                break;
                
            case BTWLabelLinkClickedMinimumTemperature:
                
                break;
                
            case BTWLabelLinkClickedMaximumTemperature:
                
                break;
                
            case BTWLabelLinkClickedMinimumHumidity:
                
                break;
                
            case BTWLabelLinkClickedMaximumHumidity:
                
                break;
                
            case BTWLabelLinkClickedRecurrenceAlarm:
                
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                
                break;
        }
    } else {
        switch (referenceLink) {
            case BTWLabelLinkClickedChanceOfRaining:
                [self performSelector:@selector(saveChanceOfRaining)];
                break;
                
            case BTWLabelLinkClickedMinimumTemperature:
                
                break;
                
            case BTWLabelLinkClickedMaximumTemperature:
                
                break;
                
            case BTWLabelLinkClickedMinimumHumidity:
                
                break;
                
            case BTWLabelLinkClickedMaximumHumidity:
                
                break;
                
            case BTWLabelLinkClickedRecurrenceAlarm:
                
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                
                break;
        }
    }
    
    
}
@end