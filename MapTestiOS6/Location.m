//
//  Location.m
//  MapTestiOS6
//
//  Created by Scott Atkinson on 6/14/13.
//  Copyright (c) 2013 Scott Atkinson. All rights reserved.
//

#import "Location.h"

@interface Location()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end

@implementation Location

+ (instancetype) locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    Location * location = [[Location alloc] init];
    if (location) {
        [location setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [location setTitle:[NSString stringWithFormat:@"Coordinate: (%f,%f)",latitude, longitude]];
    }
    return location;
}


@end
