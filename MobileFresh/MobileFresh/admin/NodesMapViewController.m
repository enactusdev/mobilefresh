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

-(void)initArray
{
    distanceArray = [[NSMutableArray alloc] init];
    shortestDistanceArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDel =(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [self getCurrentLocation];
    [self addnodesForMap];
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

-(void)addnodesForMap
{
    
    [self initArray];
    [self getShortestPath];
//    [self getCurrentLocation];
    [self addMapView];
    
    [self addAnnotationsWithLatitudeLongitude];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)addMapView
{
    // Create and add MapVIew
    
    if (self.nodesMapView) {
        [self.nodesMapView removeFromSuperview];
        self.nodesMapView = nil;
    }
    self.nodesMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    self.nodesMapView.mapType = MKMapTypeStandard;
    self.nodesMapView.delegate = self;
    self.nodesMapView.showsUserLocation = YES;
    [self.view addSubview:self.nodesMapView];
    
}
-(void)getShortestPath
{
    [self getCurrentLocation];
    distanceArray = [self getShortestDistanceArrayFromCurrentLocation];
    if (distanceArray.count) {
        sourceNode =[distanceArray objectAtIndex:0];
        NSLog(@"current location distance---%lfkm %@",sourceNode.distance*0.001,sourceNode.title);
        [shortestDistanceArray addObject:sourceNode];
        [nodesArray removeObject:sourceNode];
    }
    
    [self getShortestPathFromNodes];
    
    nodesArray = shortestDistanceArray;
}


-(void)getShortestPathFromNodes
{
    NSMutableArray *distanceNodeArray = [[NSMutableArray alloc] init];
    if (nodesArray.count == 0) {
        return;
    }
    NSLog(@"<--------->");
    for (Node *node in nodesArray) {
        if (node.isNodeSelected) {
            
//            double distance = [MobileFreshUtil calculateDistanceWitLat:sourceNode.latitude fromLongitude:sourceNode.longitude toLat:node.latitude toLong:node.longitude];
            double distance = [MobileFreshUtil distance:sourceNode.latitude fromLongitude:sourceNode.longitude toLat:node.latitude toLong:node.longitude altitude1:0 altitude2:0];
            NSLog(@"distance---%lf km %@",distance*0.001,node.title);
            node.distance = distance;
            [distanceNodeArray addObject:node];
        }
    }
    NSLog(@"<--------->");
    distanceArray = [self sortArray:distanceNodeArray];
    if (distanceArray.count) {
        sourceNode =[distanceArray objectAtIndex:0];
        NSLog(@"source distance---%lf km %@",sourceNode.distance*0.001,sourceNode.title);
        [shortestDistanceArray addObject:sourceNode];
        [nodesArray removeObject:sourceNode];
    }
    [self getShortestPathFromNodes];
}

-(NSMutableArray *)getShortestDistanceArrayFromCurrentLocation
{
//    NSMutableArray *distanceMuttArray = [[NSMutableArray alloc] init];
    NSMutableArray *distanceNodeArray = [[NSMutableArray alloc] init];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (Node *node in nodesArray) {
        if (node.isNodeSelected) {
            
//            double distance = [MobileFreshUtil calculateDistanceWitLat:appDel.locationManager.location.coordinate.latitude fromLongitude:appDel.locationManager.location.coordinate.longitude toLat:node.latitude toLong:node.longitude];
            double distance = [MobileFreshUtil distance:appDel.locationManager.location.coordinate.latitude fromLongitude:appDel.locationManager.location.coordinate.longitude toLat:node.latitude toLong:node.longitude altitude1:0 altitude2:0];
            NSLog(@"distance---%lf km %@",distance*0.001, node.title);
            node.distance = distance;
//            [distanceMuttArray addObject:[NSString stringWithFormat:@"%lf",distance]];
            [distanceNodeArray addObject:node];
        }
    }
    
    return [self sortArray:distanceNodeArray];
}

-(NSMutableArray *)sortArray:(NSMutableArray *)distanceNodeArray
{
    [distanceNodeArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Node *node1 = (Node *)obj1;
        Node *node2 = (Node *)obj2;
        
        NSString *str1 = [NSString stringWithFormat:@"%lf",node1.distance ];
        NSString *str2 = [NSString stringWithFormat:@"%lf",node2.distance ];
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    
    return distanceNodeArray;
}

-(void)getCurrentLocation
{
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
//        [annotation setTitle:node.title];
//        //setting address
//        [annotation setSubtitle:@"Does Food Collected"];
        
        if(node.isNodeSelected){
        //adding annotations
            [self.nodesMapView addAnnotation:annotation];
            count ++;
        }
    }
    // Set Mak Visible Region
    [self setMapViewRegion:(MKUserLocation *)self.appDel.locationManager.location];
    
    
    [self showLines:count+1 userLocation:(MKUserLocation *)self.appDel.locationManager.location];
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //setting left image
    NSInteger forCount =0;
    for (int i=0; i<[nodesArray count]; i++)
    {
        Node *node =[nodesArray objectAtIndex:i];
        if ((view.annotation.coordinate.latitude==node.latitude) &&(view.annotation.coordinate.longitude==node.longitude))
        {
            if(node.isNodeSelected){
                if(![view.annotation isKindOfClass:[MKUserLocation class]])
                    [self foodPickOption:node];
                
                forCount = i;
                break;
            }
        }
        
    }
    if (forCount< nodesArray.count) {
        
        toNode = [nodesArray objectAtIndex:forCount];
    }
    else{
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        toNode = [[Node alloc] init];
        toNode.latitude =appDel.locationManager.location.coordinate.latitude;
        toNode.longitude =appDel.locationManager.location.coordinate.longitude;
        toNode.title = @"Current Location";
        
    }
}
- (void)showLines:(NSInteger)count  userLocation:(MKUserLocation *)userLocation{

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

-(void)foodPickOption:(Node *)node
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Mobile Fresh" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Driving Direction",@"Food Collected",@"Food Not Collected", nil];
    foodTypeStr= node.idStr;
    fromNode = node;
    [alertView show];
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   // self.searchButton.hidden = NO;
}

// Check Null Value
-(id)checkNullValue:(id)val{
    if(val == [NSNull null])
        return @"";
    else
        return val;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"string---%d",buttonIndex);
    if (buttonIndex > 1) {
        // yes
        [self updateStatus:buttonIndex];
    }
    else if(buttonIndex ==1)
    {
        // show direction
        MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(toNode.latitude, toNode.longitude) addressDictionary:[self getAddressDictionary]]];
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                                  };
        [mapItem2 openInMapsWithLaunchOptions:options];
    }
}


