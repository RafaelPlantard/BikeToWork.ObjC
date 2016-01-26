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

static NSString *const kRegexForFindStringAttributes = @"((\\d+)(%|º[C|F]|AM|PM)|Every .*day|Once time|\\d+:\\d+[A|P]M)";

static NSString *const kRegexForNumericPiece = @"\\d+(.*)";

static NSString *const kRegexForTime = @"(\\d)+:(\\d+)([A|P]M)";

static NSString *const kTitleAlertMessage = @"Bike 2 Work";

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

@property (nonatomic, assign) BOOL isToOpenSettingsView;

@property (nonatomic, assign) NSInteger indexOfSelectedRecurrenceAlarm;

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
        
    } completion:^(BOOL finished) {
        if (!self.isToOpenSettingsView) {
            self.settingsView.hidden = YES;
        }
    }];
}

- (void)changeVisibilityOfSettingsViewToShow{
    static CGFloat maxHeightOnContraint;
    static CGFloat maxAlphaSettingsView;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        maxHeightOnContraint = self.settingsViewHeightConstraint.constant;
        maxAlphaSettingsView = self.settingsView.alpha;
    });
    
    self.isToOpenSettingsView = (self.settingsViewHeightConstraint.constant == 0);
    
    if (self.isToOpenSettingsView) {
        self.settingsView.hidden = NO;
        
        [self performAnActionBasedLabelLinkTappedIsToChangeView:YES];
    }
    
    self.settingsView.alpha = (self.isToOpenSettingsView) ? maxAlphaSettingsView : 0;
    self.settingsViewHeightConstraint.constant = (self.isToOpenSettingsView) ? maxHeightOnContraint : 0;
}

- (IBAction)choiceCity:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
}

