//
//  NodesMapViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodesMapViewController.h"

@interface NodesMapViewController ()

@end

@implementation NodesMapViewController
@synthesize nodesMapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nodesMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    self.nodesMapView.mapType = MKMapTypeStandard;
    self.nodesMapView.delegate = self;
    self.nodesMapView.showsUserLocation = YES;
    [self.view addSubview:self.nodesMapView];
    
    //TODO
    //For all the nodes selected by user in the node list, display a pin on map and a route connecting all those.
    //TODO
    //find the shortest path between these nodes using TSP algorithm. and display the path as per that.
    //TODO
    //User can press a pin. On pressing of the pin ask user to confirm whether she/he has picked the food with three choices - YES, NO, Cancel.
    
    //TODO
    //make a webservice call to post food pickup result to server.
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)zoomToCurrentLocation:(UIBarButtonItem *)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.nodesMapView.userLocation.coordinate.latitude;
    region.center.longitude = self.nodesMapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
   
    [self.nodesMapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   // self.searchButton.hidden = NO;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.nodesMapView setCenterCoordinate:userLocation.coordinate animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
