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
#import "NodeListInt.h"
@interface NodeListTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *nodesArray;
    NSMutableDictionary *switchInfoDict;
}
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void)getNodeList:(NSArray *)nodeListArray;
@end
