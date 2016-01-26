//
//  ViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWHomeViewController.h"
#import "BTWResultViewController.h"
#import "BTWWeatherRequest.h"
#import <TSMessages/TSMessage.h>

static NSString *const kRegexForTemperatureDegrees = @"(\\d+)º([A-Z])";

static NSString *const kRegexForFindStringAttributes = @"((\\d+)(%|º[C|F]|AM|PM)|Every .* day|\\d+:\\d+[A|P]M)";

static NSString *const kRegexForNumericPiece = @"\\d+(.*)";

@interface BTWHomeViewController ()

@property (nonatomic, strong) BTWUserSettings *settings;

@property (nonatomic, strong) BTWWeatherRequest *requestData;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) NSString *currentLinkTapped;

@property (nonatomic, assign) NSRange currentRange;

@property (nonatomic, assign) NSInteger stepperForSlider;

@end

@implementation BTWHomeViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        self.settings = [BTWUserSettings new];
        
        self.requestData = [BTWWeatherRequest new];
        self.requestData.isInCelsius = YES;
        
        self.stepperForSlider = 10;
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
    self.currentRange = characterRange;
    
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
            self.requestData.city = self.placemark.locality;
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
    
    self.requestData.isInCelsius = (self.celsiusButton.titleLabel.textColor == UsedUnitOnTemperatureUIColor);
    
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
        
        [self updateTemperatureSettingsBasedOnIndex:idx WithValue:[NSNumber numberWithDouble:round(temperature)]];
    }];
    
    self.mainDataTextView.text = string;
    
    [self processPlaceholdersOnTextView:self.mainDataTextView];
}

- (void)updateSettingsLabelBasedOnIndex:(NSUInteger)index WithValue:(NSNumber *)value {
    switch (index) {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
            
            break;
            
        case 5:
            
            break;
            
        case 6:
            
            break;
            
        default:
            break;
    }
}

