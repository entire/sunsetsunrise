//
//  MMSPATime.h
//  Murmuration
//
//  Created by Kosuke Hata on 2/5/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSetRiseTime : NSObject

@property (nonatomic) int sunriseHour;
@property (nonatomic) int sunriseMins;
@property (nonatomic) int sunsetHour;
@property (nonatomic) int sunsetMins;
@property (nonatomic) double juliandate;
@property (nonatomic) double del_psi;
@property (nonatomic) double del_epsilon;
@property (nonatomic) double epsilon;
@property (nonatomic) double zenith;
@property (nonatomic) double azimuth;
@property (nonatomic) double incidence;

@end
