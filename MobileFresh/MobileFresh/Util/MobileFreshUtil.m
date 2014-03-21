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
  
    NSLog(@"from lat long ............%f,%f",fromLat, fromLng);
    NSLog(@"to lat long ............%f,%f",toLat, toLong);
    
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

    double d = 3959 * 2 * atan2(sqrt(a), sqrt(1-a));

    return d;
    
//    double theDistance = (sin([self toRadians:lat1]) *
//                          sin([self toRadians:lat2])) +
//                          cos([self toRadians:lat1]) *
//                          cos([self toRadians:lat2]) *
//                          cos([self toRadians:lon1 - lon2]);
//    
////    return new Double((Math.toDegrees(Math.acos(theDistance))) * 69.09).intValue();
//    return [self toDegrees:(acos(theDistance))]*69.09*1.6093;// * 69.09.intValue();
}

+(double) distance:(float)lat1 fromLongitude:(float)lon1 toLat:(float)lat2 toLong:(float)lon2 altitude1:(double)el1 altitude2:(double)el2{
    
    NSLog(@"from lat long ............%f,%f",lat1, lon1);
    NSLog(@"to lat long ............%f,%f",lat2, lon2);
    
    int R = 6371; // Radius of the earth
    
    double latDistance = [self toRadians:(lat2 - lat1)];
    double lonDistance = [self toRadians:(lon2 - lon1)];
    double a = sin(latDistance / 2) * sin(latDistance / 2)
    + cos([self toRadians:lat1]) *  cos([self toRadians:lat2])
    *  sin(lonDistance / 2) *  sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c * 1000; // convert to meters
    
    double height = el1 - el2;
    distance = pow(distance, 2) + pow(height, 2);
    return sqrt(distance);
}

+(double)toRadians:(CGFloat ) deg {
    return deg * (M_PI / 180.0f);
}


+(CGFloat) toDegrees:(CGFloat )radians
{
    return radians * 180 / M_PI;
}

+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return alert;
}

+(BOOL) checkValue:(NSString *) val ForVariable:(NSString *) variableName
{
    if (!val || [val isEqual:nil] || [[val stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self showAlert:@"Error!!" msg:[NSString stringWithFormat:@"%@",variableName]];
        return NO;
    }
    return YES;
}

@end
