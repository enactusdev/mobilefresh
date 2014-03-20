//
//  LoginInt.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 20/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "LoginInt.h"

@implementation LoginInt

-(void)loginWithUrl:(NSString *)paramStr
{
    NSString *urlString = [NSString stringWithFormat:@"%@foodDetails&format=json",SERVER_ADDRESS];
    urlString = [NSString stringWithFormat:@"%@%@",urlString,paramStr];
    NSLog(@"URLSTRING--------%@",urlString);
    
    [self startConnectionWithURL:urlString callback:@selector(loginReponseDetails:)];
}

-(void)loginReponseDetails:(NSMutableDictionary *)responseDict
{
    [delegate performSelector:callbackAction withObject:[responseDict objectForKey:@"message"] afterDelay:0];
    
}
@end
