//
//  MMSharedLocationManager.h
//  Murmuration
//
//  Created by Kosuke Hata on 2/5/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MMSharedLocationManagerDelegate <NSObject>

- (void)locationDidUpdate:(CLLocation *)newLocation;

@end

@interface MMSharedLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) id<MMSharedLocationManagerDelegate> delegate;


+ (MMSharedLocationManager *)sharedInstance;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
- (CLLocation *)getMostRecentLocation;

@end
