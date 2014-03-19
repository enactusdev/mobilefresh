//
//  LoginViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "LoginViewController.h"
#import "MobileFreshConstant.h"
#import "MobileFreshUtil.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName,password;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
      // Create url connection and fire request
    
        //sending request
    
      return self;
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    password.secureTextEntry = YES;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    [password setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.userName.delegate = self;
    self.password.delegate=self;



    // Do any additional setup after loading the view.
}

-(void)sendServerRequest
{
    
        NSLog(@"Alert message");
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSString *strPassword =password.text;
//        NSString *strUserName = userName.text;
        NSString *strRequest;
        NSURL *url = nil;
        NSMutableURLRequest *request = nil;
        
        strRequest = [NSString stringWithFormat:@"&email=%@&password=%@",userName.text,password.text];
        NSString *urlString = [NSString stringWithFormat:@"%@signin&format=json",SERVER_ADDRESS];
    
    urlString = [NSString stringWithFormat:@"%@%@",urlString,strRequest];
    url= [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
//        [request setValue:[NSString stringWithFormat:@"%d",[strRequest length] ] forHTTPHeaderField:@"Content-Length"];
    
//        NSData *requestData = [NSData dataWithBytes:[strRequest UTF8String] length:[strRequest length]];
//        [request setHTTPBody: requestData];
    
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        NSLog(@"%@",strRequest);
        
        
//        if(connection)
//        {
//            NSLog(@"Connection Successful");
//            
//        }
//        else{
//            NSLog(@"Not connected");
//            
//        }
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
-(BOOL)checkTextFieldVal
{
    [password resignFirstResponder];
    [userName resignFirstResponder];
    if([password.text length]==0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Empty textField!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        
        
        return NO;
        
    }
    else if(![self validateEmail:userName.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Email is Incorrect!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (IBAction)login:(id)sender
{
    NSLog(@"login button pressed");
    //userLogin Segue
    BOOL emptyFieldValueObj = [self checkTextFieldVal];
        //sending request
    
     if(emptyFieldValueObj)
        {
            [self sendServerRequest];
    }
//        else
//    {
//               [self performSegueWithIdentifier:@"userLogin" sender:self];
//    }
    
    //TODO
    //check if user has successfully logged in or not.
    //If not then display error message on login screen,
    //else take user to next screen corresponding to their user type
   // [self performSegueWithIdentifier:@"userLogin" sender:self];

   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
    // Sent to the delegate to determine whether the sign up request should be submitted to the server.


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (statusCode == 200) {
            NSLog(@"received successful (200) response ");
        } else {
            NSLog(@"whoops, something wrong, received status code of %d", statusCode);
        }
    } else {
        NSLog(@"Not a HTTP response");
    }
    
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
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    if(resultDict)
    {
        if ([[MobileFreshUtil nullValue:[resultDict valueForKey:@"message"]] isEqualToString:@"admin signed in"]) {
            [self performSegueWithIdentifier:@"adminLogin" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"userLogin" sender:self];
        }
    }
    
    NSLog(@"%@" , resultDict);
    //initialize a new webviewcontroller
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"connection failure");
    NSLog(@"%@" , error);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
