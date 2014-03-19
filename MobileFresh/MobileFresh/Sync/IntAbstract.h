//
//  IntAbstract.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileFreshConstant.h"
@interface IntAbstract : NSObject{
    NSMutableData *responseData;
    id delegate;
    SEL callbackAction,responseCallBack;
}
-(id)initWithDelegate:(id)delegateObj callback:(SEL)callBackMethod;
-(void)startConnectionWithURL:(NSString *)urlStr callback:(SEL)responseCallBackAction;

@end