- (void)updateCityNameBasedOnLocation:(CLLocation *)currentLocation {
    [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placemark = [placemarks lastObject];
        
        if (error || !self.placemark) {
            [TSMessage showNotificationWithTitle:kTitleAlertMessage subtitle:@"Impossible resolve your city based on your location" type:TSMessageNotificationTypeError];
        } else {
            self.requestData.city = self.placemark.locality;
            [self.currentLocationButton setTitle:self.placemark.locality forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)viewResult {
    if (![self.settings isReadyToProcess]) {
        [TSMessage showNotificationWithTitle:kTitleAlertMessage subtitle:[self.settings allErrorsOnValidation] type:TSMessageNotificationTypeWarning];
    }
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

- (void)changeCurrentSliderEnviromnentWithLabel:(NSString *)label AndValue:(NSNumber *)value WithStepper: (NSInteger)stepper ToMinimumValue:(NSNumber *)minimumValue AndMaximumValue:(NSNumber *)maximumValue {
    self.currentDatePicker.hidden = YES;
    self.currentPickerView.hidden = YES;
    
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

- (void)changeCurrentDatePickerEnrivomnentWithLabel:(NSString *)label AndTimeInterval:(NSInteger)minuteInterval WhereMinimumTime:(NSString *)minimumTime AndMaximumTime:(NSString *)maximumTime ForCurrentTime:(NSString *)currentTime {
    self.currentSlider.hidden = YES;
    self.currentValueOnSliderLabel.hidden = YES;
    self.currentPickerView.hidden = YES;
    
    self.currentLabelForSettingsView.text = label;
    
    [self defineRangeOfTimeToDatePicker:self.currentDatePicker WithMinimumTime:minimumTime AndMaximumTime:maximumTime AndMinuteInterval:minuteInterval];
    
    self.currentDatePicker.hidden = NO;
}

#pragma mark - Settings View Change Selectors

- (NSDate *)getDateFromFormat:(NSString *)dateFormat BasedOnDate:(NSDate *)date WithTime:(NSString *)timeString AndTimeFormat:(NSString *)timeFormat {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormat;
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:date], timeString];
    
    dateFormatter.dateFormat = [NSString stringWithFormat:@"%@ %@", dateFormat, timeFormat];
    
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)getStringReprentationOfTimeOfADate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    NSString *toReturn = [dateFormatter stringFromDate:date];
    toReturn = [toReturn stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSError *errorsOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForTime options:0 error:&errorsOnRegex];
    
    NSTextCheckingResult *match = [regex firstMatchInString:toReturn options:0 range:NSMakeRange(0, toReturn.length)];
    
    NSString *hours = [toReturn substringWithRange:[match rangeAtIndex:1]];
    NSString *minutes = [toReturn substringWithRange:[match rangeAtIndex:2]];
    NSString *pieceOfDay = [toReturn substringWithRange:[match rangeAtIndex:3]];
    
    if ([minutes isEqualToString:@"00"]) {
        toReturn = [NSString stringWithFormat:@"%@%@", hours, pieceOfDay];
    }
    
    return toReturn;
}

- (void)defineRangeOfTimeToDatePicker:(UIDatePicker *)datePicker WithMinimumTime:(NSString *)minimumTime AndMaximumTime:(NSString *)maximumTime AndMinuteInterval:(NSInteger)minuteInterval {
    NSDate *now = [NSDate date];
    
    datePicker.minuteInterval = minuteInterval;
    
    datePicker.minimumDate = [self getDateFromFormat:@"dd/MM/yyyy" BasedOnDate:now WithTime:minimumTime AndTimeFormat:@"HH:mm"];
    datePicker.maximumDate = [self getDateFromFormat:@"dd/MM/yyyy" BasedOnDate:now WithTime:maximumTime AndTimeFormat:@"HH:mm"];
}

- (void)changeToStartTime {
    [self changeCurrentDatePickerEnrivomnentWithLabel:@"Starting at..." AndTimeInterval:10 WhereMinimumTime:@"00:00" AndMaximumTime:@"23:00" ForCurrentTime:self.settings.startTime];
}

- (void)changeToEndTime {
    [self changeCurrentDatePickerEnrivomnentWithLabel:@"Ending at..." AndTimeInterval:10 WhereMinimumTime:@"00:00" AndMaximumTime:@"23:00" ForCurrentTime:self.settings.endTime];
}

- (void)changeToChanceOfRaining {
    [self changeCurrentSliderEnviromnentWithLabel:@"Chance of raining..." AndValue:self.settings.chanceOfRaining WithStepper:10 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToMinimumTemperature {
    [self changeCurrentSliderEnviromnentWithLabel:@"With minimum temperature..." AndValue:self.settings.minimumTemperature WithStepper:1 ToMinimumValue:@0 AndMaximumValue:@40];
}

- (void)changeToMaximumTemperature {
    [self changeCurrentSliderEnviromnentWithLabel:@"With maximum temperature..." AndValue:self.settings.maximumTemperature WithStepper:1 ToMinimumValue:@0 AndMaximumValue:@40];
}

- (void)changeToMinimumHumidity {
    [self changeCurrentSliderEnviromnentWithLabel:@"With minimum humidity..." AndValue:self.settings.minimumHumidity WithStepper:5 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToMaximumHumidity {
    [self changeCurrentSliderEnviromnentWithLabel:@"With maximum humidity..." AndValue:self.settings.maximumHumidity WithStepper:5 ToMinimumValue:@0 AndMaximumValue:@100];
}

- (void)changeToRecurrenceAlarm {
    self.currentSlider.hidden = YES;
    self.currentValueOnSliderLabel.hidden = YES;
    self.currentDatePicker.hidden = YES;
    
    self.currentLabelForSettingsView.text = @"With a recurrence on alarm of...";
    
    self.currentPickerView.hidden = NO;
}

- (void)changeAlarmTime {
    [self changeCurrentDatePickerEnrivomnentWithLabel:@"With an alarm time on..." AndTimeInterval:10 WhereMinimumTime:@"00:00" AndMaximumTime:@"23:00" ForCurrentTime:self.settings.notificationSettings.time];
}

#pragma mark - Settings View Save Selectors

- (void)updateSettingsForUITextView:(UITextView *)textView WithNumericValue:(NSNumber *)value {
    NSError *errorOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForNumericPiece options:0 error:&errorOnRegex];
    
    NSTextCheckingResult *match = [regex firstMatchInString:self.currentLinkTapped options:0 range:NSMakeRange(0, [self.currentLinkTapped length])];
    
    NSString *complementPiece = [self.currentLinkTapped substringWithRange:[match rangeAtIndex:1]];
    NSString *newString = [NSString stringWithFormat:@"%lu%@", [value integerValue], complementPiece];
    
    [self updateSettingsForUITextView:textView WithStringValue:newString];
}

- (void)updateSettingsForUITextView:(UITextView *)textView WithStringValue:(NSString *)value {
    textView.text = [textView.text stringByReplacingCharactersInRange:self.currentRange withString:value];
    
    [self processPlaceholdersOnTextView:textView];
}

- (void)saveStartTime {
    self.settings.startTime = [self getStringReprentationOfTimeOfADate:self.currentDatePicker.date];
    [self updateSettingsForUITextView:self.mainDataTextView WithStringValue:self.settings.startTime];
}

- (void)saveEndTime {
    self.settings.endTime = [self getStringReprentationOfTimeOfADate:self.currentDatePicker.date];
    [self updateSettingsForUITextView:self.mainDataTextView WithStringValue:self.settings.endTime];
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
    self.settings.notificationSettings.notificationRecurrence = [BTWUserNotify enumRepresentationFromIndex:self.indexOfSelectedRecurrenceAlarm];
    [self updateSettingsForUITextView:self.repeatIntervalTextView WithStringValue:[BTWUserNotify stringRepresentation:self.settings.notificationSettings.notificationRecurrence]];
}

- (void)saveAlarmTime {
    self.settings.notificationSettings.time = [self getStringReprentationOfTimeOfADate:self.currentDatePicker.date];
    [self updateSettingsForUITextView:self.repeatIntervalTextView WithStringValue:self.settings.notificationSettings.time];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [TSMessage showNotificationWithTitle:kTitleAlertMessage subtitle:@"Error on location services." type:TSMessageNotificationTypeError];
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
    
    if ([self.currentLinkTapped isEqualToString:self.settings.startTime]) {
        toReturn = BTWLabelLinkClickedStartTime;
    } else if ([self.currentLinkTapped isEqualToString:self.settings.endTime]) {
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
                [self performSelector:@selector(changeToStartTime)];
                break;
                
            case BTWLabelLinkClickedEndTime:
                [self performSelector:@selector(changeToEndTime)];
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
                [self performSelector:@selector(changeToRecurrenceAlarm)];
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                [self performSelector:@selector(changeAlarmTime)];
                break;
        }
    } else {
        switch (referenceLink) {
            case BTWLabelLinkClickedStartTime:
                [self performSelector:@selector(saveStartTime)];
                break;
                
            case BTWLabelLinkClickedEndTime:
                [self performSelector:@selector(saveEndTime)];
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
                [self performSelector:@selector(saveToRecurrenceAlarm)];
                break;
                
            case BTWLabelLinkClickedTimeToAlarm:
                [self performSelector:@selector(saveAlarmTime)];
                break;
        }
    }
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[BTWUserNotify allStringRepresentation] count];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [BTWUserNotify allStringRepresentation][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.indexOfSelectedRecurrenceAlarm = row;
}

#pragma mark - Navigation logic

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [self.settings isReadyToProcess];
}

@end