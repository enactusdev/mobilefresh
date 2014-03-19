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
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MobileFreshUtil.h"
#import "CustomAnnotation.h"
#import "UpdateStatusInt.h"
@interface NodesMapViewController ()
@property (nonatomic, strong) AppDelegate *appDel;
@end

@implementation NodesMapViewController
@synthesize nodesArray;


@synthesize nodesMapView = _nodesMapView;

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
    titleArray = [[NSMutableArray alloc] init];
    [self addMapView];
    [self getCurrentLocation];
    
    [self addAnnotationsWithLatitudeLongitude];
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


-(void)addMapView
{
    // Create and add MapVIew
    self.nodesMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    self.nodesMapView.mapType = MKMapTypeStandard;
    self.nodesMapView.delegate = self;
    self.nodesMapView.showsUserLocation = YES;
    [self.view addSubview:self.nodesMapView];
    
}
-(void)getShortestPath
{
    
}


-(void)getCurrentLocation
{
    self.appDel =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    CLLocation *curPos = self.appDel.locationManager.location;
    
    NSString *latitude = [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue];
    
    NSString *longitude = [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
    
    NSLog(@"Lat: %@", latitude);
    NSLog(@"Long: %@", longitude);
}


- (IBAction)zoomToCurrentLocation:(UIBarButtonItem *)sender {
    MKCoordinateRegion region  = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.nodesMapView.userLocation.coordinate.latitude, self.nodesMapView.userLocation.coordinate.longitude), MKCoordinateSpanMake(0.00725, 0.00725));
    [self.nodesMapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    NSInteger count = 0;
////    
////	self.normalAnnotation = [[MapAnnotation alloc] initWithLatitude:userLocation.coordinate.latitude andLongitude:userLocation.coordinate.longitude];
////	self.normalAnnotation.title = @"Current Location";
////	[self.nodesMapView addAnnotation:self.normalAnnotation];
//    for (Node *node in nodesArray) {
//        if(node.isNodeSelected){
//            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
//            annotationPoint.coordinate = CLLocationCoordinate2DMake(node.latitude, node.longitude);
//            [self.nodesMapView addAnnotation:annotationPoint];
//            
////            MapAnnotation *customAnnotationObj = [[MapAnnotation alloc] initWithLatitude:node.latitude andLongitude:node.longitude];
////            [self.nodesMapView addAnnotation:customAnnotationObj];
//            count ++;
//        }
//    }
//    
//	
//    
//    // Set Mak Visible Region
//    [self setMapViewRegion:userLocation];
//    
//    
//    [self showLines:count+1 userLocation:userLocation];
}


//adding annotations
-(void)addAnnotationsWithLatitudeLongitude
{
    NSInteger count = 0;

    Node *node =[[Node alloc]init];
    for (int i=0; i<[nodesArray count]; i++)
    {
        node=[nodesArray objectAtIndex:i];
        location.latitude = node.latitude;
        location.longitude = node.longitude;
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        //setting location to annotation
        [annotation setCoordinate:(location)];
        [annotation setTitle:node.title];
        //setting address
        [annotation setSubtitle:@"Does Food Collected"];
        
        if(node.isNodeSelected){
        //adding annotations
            [self.nodesMapView addAnnotation:annotation];
            [titleArray addObject:node.title];
            count ++;
        }
    }
    // Set Mak Visible Region
    [self setMapViewRegion:(MKUserLocation *)self.appDel.locationManager.location];
    
    
    [self showLines:count+1 userLocation:(MKUserLocation *)self.appDel.locationManager.location];
}
//setting callout view
- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id < MKAnnotation >)annotationPoint
{
    static NSString *reuseId = @"StandardPin";
    
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[sender
                                                         dequeueReusableAnnotationViewWithIdentifier:reuseId];
    NSLog(@"aView--%@",aView);
    if (aView == nil && ![annotationPoint isKindOfClass:[MKUserLocation class]])
    {
        aView =[[CustomAnnotation alloc]initWithAnnotation:annotationPoint reuseIdentifier:reuseId];
        aView.tag = 5;
        UIButton *button =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.rightCalloutAccessoryView =button;
        aView.canShowCallout = YES;
    }
    else if([annotationPoint isKindOfClass:[MKUserLocation class]])
    {
        aView =[[MKPinAnnotationView alloc]initWithAnnotation:annotationPoint reuseIdentifier:reuseId];
        aView.pinColor = MKPinAnnotationColorGreen;
        aView.canShowCallout = YES;
    }
    aView.annotation = annotationPoint;
    //setting left image
    for (int i=0; i<[nodesArray count]; i++)
    {
        Node *node =[nodesArray objectAtIndex:i];
        if ((aView.annotation.coordinate.latitude==node.latitude) &&(aView.annotation.coordinate.longitude==node.longitude))
        {
           if(node.isNodeSelected){
               UILabel *titleLabel = [MobileFreshUtil labelWithFrame:CGRectZero title:node.idStr];
               titleLabel.backgroundColor =[UIColor clearColor];
               if(![annotationPoint isKindOfClass:[MKUserLocation class]])
//                   aView.leftCalloutAccessoryView=imageView;
                   [aView addSubview:titleLabel];
            }
        }
        
    }
    
    return aView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
}


// accesory button clicked
- (void)mapView:(MKMapView *)mapViewDisplay annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        annotationView=[[CustomAnnotation alloc]init];
        annotationView=(CustomAnnotation *)view;
        //creating actions sheet
        NSLog(@"Control--%d,%d",control.tag,annotationView.tag);
        NSString *nodeID = @"";
        for (id view in annotationView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                NSLog(@"title--%@",label.text);
                nodeID = label.text;
                break;
            }
        }
        
//        NSLog(@"annotationView.title--%@",annotationView.title);
        [self foodPickOption:nodeID];
    }
    
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
    
    [self.nodesMapView addOverlay:polyline];
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
    
    [self.nodesMapView setRegion:region animated:YES];
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
-(void)foodPickOption:(NSString *)nodeStr
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Mobile Fresh" message:@"Food Collected ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",@"NO", nil];
    foodTypeStr= nodeStr;
    [alertView show];
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   // self.searchButton.hidden = NO;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"string---%d",buttonIndex);
    if (buttonIndex > 0) {
        // yes
        [self updateStatus:buttonIndex];
    }
}


-(void)updateStatus:(NSInteger)forIndex
{
    NSString *statusStr = @"";
    if (forIndex == 1) {
        statusStr = @"received";
    }
    else
        statusStr = @"not received";
    UpdateStatusInt *updateInt = [[UpdateStatusInt alloc] initWithDelegate:self callback:@selector(updateStatusResponse)];
    [updateInt updateStatusWithUrl:foodTypeStr status:statusStr];
}

-(void)updateStatusResponse
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
