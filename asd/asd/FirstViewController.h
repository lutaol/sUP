//
//  FirstViewController.h
//  asd
//
//  Created by Tao on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mapKit/mapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface AddressAnnotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
}

@end

@interface FirstViewController : UIViewController<UISearchBarDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UISearchBar *addressField;
    IBOutlet MKMapView *mapview;
    IBOutlet UISegmentedControl *segmentControl;
    CLLocationManager *locationManager;
    AddressAnnotation *addAnnotation;
    
    //for database
    sqlite3 *database;
    NSString *DBName;
    NSString *path;
    
    UIPickerView *myPicker;
    NSMutableArray *locationList;
    UIToolbar *controlTollbar;
    NSString *selected;
}


- (IBAction)segmentClicked:(id)sender;


-(CLLocationCoordinate2D) addressLocation;
@end
