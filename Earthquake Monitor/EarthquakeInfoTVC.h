//
//  EarthquakeInfoTVC.h
//  Earthquake Monitor
//
//  Created by Irvin Robles on 02/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthquakeInfoTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMagnitude;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;

@end
