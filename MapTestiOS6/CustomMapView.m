//
//  ExploreMapView.m
//  MapTestiOS6
//
//  Created by Scott Atkinson on 7/19/13.
//  Copyright (c) 2013 Scott Atkinson. All rights reserved.
//

#import "CustomMapView.h"

@implementation CustomMapView



// ******************** Overridden Methods ********************
#pragma mark - Overridden Methods

- (void) setRegion:(MKCoordinateRegion)region animated:(BOOL)animated {
    @try {
        // Get the zoom level for the proposed region
        double zoomLevel = [self getFineZoomLevelForRegion:region];

        // Check to see if any corrections are needed:
        //     - Zoom level is too big (a very small region)
        //     - We are looking at satellite imagery (Where the issue occurs)
        //     - We have turned on the zoom level protection
        
        if (zoomLevel >= (MAX_GOOGLE_LEVELS-1) && self.mapType != MKMapTypeStandard && self.protectZoomLevel) {
            NSLog(@"setRegion: Entered Protected Zoom Level");
            
            // Force the zoom level to be 19 (20 causes the issue)
            MKCoordinateRegion protectedRegion = [self coordinateRegionForZoomLevel:MAX_GOOGLE_LEVELS-1.0 atCoordinate:region.center];
            [super setRegion:protectedRegion animated:animated];
        } else {
            [super setRegion:region animated:animated];
        }
    }
    @catch (NSException *exception) {
        [self setCenterCoordinate:region.center];
    }
}


// ******************** Public methods ********************
#pragma mark - Public Methods

- (double) getZoomLevel {
    MKMapRect mapRect = self.visibleMapRect;
    
    MKZoomScale zoomScale = mapRect.size.width / self.bounds.size.width;
    double zoomExponent = log2(zoomScale);
    double zoomLevel = (double)MAX_GOOGLE_LEVELS - zoomExponent;
    return zoomLevel;
}

- (void) setZoomLevel:(NSInteger)zoomLevel animated:(BOOL)animated {
    double fineZoomLevel = (double) zoomLevel;
    if (zoomLevel >= MAX_GOOGLE_LEVELS && self.mapType != MKMapTypeStandard && self.protectZoomLevel) {
        NSLog(@"setZoomLevel: Entered Protected Zoom Level");
        fineZoomLevel = (float) MAX_GOOGLE_LEVELS - 1.0;
    }
    
    double aspectRatio = self.visibleMapRect.size.width / self.visibleMapRect.size.height;
    MKMapPoint center = MKMapPointForCoordinate(self.region.center);
    
    double newWidth = exp2(MAX_GOOGLE_LEVELS - fineZoomLevel) * self.bounds.size.width;
    double newHeight = newWidth / aspectRatio;
    
    MKMapRect newRect = MKMapRectMake(center.x-(newWidth/2.0), center.y-(newHeight/2.0), newWidth, newHeight);
    [self setVisibleMapRect:newRect animated:animated];
}

- (MKCoordinateRegion) coordinateRegionForZoomLevel:(NSInteger)zoomLevel atCoordinate:(CLLocationCoordinate2D)coordinate {
    double fineZoomLevel = (double) zoomLevel;
    if (zoomLevel >= MAX_GOOGLE_LEVELS && self.mapType != MKMapTypeStandard && self.protectZoomLevel) {
        NSLog(@"coordinateRegionForZoomLevel: Entered Protected Zoom Level");
        fineZoomLevel = (float) MAX_GOOGLE_LEVELS - 1.0;
    }
    
    double aspectRatio = self.visibleMapRect.size.width / self.visibleMapRect.size.height;
    MKMapPoint center = MKMapPointForCoordinate(coordinate);
    
    double newWidth = exp2(MAX_GOOGLE_LEVELS - fineZoomLevel) * self.bounds.size.width;
    double newHeight = newWidth / aspectRatio;
    
    MKMapRect newRect = MKMapRectMake(center.x-(newWidth/2.0), center.y-(newHeight/2.0), newWidth, newHeight);
    return MKCoordinateRegionForMapRect(newRect);    
}


// ******************** Helpers ********************
#pragma mark - Helpers

- (double) getFineZoomLevelForRegion:(MKCoordinateRegion)region {
    double centerPixelX = [CustomMapView longitudeToPixelSpaceX: region.center.longitude];
    double topLeftPixelX = [CustomMapView longitudeToPixelSpaceX: region.center.longitude - region.span.longitudeDelta / 2];
    
    double scaledMapWidth = (centerPixelX - topLeftPixelX) * 2;
    CGSize mapSizeInPixels = self.bounds.size;
    double zoomScale = scaledMapWidth / mapSizeInPixels.width;
    double zoomExponent = log2(zoomScale);
    double zoomLevel = (double)MAX_GOOGLE_LEVELS - zoomExponent;
    
    NSLog(@"Fine Zoom Level: %f", zoomLevel);
    return zoomLevel;
}

// ******************** Conversion Helpers ********************
#pragma mark - Conversion Helpers

// http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
+ (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}



@end
