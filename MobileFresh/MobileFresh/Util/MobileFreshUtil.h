//
//  MobileFreshUtil.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MobileFreshUtil : NSObject
+(id)nullValue:(id)val;
+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title;

+(double)calculateDistanceWitLat:(float)fromLat fromLongitude:(float)fromLng toLat:(float)toLat toLong:(float)toLong;
+(double) getDistance:(CLLocationCoordinate2D) location1 and:(CLLocationCoordinate2D) location2;
@end
