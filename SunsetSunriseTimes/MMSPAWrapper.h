//
//  MMSPAWrapper.h
//  Murmuration
//
//  Created by Kosuke Hata on 2/5/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class MMSetRiseTime;

@interface MMSPAWrapper : NSObject

- (MMSetRiseTime *)calculateWithLocation:(CLLocation *)location;

@end
