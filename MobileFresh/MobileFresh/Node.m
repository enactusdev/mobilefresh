//
//  Node.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "Node.h"

@implementation Node
@synthesize title,latitude,longitude,isNodeSelected;
@synthesize location,foodType,time;

-(id)initWithNodDict:(NSDictionary *)nodeDict
{
    if (self == [super init]) {
        self.title  = @"Node";//[nodeDict valueForKey:@""];
        
        self.location = [nodeDict valueForKey:@"NodeLocation"];
        self.foodType = [nodeDict valueForKey:@"foodtype"];
        self.time = [nodeDict valueForKey:@"time"];
        
        NSArray *locationArray = [self.location componentsSeparatedByString:@","];
        if (locationArray.count) {
            self.latitude = [[locationArray objectAtIndex:0] floatValue];
            self.longitude = [[locationArray objectAtIndex:1] floatValue];
        }
        else
        {
            self.latitude = 0;
            self.longitude = 0;
        }
        
        self.isNodeSelected = NO;
    }
    return self;
}
@end