- (void)updateTemperatureSettingsBasedOnIndex:(NSUInteger)index WithValue:(NSNumber *)value {
    switch (index) {
        case 0:
            self.settings.minimumTemperature = value;
            break;
            
        case 1:
            self.settings.maximumTemperature = value;
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BTWResultViewController *controller = (BTWResultViewController *)segue.destinationViewController;
    
    controller.settings = self.settings;
}

- (void)changeCurrentSliderEnvironmentWithLabel:(NSString *)label AndValue:(NSNumber *)value WithStepper: (NSInteger)stepper ToMinimumValue:(NSNumber *)minimumValue AndMaximumValue:(NSNumber *)maximumValue {
    self.currentLabelForSettingsView.text = label;
    
    self.currentSlider.minimumValue = [minimumValue floatValue];
    self.currentSlider.maximumValue = [maximumValue floatValue];
    
    switch ([self convertLinkClickedFromString:self.currentLinkTapped]) {
        case BTWLabelLinkClickedMinimumTemperature:
        case BTWLabelLinkClickedMaximumTemperature:
            if (!self.requestData.isInCelsius) {
                self.currentSlider.minimumValue = ToFahrenheit([minimumValue floatValue]);
                self.currentSlider.maximumValue = ToFahrenheit([maximumValue floatValue]);
            }
            break;
            
        default:
            break;
    }
    
    self.stepperForSlider = stepper;
    
    self.currentSlider.value = [value floatValue];
    [self currentSliderValueChanged:self.currentSlider];
    
    self.currentSlider.hidden = NO;
    self.currentValueOnSliderLabel.hidden = NO;
}

#pragma mark - Settings View Change Selectors

- (void)changeToChanceOfRaining {
    [self changeCurrentSliderEnvironmentWithLabel:@"Chance of raining..." AndValue:self.settings.chanceOfRaining WithStepper:10 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToMinimumTemperature {
    [self changeCurrentSliderEnvironmentWithLabel:@"With minimum temperature..." AndValue:self.settings.minimumTemperature WithStepper:1 ToMinimumValue:@0 AndMaximumValue:@40];
}

- (void)changeToMaximumTemperature {
    [self changeCurrentSliderEnvironmentWithLabel:@"With maximum temperature..." AndValue:self.settings.maximumTemperature WithStepper:1 ToMinimumValue:@0 AndMaximumValue:@40];
}

- (void)changeToMinimumHumidity {
    [self changeCurrentSliderEnvironmentWithLabel:@"With minimum humidity..." AndValue:self.settings.minimumHumidity WithStepper:5 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToMaximumHumidity {
    [self changeCurrentSliderEnvironmentWithLabel:@"With maximum humidity..." AndValue:self.settings.maximumHumidity WithStepper:5 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToRecurrenceAlarm {
    self.currentLabelForSettingsView.text = @"With a recurrence on alarm of...";
    
}

- (void)changeAlarmTime {
    self.currentLabelForSettingsView.text = @"With an alarm time on...";
    
}

#pragma mark - Settings View Save Selectors

- (void)updateSettingsForUITextView:(UITextView *)textView WithNumericValue:(NSNumber *)value {
    NSError *errorOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForNumericPiece options:0 error:&errorOnRegex];
    
    NSTextCheckingResult *match = [regex firstMatchInString:self.currentLinkTapped options:0 range:NSMakeRange(0, [self.currentLinkTapped length])];
    
    NSString *complementPiece = [self.currentLinkTapped substringWithRange:[match rangeAtIndex:1]];
    NSString *newString = [NSString stringWithFormat:@"%lu%@", [value integerValue], complementPiece];
    
    textView.text = [textView.text stringByReplacingCharactersInRange:self.currentRange withString:newString];
    
    [self processPlaceholdersOnTextView:textView];
}

- (void)saveChanceOfRaining {
    self.settings.chanceOfRaining = [NSNumber numberWithFloat:self.currentSlider.value];
    [self updateSettingsForUITextView:self.mainDataTextView WithNumericValue:self.settings.chanceOfRaining];
}

- (void)saveMinimumTemperature {
    self.settings.minimumTemperature = [NSNumber numberWithFloat:self.currentSlider.value];
    [self updateSettingsForUITextView:self.mainDataTextView WithNumericValue:self.settings.minimumTemperature];
}

- (void)saveMaximumTemperature {
    self.settings.maximumTemperature = [NSNumber numberWithFloat:self.currentSlider.value];
    [self updateSettingsForUITextView:self.mainDataTextView WithNumericValue:self.settings.maximumTemperature];
}

- (void)saveMinimumHumidity {
    self.settings.minimumHumidity = [NSNumber numberWithFloat:self.currentSlider.value];
    [self updateSettingsForUITextView:self.mainDataTextView WithNumericValue:self.settings.minimumHumidity];
}

- (void)saveMaximumHumidity {
    self.settings.maximumHumidity = [NSNumber numberWithFloat:self.currentSlider.value];
    [self updateSettingsForUITextView:self.mainDataTextView WithNumericValue:self.settings.maximumHumidity];
}

- (void)saveToRecurrenceAlarm {
    NSLog(@"Falta salvar a recurrencia do alarme");
}

- (void)saveAlarmTime {
    NSLog(@"Falta salvar a hora do alarme!");
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
    [sender setValue:((int)((sender.value + (self.stepperForSlider / 2)) / self.stepperForSlider) * self.stepperForSlider) animated:YES];
    
    NSString *valueComplement;
    
    switch ([self convertLinkClickedFromString:self.currentLinkTapped]) {
        case BTWLabelLinkClickedMinimumTemperature:
        case BTWLabelLinkClickedMaximumTemperature:
            valueComplement = (self.requestData.isInCelsius) ? @"ºC" : @"ºF";
            break;
            
        default:
            valueComplement = @"%";
            break;
    }
    
    self.currentValueOnSliderLabel.text = [NSString stringWithFormat:@"%.0f%@", sender.value, valueComplement];
}

- (BTWLabelLinkClicked)convertLinkClickedFromString:(NSString *)stringTapped {
    BTWLabelLinkClicked toReturn = BTWLabelLinkClickedTimeToAlarm;
    
    NSString *unitToUse = (self.requestData.isInCelsius) ? @"C": @"F";
    NSString *chanceOfRaining = [NSString stringWithFormat:@"%lu%%", [self.settings.chanceOfRaining integerValue]];
    NSString *minimumTemperature = [NSString stringWithFormat:@"%luº%@", [self.settings.minimumTemperature integerValue], unitToUse];
    NSString *maximumTemperature = [NSString stringWithFormat:@"%luº%@", [self.settings.maximumTemperature integerValue], unitToUse];
    NSString *minimumHumidity = [NSString stringWithFormat:@"%lu%%", [self.settings.minimumHumidity integerValue]];
    NSString *maximumHumidity = [NSString stringWithFormat:@"%lu%%", [self.settings.maximumHumidity integerValue]];
    
    if ([self.currentLinkTapped isEqualToString:@"8AM"]) {
        toReturn = BTWLabelLinkClickedStartTime;
    } else if ([self.currentLinkTapped isEqualToString:@"7PM"]) {
        toReturn = BTWLabelLinkClickedEndTime;
    } else if ([self.currentLinkTapped isEqualToString:chanceOfRaining]) {
        toReturn = BTWLabelLinkClickedChanceOfRaining;
    } else if ([self.currentLinkTapped isEqualToString:minimumTemperature]) {
        toReturn = BTWLabelLinkClickedMinimumTemperature;
    } else if ([self.currentLinkTapped isEqualToString:maximumTemperature]) {
        toReturn = BTWLabelLinkClickedMaximumTemperature;
    } else if ([self.currentLinkTapped isEqualToString:minimumHumidity]) {
        toReturn = BTWLabelLinkClickedMinimumHumidity;
    } else if ([self.currentLinkTapped isEqualToString:maximumHumidity]) {
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
            case BTWLabelLinkClickedStartTime:
                break;
                
            case BTWLabelLinkClickedEndTime:
                break;
                
            case BTWLabelLinkClickedChanceOfRaining:
                [self performSelector:@selector(changeToChanceOfRaining)];
                break;
                
            case BTWLabelLinkClickedMinimumTemperature:
                [self performSelector:@selector(changeToMinimumTemperature)];
                break;
                
            case BTWLabelLinkClickedMaximumTemperature:
                [self performSelector:@selector(changeToMaximumTemperature)];
                break;
                
            case BTWLabelLinkClickedMinimumHumidity:
                [self performSelector:@selector(changeToMinimumHumidity)];
                break;
                
            case BTWLabelLinkClickedMaximumHumidity:
                [self performSelector:@selector(changeToMaximumHumidity)];
                break;
                
            case BTWLabelLinkClickedRecurrenceAlarm:
                
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                
                break;
        }
    } else {
        switch (referenceLink) {
            case BTWLabelLinkClickedStartTime:
                break;
                
            case BTWLabelLinkClickedEndTime:
                break;
                
            case BTWLabelLinkClickedChanceOfRaining:
                [self performSelector:@selector(saveChanceOfRaining)];
                break;
                
            case BTWLabelLinkClickedMinimumTemperature:
                [self performSelector:@selector(saveMinimumTemperature)];
                break;
                
            case BTWLabelLinkClickedMaximumTemperature:
                [self performSelector:@selector(saveMaximumTemperature)];
                break;
                
            case BTWLabelLinkClickedMinimumHumidity:
                [self performSelector:@selector(saveMinimumHumidity)];
                break;
                
            case BTWLabelLinkClickedMaximumHumidity:
                [self performSelector:@selector(saveMaximumHumidity)];
                break;
                
            case BTWLabelLinkClickedRecurrenceAlarm:
                
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                
                break;
        }
    }
    
    
}
@end