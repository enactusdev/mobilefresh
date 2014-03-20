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
    distanceArray = [[NSMutableArray alloc] init];
    shortestDistanceArray = [[NSMutableArray alloc] init];
    NSLog(@"Node Array --%@",nodesArray);
    [self getShortestPath];
    
    NSLog(@"Node Array --%@",nodesArray);
    
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


-(BOOL)prefersStatusBarHidden
{
    return YES;
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
    distanceArray = [self getShortestDistanceArrayFromCurrentLocation];
    if (distanceArray.count) {
        sourceNode =[distanceArray objectAtIndex:0];
        NSLog(@"surce distance---%lf",sourceNode.distance);
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
    for (Node *node in nodesArray) {
        if (node.isNodeSelected) {
            
            double distance = [MobileFreshUtil calculateDistanceWitLat:sourceNode.latitude fromLongitude:sourceNode.longitude toLat:node.latitude toLong:node.longitude];
            NSLog(@"distance---%lf",distance);
            node.distance = distance;
            [distanceNodeArray addObject:node];
        }
    }
    
    distanceArray = distanceNodeArray;
    if (distanceArray.count) {
        sourceNode =[distanceArray objectAtIndex:0];
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
            
            double distance = [MobileFreshUtil calculateDistanceWitLat:appDel.locationManager.location.coordinate.latitude fromLongitude:appDel.locationManager.location.coordinate.longitude toLat:node.latitude toLong:node.longitude];
            NSLog(@"distance---%lf",distance);
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
        return [str1 caseInsensitiveCompare:str2];
    }];
    
    return distanceNodeArray;
}
//-(void)dijkstraShortestPath
//{
//    int rank = 0;
//    int[,] L;
//    int[] C;
//    int[] D;
//    private int trank = 0;
//    public Dijkstra(int paramRank,int [,]paramArray)
//    {
//        L = new int[paramRank, paramRank];
//        C = new int[paramRank];
//        D = new int[paramRank];
//        rank = paramRank;
//        for (int i = 0; i < rank; i++)
//        {
//            for (int j = 0; j < rank; j++) {
//                L[i, j] = paramArray[i, j];
//            }
//        }
//        
//        for (int i = 0; i < rank; i++)
//        {
//            C[i] = i;
//        }
//        C[0] = -1;
//        for (int i = 1; i < rank; i++)
//            D[i] = L[0, i];
//    }
//    public void DijkstraSolving()
//    {
//        int minValue = Int32.MaxValue;
//        int minNode = 0;
//        for (int i = 0; i < rank; i++)
//        {
//            if (C[i] == -1)
//                continue;
//            if (D[i] > 0 && D[i] < minValue)
//            {
//                minValue = D[i];
//                minNode = i;
//            }
//        }
//        C[minNode] = -1;
//        for (int i = 0; i < rank; i++)
//        {
//            if (L[minNode, i] < 0)
//                continue;
//            if (D[i] < 0) {
//                D[i] = minValue + L[minNode, i];
//                continue;
//            }
//            if ((D[minNode] + L[minNode, i]) < D[i])
//                D[i] = minValue+ L[minNode, i];
//        }
//    }
//    public void Run()
//    {
//        for (trank = 1; trank >rank; trank++)
//        {
//            DijkstraSolving();
//            Console.WriteLine("iteration" + trank);
//            for (int i = 0; i < rank; i++)
//                Console.Write(D[i] + " ");
//            Console.WriteLine("");
//            for (int i = 0; i < rank; i++)
//                Console.Write(C[i] + " ");
//            Console.WriteLine("");
//        }
//    }
//}

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
/*
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
 */
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
//                UILabel *titleLabel = [MobileFreshUtil labelWithFrame:CGRectZero title:node.idStr];
//                titleLabel.backgroundColor =[UIColor clearColor];
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

/*
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
 */

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

-(void)foodPickOption:(Node *)node
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Mobile Fresh" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Driving Direction",@"Food Collected",@"Food Not Collected", nil];
    
//    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Mobile Fresh" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Food Collected",@"Food Not Collected", nil];
    foodTypeStr= node.idStr;
    fromNode = node;
    [alertView show];
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   // self.searchButton.hidden = NO;
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
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:fromNode.latitude longitude: fromNode.longitude];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:toNode.latitude longitude: toNode.longitude];
        NSDictionary *address1 = @{
                                  (NSString *)kABPersonAddressStreetKey: fromNode.title
                                  };
        NSDictionary *address2 = @{
                                  (NSString *)kABPersonAddressStreetKey: toNode.title
                                  };
//        __block MKPlacemark *placeMark1;
//        [reverseGeocoder reverseGeocodeLocation: location1 completionHandler:
//         ^(NSArray *placemarks, NSError *error) {
//             
//                 if (placemarks && placemarks.count > 0) {
//                     CLPlacemark *topResult = [placemarks objectAtIndex:0];
//                     // Create a MLPlacemark and add it to the map view
//                     placeMark1 = [[MKPlacemark alloc] initWithPlacemark:topResult];
//                     
//                     NSLog(@"City---%@",placeMark1.locality);
//             }
//         }];
//        __block MKPlacemark *placeMark2;
//        [reverseGeocoder reverseGeocodeLocation: location2 completionHandler:
//         ^(NSArray *placemarks, NSError *error) {
//             
//             if (placemarks && placemarks.count > 0) {
//                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
//                 // Create a MLPlacemark and add it to the map view
//                 placeMark2 = [[MKPlacemark alloc] initWithPlacemark:topResult];
//                 NSLog(@"City---%@",placeMark1.locality);
//             }
//         }];
        
        MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(fromNode.latitude, fromNode.longitude) addressDictionary:address1]];
        MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(toNode.latitude, toNode.longitude) addressDictionary:address2]];
        NSArray *mapItems = @[mapItem1, mapItem2];
        
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                                  };
        [MKMapItem openMapsWithItems:mapItems launchOptions:options];
    }
}
//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MKPolyline class]]) {
//        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
//        [renderer setStrokeColor:[UIColor blueColor]];
//        [renderer setLineWidth:5.0];
//        return renderer;
//    }
//    return nil;
//}

-(void)updateStatus:(NSInteger)forIndex
{
    NSString *statusStr = @"";
    if (forIndex == 2) {
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
