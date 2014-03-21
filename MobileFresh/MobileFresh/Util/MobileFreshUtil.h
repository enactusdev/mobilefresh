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
+(double)toRadians:(CGFloat ) deg ;
+(CGFloat) toDegrees:(CGFloat )radians;

+(double) distance:(float)lat1 fromLongitude:(float)lon1 toLat:(float)lat2 toLong:(float)lon2 altitude1:(double)el1 altitude2:(double)el2;
+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)message;

+(BOOL) checkValue:(NSString *) val ForVariable:(NSString *) variableName;
@end
