//
//  UpdateStatusInt.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "UpdateStatusInt.h"
@implementation UpdateStatusInt
-(void)updateStatusWithUrl:(NSString *)foodType status:(NSString *)statusStr
{
    NSString *urlString = [NSString stringWithFormat:@"%@foodStatus&format=json&usertype=admin&foodtype=%@&status=%@",SERVER_ADDRESS,foodType,statusStr];
    [self startConnectionWithURL:urlString callback:@selector(receiveUpdateResponse:)];
}

-(void)receiveUpdateResponse:(NSDictionary *)responseDict
{
    [delegate performSelector:callbackAction withObject:nil afterDelay:0];
}

@end
