//
//  MMSPAWrapper.m
//  Murmuration
//
//  Created by Kosuke Hata on 2/5/13.
//  Copyright (c) 2013 Circle Time. All rights reserved.
//

#import "MMSPAWrapper.h"
#import <math.h>
#include <stdio.h>
#import "spa.h"
#import "MMSetRiseTime.h"

#define kRads2Deg (180 / M_PI) 

@implementation MMSPAWrapper {
    
    CLLocation *currentLocation;
    NSDateComponents* components;
    
    float n1;
    float n2;
    float n3;
    float daysInYear;
    
    MMSetRiseTime *times;
}

- (id)init {
    
    self = [super init];
    if (self) {
        //
        times = [[MMSetRiseTime alloc] init];
        
    }
    return self;
}

- (MMSetRiseTime *)calculateWithLocation:(CLLocation *)location {

    currentLocation = location;
    
    // 0. Setup Calculations
    NSDate *curentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    // break it down into components
    components = [calendar components:NSYearCalendarUnit|
                  NSMonthCalendarUnit|NSDayCalendarUnit fromDate:curentDate];
        
    // Get necessary date components
    int month       = [components month];
    int year        = [components year];
    int day         = [components day];
    
    // date and location
    NSLog(@"\n\nToday's Date: \t\t\t%d/%d/%d\n\n long:\t%f\nlat:\t%f",
          month,
          day,year,
          currentLocation.coordinate.longitude,
          currentLocation.coordinate.latitude);
    
    
    // Start SPA
    spa_data spa;  //declare the SPA structure
    
    int result;
    float min, sec;
    float offsetTZ =([[NSTimeZone systemTimeZone] secondsFromGMT]/3600.0);
    
    //enter required input values into SPA structure
    
    spa.year          = year;
    spa.month         = month;
    spa.day           = day;
    spa.hour          = 12;
    spa.minute        = 30;
    spa.second        = 30;
    spa.timezone      = offsetTZ;
    spa.delta_t       = 67;
    spa.longitude     = currentLocation.coordinate.longitude;
    spa.latitude      = currentLocation.coordinate.latitude;
    spa.elevation     = 0;
    spa.pressure      = 820;
    spa.temperature   = 13;
    spa.slope         = 0;
    spa.azm_rotation  = 0;
    spa.atmos_refract = 0.5667;
    spa.function      = SPA_ALL;
    
    //call the SPA calculate function and pass the SPA structure
    
    result = spa_calculate(&spa);
    
    if (result == 0)  //check for SPA errors
    {
        //display the results inside the SPA structure
        
        printf("Julian Day:    %.6f\n",spa.jd);
        printf("L:             %.6e degrees\n",spa.l);
        printf("B:             %.6e degrees\n",spa.b);
        printf("R:             %.6f AU\n",spa.r);
        printf("H:             %.6f degrees\n",spa.h);
        printf("Delta Psi:     %.6e degrees\n",spa.del_psi);
        printf("Delta Epsilon: %.6e degrees\n",spa.del_epsilon);
        printf("Epsilon:       %.6f degrees\n",spa.epsilon);
        printf("Zenith:        %.6f degrees\n",spa.zenith);
        printf("Azimuth:       %.6f degrees\n",spa.azimuth);
        printf("Incidence:     %.6f degrees\n",spa.incidence);
        
        min = 60.0*(spa.sunrise - (int)(spa.sunrise));
        sec = 60.0*(min - (int)min);
        printf("Sunrise:       %02d:%02d:%02d Local Time\n", (int)(spa.sunrise), (int)min, (int)sec);
        
        int r_hour  = spa.sunrise;
        int r_minutes = min;
        
        min = 60.0*(spa.sunset - (int)(spa.sunset));
        sec = 60.0*(min - (int)min);
        printf("Sunset:        %02d:%02d:%02d Local Time\n", (int)(spa.sunset), (int)min, (int)sec);
        
        int s_hour  = spa.sunset;
        int s_minutes = min;
        
        // putting it into times object

        times.del_psi       = spa.del_psi;
        times.del_epsilon   = spa.del_epsilon;
        times.zenith        = spa.zenith;
        times.azimuth       = spa.azimuth;
        times.incidence     = spa.incidence;
        
        times.sunriseHour   = r_hour;
        times.sunriseMins   = r_minutes;
        times.sunsetHour    = s_hour;
        times.sunsetMins    = s_minutes;
        
    } else  {
        printf("SPA Error Code: %d\n", result);
    }

    // check DST
    
    if ([self isDaylightSavingsTime]) {
        NSLog(@"It is DST");
        times.sunsetHour += 1;
        times.sunriseHour += 1;
    } else {
        NSLog(@"It is not DST");
    }
    
    return times;
}


- (BOOL)isDaylightSavingsTime {
    
    // Get necessary date components
    int month       = [components month];
    int day         = [components day];
    
    NSDate *today = [NSDate date];
    int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
                                                   fromDate:today] weekday];
    int previousSunday = day - weekday;
    
    
    if (month < 3 || month > 11) {
        return NO;
    }
    
    if (month == 3) {
        return previousSunday >= 8;
    }

    return YES;
}

@end

