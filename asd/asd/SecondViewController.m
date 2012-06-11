//
//  SecondViewController.m
//  asd
//
//  Created by Tao on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)viewDidLoad
{
    /*
    FirstViewController *firstClass = [[FirstViewController alloc] init];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move 
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[firstClass addressLocation].latitude longitude:[firstClass addressLocation].longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
     */
    NSString *urlstring=[NSString stringWithFormat:@"http://maps.google.com"];
    
    [googleMap loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]]];
    
   
    
    
    [super viewDidLoad];
    
    
    
    //NSLog(@"test1111111111111111111 %@",[routes objectAtIndex:0]);
    
    

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
