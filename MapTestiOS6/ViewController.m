//
//  ViewController.m
//  MapTest
//
//  Created by Scott Atkinson on 6/14/13.
//  Copyright (c) 2013 Scott Atkinson. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Location.h"
#import "CustomMapView.h"


@interface ViewController () {
    CLLocationCoordinate2D apple, anchorage, ecuador, frndHeights, currentLocation;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapMode;
@property (weak, nonatomic) IBOutlet CustomMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *setSmallRegion;
@property (weak, nonatomic) IBOutlet UIButton *setLargeRegion;
@property (weak, nonatomic) IBOutlet UIButton *largeHyb;
@property (weak, nonatomic) IBOutlet UIButton *smallHyb;
@property (weak, nonatomic) IBOutlet UIStepper *zoomLevelStepper;
@property (weak, nonatomic) IBOutlet UISwitch *protectZoomLevelSwitch;

@property (weak, nonatomic) IBOutlet UILabel *zoomLevel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    apple = CLLocationCoordinate2DMake(37.331741, -122.030333);
    anchorage = CLLocationCoordinate2DMake(61.218056, -149.900278);
    ecuador = CLLocationCoordinate2DMake(0.0, -77.684326);
    frndHeights = CLLocationCoordinate2DMake(38.9606475830078, -77.0842437744141);
    currentLocation = apple;
}

- (void) viewDidAppear:(BOOL)animated {
    [self.protectZoomLevelSwitch setOn:NO];
    self.map.protectZoomLevel = self.protectZoomLevelSwitch.isOn;
    
    [self.map setRegion:MKCoordinateRegionMakeWithDistance(currentLocation, 3000, 3000) animated:YES];
    [self.map addAnnotation:[Location locationWithLatitude:currentLocation.latitude longitude:currentLocation.longitude]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated {
    [self removeObserver:self.map forKeyPath:@"region"];
}

// ******************** Actions ********************
#pragma mark - Actions

- (IBAction)segmentTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.map setMapType:MKMapTypeStandard];
    } else {
        [self.map setMapType:MKMapTypeHybrid];
    }
}

- (IBAction)goToSmallRegion:(id)sender {
    if (sender == self.smallHyb) {
        [self.map setMapType:MKMapTypeHybrid];
        self.mapMode.selectedSegmentIndex = 1;
    } else {
        [self.map setMapType:MKMapTypeStandard];
        self.mapMode.selectedSegmentIndex = 0;
    }
    [self.map setRegion:MKCoordinateRegionMakeWithDistance(currentLocation, 1, 1) animated:YES];
}

- (IBAction)goToLargeRegion:(id)sender {
    if (sender == self.largeHyb) {
        [self.map setMapType:MKMapTypeHybrid];
        self.mapMode.selectedSegmentIndex = 1;
    } else {
        [self.map setMapType:MKMapTypeStandard];
        self.mapMode.selectedSegmentIndex = 0;
    }
    [self.map setRegion:MKCoordinateRegionMakeWithDistance(currentLocation, 3000, 3000) animated:YES];
}

- (IBAction)zoomLevelChanged:(UIStepper *)sender {
    NSInteger zoomLevel = sender.value;
    [self.map setZoomLevel:zoomLevel animated:YES];
    [self updateStatusText];
}

- (IBAction)protectZoomlevelSet:(UISwitch *)sender {
    self.map.protectZoomLevel = sender.isOn;
}

- (void) updateStatusText {
    self.zoomLevel.text = [NSString stringWithFormat:@"Zoom: %f Step: %.0f\nlat:%f lng:%f", [self.map getZoomLevel], self.zoomLevelStepper.value, self.map.region.span.latitudeDelta, self.map.region.span.longitudeDelta];
}

// ******************** MKMapViewDelegate ********************
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if(pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.canShowCallout = NO;
        pinView.animatesDrop = YES;
        pinView.pinColor = MKPinAnnotationColorPurple;        
    }
    
    pinView.annotation = annotation;
    return pinView;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateStatusText];
    self.zoomLevelStepper.value = [self.map getZoomLevel];
}





@end
