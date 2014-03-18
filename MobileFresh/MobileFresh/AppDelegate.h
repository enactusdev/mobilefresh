//
//  AppDelegate.h
//  MobileFresh
//
//  Created by saurabh agrawal on 11/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) CLLocationManager *locationManager;
@end
