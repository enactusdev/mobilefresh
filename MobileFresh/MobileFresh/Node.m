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
@synthesize location,foodType,time,idStr,distance,addressDict;

-(id)initWithNodDict:(NSDictionary *)nodeDict
{
    if (self == [super init]) {
        self.title  = [nodeDict valueForKey:@"title"];
        
        self.location = [nodeDict valueForKey:@"NodeLocation"];
        self.foodType = [nodeDict valueForKey:@"foodtype"];
        self.time = [nodeDict valueForKey:@"time"];
        self.idStr = [nodeDict valueForKey:@"NodeId"];
        self.latitude = [[[nodeDict valueForKey:@"NodeLocation"] valueForKey:@"Latitude"] floatValue];
        
        self.longitude = [[[nodeDict valueForKey:@"NodeLocation"] valueForKey:@"Longitude"] floatValue];
        
        if ([nodeDict valueForKey:@"addressDictionary"]) {
            NSData *data = [[nodeDict valueForKey:@"addressDictionary"] dataUsingEncoding:NSUTF8StringEncoding];
            self.addressDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
//        self.addressDict = [nodeDict valueForKey:@"addressDictionary"];
        self.isNodeSelected = NO;
    }
    return self;
}
@end
