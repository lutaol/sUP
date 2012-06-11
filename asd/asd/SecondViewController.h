//
//  SecondViewController.h
//  asd
//
//  Created by Tao on 12-05-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController{
    IBOutlet UIWebView *googleMap;
    CLLocationManager *locationManager;
}


@end
