//
//  EarthquakeDelegate.h
//  Earthquake Monitor
//
//  Created by Irvin Robles on 06/12/15.
//  Copyright © 2015 Irvin Robles. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EarthquakeDelegate <NSObject>
- (void)EarthquakeSelected:(NSDictionary*)Earthquake;
@end
