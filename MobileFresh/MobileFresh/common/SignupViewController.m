//
//  SignupViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "SignupViewController.h"
#import "AppDelegate.h"
#import "SignUpInt.h"
#import "MobileFreshConstant.h"
#import "MobileFreshUtil.h"
@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize userType,cancelBtn,submitBtn;

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
    [pinName setHidden:YES];
    userType.frame = CGRectMake(98,317,125,29);
    submitBtn.frame = CGRectMake(77,372,166,30);
    cancelBtn.frame= CGRectMake(77,426,166,30);
    pinName.text = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender {
    NSLog(@"Submit Button is clicked");
//    BOOL emptyFieldValue = [self checkEmptyTextFieldText];
    BOOL passwordMatching = [self checkPwd];
    if(passwordMatching)
    {
//        if(emptyFieldValue)
//        {
        
            [self sendserverRequest];
//        }
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)sendserverRequest
{
    NSString *userTypeStr=[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]];
    if(_responseData)
    {
        _responseData = nil;
    }
    
//    BOOL emptyFieldValue = [self checkEmptyTextFieldText];
    BOOL passwordMatching = [self checkPwd];
    
    
    if([MobileFreshUtil checkValue:userName.text ForVariable:@"Please Enter \"User Name\""])
        if([MobileFreshUtil checkValue:password.text ForVariable:@"Please Enter \"Password\""])
            if([MobileFreshUtil checkValue:password2.text ForVariable:@"Please Enter \"Confirm Password\""])
                if([MobileFreshUtil checkValue:email.text ForVariable:@"Please Enter \"Email\""])
                    if([MobileFreshUtil checkValue:organization.text ForVariable:@"Please Enter \"Organisation\""]){
    //sending request
    if(passwordMatching)
    {
//        if(emptyFieldValue)
//        {
        
            NSString *strRequest= [NSString stringWithFormat:@"username=%@&email=%@&password=%@&organizationname=%@&usertype=%@",userName.text,email.text,password.text,organization.text,[userTypeStr lowercaseString]];
            if ([[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]] isEqualToString:@"Admin"]) {
                NSLog(@"Pin --%@",pinName.text);
                if([MobileFreshUtil checkValue:pinName.text ForVariable:@"Please Enter \"Pin\""])
                {
                    strRequest = [NSString stringWithFormat:@"%@&pin=%@",strRequest,pinName.text];
                    
                }
                else
                {
                    return;
                }
            }
            SignUpInt *signUpInt = [[SignUpInt alloc] initWithDelegate:self callback:@selector(signUpResponse:)];
            [signUpInt signUpUserWithUrl:strRequest];
        }
    }
}

-(void)signUpResponse:(NSDictionary *)resultDict
{
    if(resultDict)
    {
        NSLog(@"connected Successfully");
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDel.userName = userName.text;
        if ([[resultDict valueForKey:@"message"] isEqualToString:@"Success"])
        {
            NSLog(@"%@" , resultDict);
            if ([[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]] isEqualToString:@"Admin"])
            {
                [self performSegueWithIdentifier:@"NodeList" sender:self];
            }
            
            else if ([[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]] isEqualToString:@"Donator"])
            {
                
                [self performSegueWithIdentifier:@"PickerDetails" sender:self];
            }
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Fresh" message:[resultDict valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    
    else
    {
        #warning
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Try Again!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
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

- (IBAction)selectSegment:(id)sender {
     NSString *userTypeStr=[self.userType titleForSegmentAtIndex:[self.userType selectedSegmentIndex]];
    NSLog(@"selected segment %@----",userTypeStr);
    if([userTypeStr isEqualToString:@"Admin"])
    {
        [pinName setHidden:NO];
        userType.frame = CGRectMake(98,362,125,29);
        submitBtn.frame = CGRectMake(77,426,166,30);
        cancelBtn.frame= CGRectMake(77,478,166,30);
    }
    else
    {
        [pinName setHidden:YES];
        userType.frame = CGRectMake(98,317,125,29);
        submitBtn.frame = CGRectMake(77,372,166,30);
        cancelBtn.frame= CGRectMake(77,426,166,30);
    }
}
@end
