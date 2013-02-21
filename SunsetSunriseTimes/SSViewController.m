//
//  SSViewController.m
//  SunsetSunriseTimes
//
//  Created by Kosuke Hata on 2/21/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import "SSViewController.h"
#import "MMSPAWrapper.h"
#import "MMSetRiseTime.h"

@interface SSViewController ()

@end

@implementation SSViewController {
    MMSetRiseTime *times;
    UILabel *sunriseLabel;
    UILabel *sunsetLabel;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        //...
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    sunriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    [view addSubview:sunriseLabel];
    sunsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 320, 50)];
    [view addSubview:sunsetLabel];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterSunsetSunriseTimes:(MMSetRiseTime *)setRiseTimes {
    
    times = setRiseTimes;

    float sunriseHour = times.sunriseHour;
    float sunriseMins = times.sunriseMins;
    float sunsetHour = times.sunsetHour;
    float sunsetMins = times.sunsetMins;
    
    sunriseLabel.text = [NSString stringWithFormat:@"sunrise: \t%02fd : %02fd", sunriseHour, sunriseMins];
    sunsetLabel.text = [NSString stringWithFormat:@"sunset: \t%02fd : %02fd", sunsetHour, sunsetMins];
    
    // stop getting location
    [[MMSharedLocationManager sharedInstance] stopUpdatingLocation];
}

- (void)locationDidUpdate:(CLLocation *)newLocation {
    
    NSLog(@"%@",newLocation);
    
    MMSPAWrapper *spa = [[MMSPAWrapper alloc] init];
    times = [spa calculateWithLocation:newLocation];
    [self enterSunsetSunriseTimes:times];
    
}

@end
