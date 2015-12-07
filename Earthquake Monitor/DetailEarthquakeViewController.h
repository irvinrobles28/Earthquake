//
//  DetailEarthquakeViewController.h
//  Earthquake Monitor
//
//  Created by Irvin Robles on 02/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "EarthquakeSplitViewController.h"

@interface DetailEarthquakeViewController : UIViewController

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblMagnitude;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
