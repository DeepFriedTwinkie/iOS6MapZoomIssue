//
//  Location.h
//  MapTestiOS6
//
//  Created by Scott Atkinson on 6/14/13.
//  Copyright (c) 2013 Scott Atkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation> {
}

+ (instancetype) locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
