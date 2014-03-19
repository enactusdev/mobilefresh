//
//  UpdateStatusInt.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "IntAbstract.h"

@interface UpdateStatusInt : IntAbstract


-(void)updateStatusWithUrl:(NSString *)foodType status:(NSString *)statusStr;

@end
