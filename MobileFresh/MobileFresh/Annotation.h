//
//  Annotation.h
//  MobileFresh
//
//  Created by Divya on 14/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@end
