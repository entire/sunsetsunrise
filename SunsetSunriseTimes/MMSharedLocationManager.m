//
//  MMSharedLocationManager.m
//  Murmuration
//
//  Created by Kosuke Hata on 2/5/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import "MMSharedLocationManager.h"
#import "MMSPAWrapper.h"

@implementation MMSharedLocationManager {
    
    CLLocationManager *locationManager;
}

@synthesize currentLocation = _currentLocation;
@synthesize delegate = _delegate;

#pragma mark - Singleton Pattern Setup

+ (MMSharedLocationManager *)sharedInstance {
    static MMSharedLocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MMSharedLocationManager alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [self startUpdatingLocation];
    }
    return self;
}

- (void)startUpdatingLocation {
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
}

- (CLLocation *)getMostRecentLocation {
    if (self.currentLocation != nil) {
        return self.currentLocation;
    } else {
        return nil;
    }
}

#pragma mark - MMSharedLocationManager Delegate Method

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    self.currentLocation = newLocation;
    
    if (newLocation != oldLocation) {
        NSLog(@"Not the same location!");
    }
    
    [self getMostRecentLocation];
    [self.delegate locationDidUpdate:self.currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"move to default setting for color");
    
}

@end
