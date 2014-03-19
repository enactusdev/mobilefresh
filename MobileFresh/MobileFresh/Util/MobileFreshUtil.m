//
//  MobileFreshUtil.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "MobileFreshUtil.h"
#import "AppDelegate.h"
#define radians( degrees ) ( degrees * M_PI / 180 )
#define radian 3.1416/180

@implementation MobileFreshUtil
+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:13];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    
    return label;
}

// Check Null Value
+(id)nullValue:(id)val{
    if(val == [NSNull null])
        return nil;
    else
        return val;
}

+(double)calculateDistanceWitLat:(float)fromLat fromLongitude:(float)fromLng toLat:(float)toLat toLong:(float)toLong{
//    NSLog(@"senders lat long ............%f,%f",lat, lng);
    
//    NSLog(@"receivers lat long ............%f,%f",currentLat, currentLng);
    
    CLLocationCoordinate2D currentLoc = CLLocationCoordinate2DMake(fromLat, fromLng);
    CLLocationCoordinate2D senderLoc = CLLocationCoordinate2DMake(toLat, toLong);
    double distance =0;
    distance = [self getDistance:currentLoc and:senderLoc];
//    NSLog(@"calculated ditance....%f", distance);
    return distance;
}

+(double) getDistance:(CLLocationCoordinate2D) location1 and:(CLLocationCoordinate2D) location2
{
    double lat1= location1.latitude*radian; double lon1 = location1.longitude;
    double lat2= location2.latitude*radian; double lon2 = location2.longitude;
    double dLat = radian*(fabs(lat2 - lat1));
    double dLon = radian*(fabs(lon2-lon1));
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    //    if(-a){
    //        a= -a;
    //    }
    double d = 3959 * 2 * atan2(sqrt(a), sqrt(1-a));
    
//    NSLog(@"distance.................diff....%f,%f,%f,%f",sqrt(a),sqrt(1-a),atan2(sqrt(a), sqrt(1-a)),3959 * 2 * atan2(sqrt(a), sqrt(1-a)) );
    return d;
}
@end
