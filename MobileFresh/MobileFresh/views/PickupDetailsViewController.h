//
//  PickupDetailsViewController.h
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitListInt.h"
#import "AppDelegate.h"

@interface PickupDetailsViewController : UIViewController<UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *newManagedObject;
}

@property (weak, nonatomic) IBOutlet UITextView *foodType;
@property (nonatomic, retain) IBOutlet UIDatePicker *Picker;
-(void)getSubmitList:(NSString *)strRequest;

-(void)postFoodData:(NSString *)succesStatus;
@end
