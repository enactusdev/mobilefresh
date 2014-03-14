//
//  NodesMapViewController.h
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
@interface NodesMapViewController : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *nodesMapView;

@end
