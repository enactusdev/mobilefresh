//
//  SubmitListInt.h
//  MobileFresh
//
//  Created by Divya on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntAbstract.h"

@interface SubmitListInt : IntAbstract

  -(void)getSubmitList:(NSString *)paramStr;
-(void)postFoodData:(NSMutableDictionary *)responseDict;
@end
