//
//  ViewController.m
//  BikeToWork
//
//  Created by Rafael Ferreira on 1/19/16.
//  Copyright © 2016 Data Empire. All rights reserved.
//

#import "BTWHomeViewController.h"
#import "BTWResultViewController.h"
#import "UITapGestureRecognizer+UILabel.h"

static NSString *const kRegexForTemperatureDegrees = @"(\\d+)º([A-Z])";

static NSString *const kRegexForFindStringAttributes = @"((\\d+)(%|º[C|F])|Every .* day|\\d+:\\d+[A|P]M)";

@interface BTWHomeViewController ()

@property (nonatomic, strong) BTWUserSettings *settings;

@property (nonatomic, strong) NSMutableDictionary *rangesToConsider;

@end

@implementation BTWHomeViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        self.settings = [BTWUserSettings new];
        self.rangesToConsider = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustSwipeGestureForBack];
    [self adjustAllComponents];
}

- (void)adjustSwipeGestureForBack {
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
}

- (void)adjustAllComponents {
    // currentLocationButton
    [self.currentLocationButton setTitle:[self getCityNameBasedOnLocation] forState:UIControlStateNormal];
    
    // mainDataField
    [self processPlaceholdersOnLabel:self.mainDataField];
    [self addTapUIGestureToLabel:self.mainDataField];
    
    // repeatIntervalField
    [self processPlaceholdersOnLabel:self.repeatIntervalField];
    [self addTapUIGestureToLabel:self.repeatIntervalField];
}

- (void)addTapUIGestureToLabel:(UILabel *)label {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    
    [label addGestureRecognizer:tapGesture];
}

- (void)tapHandler:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"Loguei agora carai");
    
    [self.rangesToConsider enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSValue *valueOnKey = (NSValue *)key;
        NSRange range = valueOnKey.rangeValue;
        
        BOOL clickedOnLink = [tapGesture didTapAttributedTextInLabel:obj inRange:range];
        
        NSLog(@"%i", clickedOnLink);
    }];
}

- (void)processPlaceholdersOnLabel:(UILabel *)label {
    NSError *errorsOnRegex;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexForFindStringAttributes options:0 error:&errorsOnRegex];
    
    NSArray *matches = [regex matchesInString:label.text options:0 range:NSMakeRange(0, label.text.length)];
    
    NSDictionary *currentTextFormat = @{
                                        NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: label.font,
                                        NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]
                                        };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:currentTextFormat];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = match.range;
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:LinkedTextUIColor range:range];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
        
        [self.rangesToConsider setObject:label forKey:[NSValue valueWithRange:range]];
    }
    
    label.attributedText = attributedString;
}

- (IBAction)choiceCity:(UIButton *)sender {
    NSString *city = [self getCityNameBasedOnLocation];
    
    if (!city) {
        NSLog(@"Working with a list of all cities.");
    }
}

- (NSString *)getCityNameBasedOnLocation {
    
    
    return @"Sao Paulo";
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
    
    __block NSString *string = self.mainDataField.text;
    
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
    
    self.mainDataField.text = string;
    [self processPlaceholdersOnLabel:self.mainDataField];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BTWResultViewController *controller = (BTWResultViewController *)segue.destinationViewController;
    
    controller.settings = self.settings;
}

@end