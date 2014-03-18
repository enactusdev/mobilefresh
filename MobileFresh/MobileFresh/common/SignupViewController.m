//
//  SignupViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize userType,cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender {
    NSLog(@"Submit Button is clicked");
  [self sendserverRequest];
    
    if ([[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]] isEqualToString:@"Admin"]) {
        
        [self performSegueWithIdentifier:@"NodeList" sender:self];
        
    }
   else
   {
       
       [self performSegueWithIdentifier:@"PickerDetails" sender:self];
        
    }
    
    //send the registration request to server
    //verify user information
    //check that password and password2 are same.
    //check that user has provided all the information.
    //call server api for signup
    //return success message
    //show the corresponding page depending on user is donater or admin
    
   //[self dismissViewControllerAnimated:YES completion:nil];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)sendserverRequest
{
    NSString *userTypeStr=[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]];
    NSLog(@"userTypeStr--%@",userTypeStr);
    if(_responseData)
    {
        _responseData = nil;
    }
    
    BOOL emptyFieldValue = [self checkEmptyTextFieldText];
    BOOL passwordMatching = [self checkPwd];
    //sending request
    if(passwordMatching)
    {
        if(emptyFieldValue)
        {
            
//            NSString *firstName = userName.text;
//            NSString *email1 = email.text;
//            NSString *password1= password.text;
//            NSString *passwordconf = password2.text;
            userType.selectedSegmentIndex=0;
            NSString *userTypeStr=[userType titleForSegmentAtIndex:0];
            
            // NSString *userTypeStr=[userType titleForSegmentAtIndex:[userType selectedSegmentIndex]];
            NSLog(@"userTypeStr--%@",userTypeStr);
            
            //            [_activityIndicator showCustomActivity:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString *strRequest;
            NSURL *url; //= nil;
            NSMutableURLRequest *request;// = nil;
            
            strRequest = [NSString stringWithFormat:@"username=%@&email=%@&password=%@&organizationname=%@&usertype=%@",userName.text,email.text,password.text,organization.text,[userTypeStr lowercaseString]];
            NSLog(@"request %@",strRequest);
            
            NSString *urlString = [NSString stringWithFormat:@"%@signup&format=json&",ServerAddress];
            
            NSLog(@"URLSTRING ------->>%@?%@",urlString,strRequest);
            
            url = [NSURL URLWithString:urlString];
            
            request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [request setHTTPMethod:@"POST"];
            
            [request setValue:[NSString stringWithFormat:@"%d",[strRequest length] ] forHTTPHeaderField:@"Content-Length"];
            
            NSData *requestData = [NSData dataWithBytes:[strRequest UTF8String] length:[strRequest length]];
            [request setHTTPBody: requestData];
            
            NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            [connection start];
        }
    }

    
}




/*************************************************************
 -(BOOL)checkPwdAndConfirmPwd
 Method to check the match of password and confirm password
 **************************************************************/
-(BOOL)checkPwd
{
    if([password.text isEqualToString:password2.text])
    {
    return YES;
    }
    else
        {
[[[UIAlertView alloc] initWithTitle:@"Password Incorrect"
                                            message:@"Try Again!"
                                            delegate:nil
                                  cancelButtonTitle:@"ok"
                                  otherButtonTitles:nil] show];
                return NO;
            }
    
}


-(BOOL)checkEmptyTextFieldText
{
    
    if(([userName.text length]==0) ||([email.text length]==0)||([password.text length]==0)||([password2.text length]==0)||([organization.text length]==0))
                {
                    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                                message:@"Empty textField!"
                                               delegate:nil
                                      cancelButtonTitle:@"ok"
                                      otherButtonTitles:nil] show];

                   
                    return NO;
                    
                }
                else if(![self validateEmail:email.text])
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
//-----------------------------------------------------------------------------
//Validating Email
//-----------------------------------------------------------------------------//

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(_responseData == nil)
    {
        _responseData = [[NSMutableData alloc]init];
        NSLog(@"connected to server");
    }
    if(data)
        [_responseData appendData:data];//appending the data to
    else {
        NSLog(@"ERROR IN GETTING DATA");
    }
    
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR IN GETTING DATA");
    //    [_activityIndicator showCustomActivity:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
   
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    [_activityIndicator showCustomActivity:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(_responseData)
    {
        NSString *newStr = [[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
//        
//        if ([[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]] isEqualToString:@"Admin"]) {
//            
//                   [self performSegueWithIdentifier:@"NodeList" sender:self];
//            
//                }
//               else
//               {
//            
//                  [self performSegueWithIdentifier:@"PickerDetails" sender:self];
//                   
//               }
        
        
    }
}

- (IBAction)selectSegment:(id)sender {
    NSLog(@"%@----",sender);
//    selectedSegmentText
}
@end
