//
//  NodesMapViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodesMapViewController.h"
#import "AppDelegate.h"
#import "Node.h"
@interface NodesMapViewController ()

@end

@implementation NodesMapViewController
@synthesize nodesMapView,nodesArray;
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
    [self getCurrentLocation];
    self.nodesMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    self.nodesMapView.mapType = MKMapTypeStandard;
    self.nodesMapView.delegate = self;
    self.nodesMapView.showsUserLocation = YES;
    [self.view addSubview:self.nodesMapView];
    
    //Annotation

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

-(void)getShortestPath
{
    
}
-(void)getCurrentLocation
{
    AppDelegate *appDel =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    CLLocation *curPos = appDel.locationManager.location;
    
    NSString *latitude = [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue];
    
    NSString *longitude = [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
    
    NSLog(@"Lat: %@", latitude);
    NSLog(@"Long: %@", longitude);
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSInteger count = 0;
    for (Node *node in nodesArray) {
        if(node.isNodeSelected){
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.coordinate = CLLocationCoordinate2DMake(node.latitude, node.longitude);
            annotationPoint.title = @"Is Food Collected";
            [nodesMapView addAnnotation:annotationPoint];
            count ++;
        }
    }
    
    // Set Mak Visible Region
    [self setMapViewRegion:userLocation];
    
    
    [self showLines:count+1 userLocation:userLocation];
}


- (void)showLines:(NSInteger)count  userLocation:(MKUserLocation *)userLocation{
//    CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * count);
    MKMapPoint *pointsCoordinate = (MKMapPoint *)malloc(sizeof(MKMapPoint) * count);
    NSInteger i = 1;
    pointsCoordinate[0] = MKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude));
    for (Node *node in nodesArray) {
        if(node.isNodeSelected){
            pointsCoordinate[i] = MKMapPointForCoordinate(CLLocationCoordinate2DMake(node.latitude, node.longitude));
            i ++;
        }
    }
    
    
    MKPolyline *polyline = [MKPolyline polylineWithPoints:pointsCoordinate count:count];
    free(pointsCoordinate);
    
    [nodesMapView addOverlay:polyline];
}
- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    
    // create a polylineView using polyline _overlay object
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor =  [UIColor blackColor];   // applying line-width
    polylineView.lineWidth = 5.0;
    polylineView.lineDashPattern =  @[@8, @10];
    polylineView.alpha = 0.5;
    
    return polylineView;
}

-(void)setMapViewRegion:(MKUserLocation *)userLocation
{
    // MapView Visible Range
    double miles = 10.0;
    double scalingFactor = ABS( (cos(2 * M_PI * userLocation.coordinate.latitude / 360.0) ));
    
    // Create Span region
    MKCoordinateSpan span = MKCoordinateSpanMake((miles/69.0), (miles/(scalingFactor * 69.0)));
    
    // Create Region to be set
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
    
    [nodesMapView setRegion:region animated:YES];
}

#define OO 2000000;

int tsp(int **adjMatrix, int numberPoints)
{
    for (int i = 0; i < numberPoints; i++)
        for (int j = 0; j < numberPoints; j++)
            for (int k = 0; k < numberPoints; k++)
                if (adjMatrix[i][k] + adjMatrix[k][j] < adjMatrix[i][j])
                    adjMatrix[i][j] = adjMatrix[i][k] + adjMatrix[k][j];
    
    int min = OO;
    
    for (int i = 0; i < numberPoints; i++)
        for (int j = 0; j < numberPoints; j++)
            if (adjMatrix[i][j] + adjMatrix[j][i] < min)
                min = adjMatrix[i][j] + adjMatrix[j][i];
    
    return min;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(5.0, 5.0, 25, 25);
        [button setTitle:@"OK" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchUpInside];
        [view.superview addSubview:button];
    }
}
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
//    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
//    
//    // Button
////    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////    button.frame = CGRectMake(0, 0, 23, 23);
////    annotationView.rightCalloutAccessoryView = button;
//    
//    // Image and two labels
//    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
////    [leftCAV addSubview : yourImageView];
////    [leftCAV addSubview : yourFirstLabel];
////    [leftCAV addSubview : yourSecondLabel];
//    annotationView.leftCalloutAccessoryView = leftCAV;
//    
//    annotationView.canShowCallout = YES;
//    
//    return annotationView;
//}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   // self.searchButton.hidden = NO;
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    [self.nodesMapView setCenterCoordinate:userLocation.coordinate animated:YES];
//}


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
