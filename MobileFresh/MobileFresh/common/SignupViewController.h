//
//  SignupViewController.h
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define ServerAddress  @"http://192.168.1.24:8089/mobilefresh/MobileApis/test.php?method="

@interface SignupViewController : UIViewController<UITextFieldDelegate>
{
     NSMutableData  *_responseData;
//    IBOutlet UISegmentedControl *userType;
    UISegmentedControl *user_type;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UITextField *password2;
    IBOutlet UITextField *email;
    IBOutlet UITextField *organization;
    
    NSString *selectedSegmentText;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)selectSegment:(id)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *userType;
-(BOOL)checkPwd;
-(BOOL)checkEmptyTextFieldText;

@end
