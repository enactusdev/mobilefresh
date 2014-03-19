//
//  MobileFreshUtil.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "MobileFreshUtil.h"

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

@end
