//
//  CustomAnnotation.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
- (NSString *)title

{
	return title;
    
}
-(NSString*)subtitle
{
	return subtitle;
}

-(void)addAnotation:(NSString*)title1:(NSString*)subTitle1
{
	title = title1;
	subtitle=subTitle1;
}

@end
