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
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) CGFloat latitude,longitude;
@property (nonatomic, assign)BOOL isNodeSelected;
@end
