//
//  EarthquakeSplitViewController.h
//  Earthquake Monitor
//
//  Created by Irvin Robles on 06/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarthquakeDelegate.h"

@interface EarthquakeSplitViewController : UITableViewController
@property (nonatomic, assign) id <EarthquakeDelegate> delegate;
@end

