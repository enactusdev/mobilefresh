//
//  IntAbstract.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 19/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "IntAbstract.h"
#import "MobileFreshUtil.h"
@implementation IntAbstract

-(id)initWithDelegate:(id)delegateObj callback:(SEL)callBackMethod{
    
    if (self == [super init]) {
        callbackAction = callBackMethod;
        delegate = delegateObj;
    }
    return self;
}


-(void)startConnectionWithURL:(NSString *)urlStr  callback:(SEL)responseCallBackAction
{
    responseCallBack = responseCallBackAction;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    if(resultDict)
    {
        
        NSLog(@"connected Successfully");
        [self performSelector:responseCallBack withObject:resultDict afterDelay:0];
    }
    
    //initialize a new webviewcontroller
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"connection failure");
    NSLog(@"%@" , error);
    if (error.code == -1001) {
        [MobileFreshUtil showAlert:@"Error" msg:@"Request Time Out"];
    }
}


@end
