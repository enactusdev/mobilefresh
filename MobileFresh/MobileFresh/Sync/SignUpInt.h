//
//  SignUpInt.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 20/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "IntAbstract.h"

@interface SignUpInt : IntAbstract

-(void)signUpUserWithUrl:(NSString *)urlStr;
-(void)signUpResponse:(NSDictionary *)responseDict;
@end
