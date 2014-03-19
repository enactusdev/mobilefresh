//
//  SubmitListInt.m
//  MobileFresh
//
//  Created by Divya on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "SubmitListInt.h"

@implementation SubmitListInt

-(void)getSubmitList:(NSString *)paramStr
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@foodDetails&format=json",SERVER_ADDRESS];
    urlString = [NSString stringWithFormat:@"%@%@",urlString,paramStr];
    NSLog(@"URLSTRING--------%@",urlString);

    [self startConnectionWithURL:urlString callback:@selector(postFoodData:)];
}
-(void)postFoodData:(NSDictionary *)responseDict
{
    [delegate performSelector:callbackAction withObject:[responseDict objectForKey:@"message"] afterDelay:0];
    
}

@end
