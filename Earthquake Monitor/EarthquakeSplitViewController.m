//
//  EarthquakeSplitViewController.m
//  Earthquake Monitor
//
//  Created by Irvin Robles on 06/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import "EarthquakeSplitViewController.h"
#import "AFNetworking.h"
#import "EarthquakeInfoTVC.h"
#import <QuartzCore/QuartzCore.h>
#import <MXEGOCache.h>
#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
@import GoogleMaps;


@interface EarthquakeSplitViewController ()
{
    NSDictionary *earthquakesData;
    int numberEarthquakes;
}

@end

@implementation EarthquakeSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    earthquakesData=nil;
    numberEarthquakes=0;
    [self GetEarthquakes];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(GetEarthquakes) forControlEvents:UIControlEventValueChanged];
}

//Function tha makes an http request to get the info of the earthquakes
-(void)GetEarthquakes
{
    //Sending the request to get the earthquakes
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //save the json in a dictionary to work with it
         earthquakesData=responseObject;
         numberEarthquakes=(int)[[[earthquakesData objectForKey:@"metadata"] objectForKey:@"count"] integerValue];
         //reload the data of the table view with the dictionary info
         [self reloadData];
         //getting the features property of the json to send it to the detail view
         NSDictionary *param=[earthquakesData objectForKey:@"features"][0];
         //sending the data to the delegate to change the values of the view
         [self.delegate EarthquakeSelected:param];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         earthquakesData=nil;
         numberEarthquakes=0;
     }];
}

//Function that works with the "pull to refres"
- (void)reloadData
{
    //reloadin the data of the table view
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        //set a label with the last time that reload the info
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberEarthquakes;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Creating the cell of the table
    EarthquakeInfoTVC *cell=(EarthquakeInfoTVC*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    
    NSArray *earthquakes=[[NSArray alloc]init];
    earthquakes=[earthquakesData objectForKey:@"features"];
    //getting the place of the earthquake
    cell.lblPlace.text=[NSString stringWithFormat:@"%@",[[earthquakes[indexPath.row] objectForKey:@"properties"] objectForKey:@"place"]];
    //getting the magnitude of the earthquake
    double magnitude=[[[earthquakes[indexPath.row] objectForKey:@"properties"] objectForKey:@"mag"] doubleValue];
    //validate the magnitude to chage the color of the row
    if(magnitude<1)
    {
        cell.backgroundColor=[UIColor colorWithRed:113/255.0 green:215/255.0 blue:64/255.0 alpha:0.5];
    }
    else
    {
        if(magnitude>9)
        {
            cell.backgroundColor=[UIColor colorWithRed:215/255.0 green:23/255.0 blue:26/255.0 alpha:0.5];
        }
        else
        {
            cell.backgroundColor=[UIColor colorWithRed:215/255.0 green:201/255.0 blue:7/255.0 alpha:0.5];
        }
    }
    //set the lablel text with the magnitude
    cell.lblMagnitude.text=[NSString stringWithFormat:@"%.1f",magnitude];
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *param=[earthquakesData objectForKey:@"features"][indexPath.row];
    [self.delegate EarthquakeSelected:param];
    [self.splitViewController showDetailViewController:self.delegate sender:nil];
}

@end
