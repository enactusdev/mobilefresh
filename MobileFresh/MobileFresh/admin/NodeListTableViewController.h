//
//  NodeListTableViewController.h
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodesMapViewController.h"
#import "Node.h"
#import "NodeCell.h"
@interface NodeListTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *nodesArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
