//
//  NodeListTableViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodeListTableViewController.h"
#import "MobileFreshUtil.h"
@interface NodeListTableViewController ()

@end

@implementation NodeListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO
    //get the list of nodes from server and display them here
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addLoadingWheel];
    [self initArray];
    [self.tableView reloadData];
}

-(void)addLoadingWheel{
    
    self.loadingWheel.frame = CGRectMake((320-self.loadingWheel.frame.size.width)/2, self.loadingWheel.frame.origin.y, self.loadingWheel.frame.size.width, self.loadingWheel.frame.size.height);
    [self.tableView addSubview:self.loadingWheel];
    [self.loadingWheel startAnimating];
    
    [self.nextButton setHidden:YES];
}

-(void)removeLoadingWheel
{
    [self.loadingWheel stopAnimating];
    [self.loadingWheel removeFromSuperview];
}
-(void)initArray
{
    nodesArray = [[NSMutableArray alloc] init];
    switchInfoDict = [[NSMutableDictionary alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initArray];
    [self getNodesFromAPI];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self removeLoadingWheel];
    [super viewDidDisappear:animated];
}
-(void)getNodesFromAPI
{
    NodeListInt *nodeInt = [[NodeListInt alloc] initWithDelegate:self callback:@selector(getNodeList:)];
    [nodeInt getNodeList];
}

-(void)getNodeList:(NSArray *)nodeListArray
{
//    NSLog(@"Nodes Array--%@",nodeListArray);
    [self removeLoadingWheel];
    if (nodeListArray.count) {
        
        nodesArray = [[NSMutableArray alloc] initWithArray:nodeListArray];
        
        [self.tableView reloadData];
        
        [self.nextButton setHidden:NO];
    }
    else
    {
        [MobileFreshUtil showAlert:@"Mobile Fresh" msg:@"Currently there is no nodes to pick the food"];
    }
}

-(void)btnSelected
{
    [self performSegueWithIdentifier:@"MapView" sender:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (IBAction)updateSwitchAtIndexPath:(UISwitch *)sender {
    NodeCell *cell = (NodeCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    Node *node = [nodesArray objectAtIndex:sender.tag];
    cell.isNodeSelected = node.isNodeSelected = sender.on;
    
    [switchInfoDict setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:[NSString stringWithFormat:@"%d",sender.tag]];
    [nodesArray replaceObjectAtIndex:sender.tag withObject:node];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [nodesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%d.%d",indexPath.section,indexPath.row];

    NodeCell *cell ;
//    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell == nil) {
//        
//        // Configure the cell...
        cell =[[NodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier delegate:self];
        
        Node *node = [nodesArray objectAtIndex: indexPath.row];
        cell.nodeSwitch.tag = indexPath.row;
        cell.title.text = node.title;
    if (switchInfoDict && [[switchInfoDict allKeys] containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
        cell.nodeSwitch.on = [[switchInfoDict valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] integerValue];
    }
//    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)nextAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"MapView" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapView"]) {
        NodesMapViewController *controller = (NodesMapViewController *)segue.destinationViewController;
        NSMutableArray *selectedNodeArray= [[NSMutableArray alloc] init];
        for (Node *node in nodesArray) {
            if ([node isNodeSelected]) {
                [selectedNodeArray addObject:node];
            }
        }
        controller.nodesArray = selectedNodeArray;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
