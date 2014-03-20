//
//  SignUpInt.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 20/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "SignUpInt.h"

@implementation SignUpInt

-(void)signUpUserWithUrl:(NSString *)urlStr
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@signup&format=json&",SERVER_ADDRESS];
    urlString = [NSString stringWithFormat:@"%@%@",urlString,urlStr];
    [self startConnectionWithURL:urlString callback:@selector(signUpResponse:)];
}
-(void)signUpResponse:(NSDictionary *)responseDict
{
    [delegate performSelector:callbackAction withObject:responseDict afterDelay:0];
    
}
@end
