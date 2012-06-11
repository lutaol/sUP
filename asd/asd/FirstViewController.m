//
//  FirstViewController.m
//  asd
//
//  Created by Tao on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

// 
@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
    return @"Sub Title";
}

- (NSString *)title{
    return @"Title";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate=c;
    NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}
@end


//
@interface FirstViewController ()

@end

@implementation FirstViewController
- (void)viewDidLoad
{
    addressField.delegate =self;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"myLocation.sqlite3"];
    DBName = [[NSBundle mainBundle] pathForResource:@"myLocation" ofType:@"sqlite3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == NO) {
        NSData *data = [NSData dataWithContentsOfFile:DBName];
        [data writeToFile:path atomically:YES];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    segmentControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//GET
- (IBAction)segmentClicked:(id)sender {
    // current address and update when you move
    if (segmentControl.selectedSegmentIndex == 0) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //kCLLocationAccuracyHundredMeters;  //100 m
        [locationManager startUpdatingLocation];
        /*
        if(addAnnotation != nil) {
            [mapview removeAnnotation:addAnnotation];
            //[addAnnotation release];
            addAnnotation = nil;
        }
        [mapview setMapType:MKMapTypeStandard];
        [mapview setZoomEnabled:YES];
        [mapview setScrollEnabled:YES];
         */
        mapview.showsUserLocation = YES;
        
        MKCoordinateRegion region = { {0.0,0.0},{0.0,0.0} };
        region.center.latitude = locationManager.location.coordinate.latitude;
        region.center.longitude = locationManager.location.coordinate.longitude;
        region.span.longitudeDelta = 0.007f;
        region.span.latitudeDelta = 0.007f;
        [mapview setRegion:region animated:YES];
         
        
    }
    //history location
    if(segmentControl.selectedSegmentIndex == 1)
    {
        myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,85, 320, 200)];
        locationList = [[NSMutableArray alloc] init];
        //DBName = [[NSBundle mainBundle] pathForResource:@"myLocation" ofType:@"sqlite3"];
        
        if (sqlite3_open([path UTF8String],&database) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(0,@"open database faild!");
            NSLog(@"failed");
            
        }
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM locations;"];
        sqlite3_stmt *statement;
        
        int aid = -1;
        NSString *said = @"";
        NSString *locationName = @"";
        
        
        
        // to be implemented with sqlite!
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            while (sqlite3_step(statement)==SQLITE_ROW) {
                aid = sqlite3_column_int(statement,0);
                said = [NSString stringWithFormat:@"%d",aid];
                locationName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,1)];
                
                NSLog(@"%d",aid);
                [locationList addObject:locationName];
                
                //newURL = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,1)];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database); 
        
        controlTollbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 45, 320, 200)];
        [controlTollbar setBarStyle:UIBarStyleBlack];
        [controlTollbar sizeToFit];
        
        UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(setData)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelData)];
        [controlTollbar setItems:[NSArray arrayWithObjects:spacer,cancelButton,setButton,nil] animated:NO];
        
        myPicker.delegate =self;
        myPicker.dataSource = self;
        myPicker.showsSelectionIndicator = YES;
        [self.view addSubview:controlTollbar];
        [self.view addSubview:myPicker];
    }
}

// the follong 4 methods are delegates or data sources for pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [locationList count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //[[listItems objectAtIndex:2] doubleValue];
    return [locationList objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selected = [locationList objectAtIndex:row];
}

