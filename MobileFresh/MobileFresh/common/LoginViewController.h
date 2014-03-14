//
//  LoginViewController.h
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ServerAddress  @"http://192.168.1.24:8089/mobilefresh/MobileApis/test.php?method="

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
     NSMutableData           *_responseData;
   
    NSMutableData *responseData;
    NSURLConnection *conn;
   
    BOOL emptyFieldValue;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

@end
