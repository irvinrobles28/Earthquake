//
//  DetailEarthquakeViewController.m
//  Earthquake Monitor
//
//  Created by Irvin Robles on 02/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import "DetailEarthquakeViewController.h"
#import "EarthquakeSplitViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DetailEarthquakeViewController ()<EarthquakeDelegate>
{
    GMSMarker *marker;
}

@end

@implementation DetailEarthquakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    marker = [[GMSMarker alloc] init];
    // Do any additional setup after loading the view.
}

//Function that is called by the delegate to change de values of the view
- (void)EarthquakeSelected:(NSDictionary*)Earthquake
{
    //setting the label text with the location value
    self.lblLocation.text=[NSString stringWithFormat:@"Place: %@",[[Earthquake objectForKey:@"properties"] objectForKey:@"place"]];
    //setting the label text with the magnitude value
    double magnitude=[[[Earthquake objectForKey:@"properties"] objectForKey:@"mag"] doubleValue];
    self.lblMagnitude.text=[NSString stringWithFormat:@"Magnitude: %.1f",magnitude];
    
    //setting the label text with the date value
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([[[Earthquake objectForKey:@"properties"] objectForKey:@"time"] doubleValue] / 1000)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    self.lblDate.text=[NSString stringWithFormat:@"Date: %@",[dateFormatter stringFromDate:date] ];
    
    //getting the coordinate of the earthquake
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake([[[Earthquake objectForKey:@"geometry"] objectForKey:@"coordinates"][1] doubleValue], [[[Earthquake objectForKey:@"geometry"] objectForKey:@"coordinates"][0] doubleValue]);
    //setting up the marker of the map view with the earthquake info
    marker.position = location;
    marker.title=[NSString stringWithFormat:@"%@",[[Earthquake objectForKey:@"properties"] objectForKey:@"place"]];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:location zoom:5];
    self.mapView.camera=camera;
    //validating the magnitude of the earthquake to select the correct marker icon
    if(magnitude<1)
    {
        marker.icon=[UIImage imageNamed:@"pinGreen.png"];
    }
    else
    {
        if(magnitude>9)
        {
            marker.icon=[UIImage imageNamed:@"redPin.png"];
        }
        else
        {
            marker.icon=[UIImage imageNamed:@"pinYellow.png"];
        }
    }
    marker.map=self.mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
