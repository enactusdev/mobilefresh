//
//  Node.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject
{
    NSString *title;
    CGFloat latitude,longitude;
    BOOL isNodeSelected;
    
    NSString *idStr;
    NSString *location,*foodType,*time;
    CGFloat distance;
    
    NSDictionary *addressDict;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) CGFloat latitude,longitude;
@property (nonatomic, assign)BOOL isNodeSelected;
@property (nonatomic, assign)CGFloat distance;
@property (nonatomic,strong)NSDictionary *addressDict;



@property (nonatomic,copy)NSString *location,*foodType,*time,*idStr;

-(id)initWithNodDict:(NSDictionary *)nodeDict;
@end
