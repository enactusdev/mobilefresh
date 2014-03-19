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
#import "CustomAnnotation.h"
@interface NodesMapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate>
{
    MKMapView *_nodesMapView;
    CLLocationCoordinate2D location;
    CustomAnnotation *annotationView;
    NSString *foodTypeStr;
    
    NSMutableArray *titleArray;

}
@property (strong, nonatomic) MKMapView *nodesMapView;
@property (nonatomic, strong) MKAnnotationView *selectedAnnotationView;
@property (strong, nonatomic) NSArray *nodesArray;
@end