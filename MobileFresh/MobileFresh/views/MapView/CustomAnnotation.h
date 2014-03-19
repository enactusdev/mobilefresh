//
//  CustomAnnotation.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	
	
    
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy)  	NSString *title;
@property (nonatomic, copy) 	NSString *subtitle;

@end
