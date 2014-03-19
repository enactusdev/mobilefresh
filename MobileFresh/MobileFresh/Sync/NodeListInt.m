//
//  NodeListInt.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodeListInt.h"
#import "Node.h"
@implementation NodeListInt
-(void)getNodeList
{
    NSString *urlString = [NSString stringWithFormat:@"%@getnodeList&format=json&usertype=admin",SERVER_ADDRESS];
    [self startConnectionWithURL:urlString callback:@selector(receiveNodes:)];
}

-(void)receiveNodes:(NSDictionary *)responseDict
{
    NSMutableArray *nodeList = [[NSMutableArray alloc] init];
    for (NSDictionary *nodeDict in [responseDict valueForKey:@"data"]) {
        Node *node = [[Node alloc] initWithNodDict:nodeDict];
        node.idStr = [NSString stringWithFormat:@"NODE_%d",[[responseDict valueForKey:@"data"] indexOfObject:nodeDict]];
        [nodeList addObject:node];
    }
    [delegate performSelector:callbackAction withObject:nodeList afterDelay:0];
}

@end
