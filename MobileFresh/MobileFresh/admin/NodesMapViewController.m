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