// For the toolbar method 
-(void) cancelData
{
    
    [myPicker removeFromSuperview];
    [controlTollbar removeFromSuperview];
}
// For the toolbar method 
-(void) setData
{
    addressField.text = selected;
    //close picker and toolbar
    [myPicker removeFromSuperview];
    [controlTollbar removeFromSuperview];
    
    //get the selected attitude and longitude
    double a = -1;
    double b = -1;
    //DBName = [[NSBundle mainBundle] pathForResource:@"myLocation" ofType:@"sqlite3"];
    
    if (sqlite3_open([path UTF8String],&database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"open database faild!");
        NSLog(@"failed");
        
    }
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM locations where location = \'%@\'", selected];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"asd");
		while (sqlite3_step(statement)==SQLITE_ROW) {
            
			a = sqlite3_column_double(statement, 2);
            
			b = sqlite3_column_double(statement, 3);
			
		}
    }
    sqlite3_finalize(statement);
    sqlite3_close(database); 
    
    if(addAnnotation != nil) {
		[mapview removeAnnotation:addAnnotation];
		addAnnotation = nil;
	}
	CLLocationCoordinate2D location;
	location.latitude = a;
	location.longitude = b;

	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapview addAnnotation:addAnnotation];
    
    [mapview setDelegate:self];
    [mapview setMapType:MKMapTypeStandard];
    [mapview setZoomEnabled:YES];
    [mapview setScrollEnabled:YES];
    MKCoordinateRegion region1 = { {0.0,0.0},{0.0,0.0} };
    region1.center = location;
    region1.span.longitudeDelta = 0.007f;
    region1.span.latitudeDelta = 0.007f;
    [mapview setRegion:region1 animated:YES];
    [mapview regionThatFits:region1];
    
    
}




//used by search function ie searchBarCancelButtonClicked method
-(CLLocationCoordinate2D) addressLocation {
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [addressField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    
	NSArray *listItems = [urlString componentsSeparatedByString:@","];
	
	double latitude = 0.0;
	double longitude = 0.0;
	
	if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
		latitude = [[listItems objectAtIndex:2] doubleValue];
		longitude = [[listItems objectAtIndex:3] doubleValue];
	}
	else {
		//Show error
	}
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
    
    
    //copy the database to documents

    //DBName = [[NSBundle mainBundle] pathForResource:@"myLocation" ofType:@"sqlite3"];
   // NSLog(@"%@",DBName);
    

    
    if (sqlite3_open([path UTF8String],&database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"open database faild!");
        
    }
    NSString *query = [NSString stringWithFormat:@"insert into locations values ((select count(*) from locations), \'%@\', %f,%f);", addressField.text ,latitude,longitude];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(database, [query UTF8String] , -1, &statement, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_bind_text(statement, 2, [addressField.text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement, 3, latitude);
    sqlite3_bind_double(statement, 4, longitude);
    sqlite3_step(statement);
    
    //NSData *data1 = [NSData dataWithContentsOfFile:path];
    //[data1 writeToFile:DBName atomically:YES];
    sqlite3_finalize(statement);
    sqlite3_close(database); 
    

	return location;
}




-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,[self addressLocation].latitude,[self addressLocation].longitude ];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];// Perform request and get JSON back as a NSData object
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData data
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"This is my JSON data %@", json);
    
    NSArray *routes = [json objectForKey:@"routes"];
    NSDictionary *firstRoute = [routes objectAtIndex:0];
    NSArray *legs = [firstRoute objectForKey:@"legs"];
    NSDictionary *leg = [legs objectAtIndex:0];
    NSArray *duration = [leg objectForKey:@"duration"];
    
    NSString *text = [duration valueForKey:@"text"];
    NSLog(@"%@",text);
    
    
    NSLog(@"Cancel");
    [addressField resignFirstResponder];
}
// call address location method
// delegate of searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search");
    [addressField resignFirstResponder];
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	CLLocationCoordinate2D location = [self addressLocation];
	region.span=span;
	region.center=location;
	
    if(addAnnotation != nil) {
		[mapview removeAnnotation:addAnnotation];
		addAnnotation = nil;
	}
	
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapview addAnnotation:addAnnotation];

	[mapview setDelegate:self];  // call delegation method.
	[mapview setRegion:region animated:TRUE];
	[mapview regionThatFits:region];
}

//annotation set up
//mapview delegate(actionLisener in Java)
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorGreen;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
	return annView;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
