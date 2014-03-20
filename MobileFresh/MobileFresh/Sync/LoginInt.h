//
//  LoginInt.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 20/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "IntAbstract.h"

@interface LoginInt : IntAbstract

-(void)loginWithUrl:(NSString *)paramStr;
-(void)loginReponseDetails:(NSMutableDictionary *)responseDict;
@end