-(NSDictionary *)getAddressDictionary
{
    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
    
    if ([self checkNullValue:toNode.addressDict]) {
        if ([[toNode.addressDict allKeys] containsObject:@"Street"]) {
            [address setObject:[self checkNullValue:[toNode.addressDict valueForKey:@"Street"]] forKey:(NSString *)kABPersonAddressStreetKey];
        }
        if ([[toNode.addressDict allKeys] containsObject:@"City"]) {
            [address setObject:[self checkNullValue:[toNode.addressDict valueForKey:@"City"]] forKey:(NSString *)kABPersonAddressCityKey];
        }
        if ([[toNode.addressDict allKeys] containsObject:@"State"]) {
            [address setObject:[self checkNullValue:[toNode.addressDict valueForKey:@"State"]] forKey:(NSString *)kABPersonAddressStateKey];
        }
        if ([[toNode.addressDict allKeys] containsObject:@"Country"]) {
            [address setObject:[self checkNullValue:[toNode.addressDict valueForKey:@"Country"]] forKey:(NSString *)kABPersonAddressCountryKey];
        }
    }
    return address;
}
-(void)updateStatus:(NSInteger)forIndex
{
    NSString *statusStr = @"";
    if (forIndex == 2) {
        statusStr = @"received";
    }
    else
        statusStr = @"not received";
    UpdateStatusInt *updateInt = [[UpdateStatusInt alloc] initWithDelegate:self callback:@selector(updateStatusResponse:)];
    [updateInt updateStatusWithUrl:foodTypeStr status:statusStr];
}

-(void)updateStatusResponse:(NSDictionary *)resultDict
{
    if (resultDict) {
        if ([[MobileFreshUtil nullValue:[resultDict valueForKey:@"message"]] isEqualToString:@"Success"]) {
            [nodesArray removeObject:fromNode];
            [MobileFreshUtil showAlert:@"Mobile Fresh" msg:@"Food Status Update Successfully"];
            [self addnodesForMap];
        }
        else
        {
            [MobileFreshUtil showAlert:@"Mobile Fresh" msg:[MobileFreshUtil nullValue:[resultDict valueForKey:@"message"]]];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
