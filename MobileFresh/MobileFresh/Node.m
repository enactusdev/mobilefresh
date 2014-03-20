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
@synthesize location,foodType,time,idStr,distance;

-(id)initWithNodDict:(NSDictionary *)nodeDict
{
    if (self == [super init]) {
        self.title  = [nodeDict valueForKey:@"title"];
        
        self.location = [nodeDict valueForKey:@"NodeLocation"];
        self.foodType = [nodeDict valueForKey:@"foodtype"];
        self.time = [nodeDict valueForKey:@"time"];
        self.idStr = [nodeDict valueForKey:@"NodeId"];
//        if ([[nodeDict valueForKey:@"NodeLocation"] rangeOfString:@","].location == NSNotFound) {
//            
//            self.latitude = 0;
//            self.longitude = 0;
//        }
//        else {
//            NSArray *locationArray = [self.location componentsSeparatedByString:@","];
//            if (locationArray.count > 1) {
//                self.latitude = [[locationArray objectAtIndex:0] floatValue];
//                self.longitude = [[locationArray objectAtIndex:1] floatValue];
//            }
//            else
//            {
//                self.latitude = 0;
//                self.longitude = 0;
//            }
//        }
        self.latitude = [[[nodeDict valueForKey:@"NodeLocation"] valueForKey:@"Latitude"] floatValue];
        
        self.longitude = [[[nodeDict valueForKey:@"NodeLocation"] valueForKey:@"Longitude"] floatValue];
        self.isNodeSelected = NO;
    }
    return self;
}
@end
