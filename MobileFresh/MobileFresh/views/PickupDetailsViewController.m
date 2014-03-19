//
//  PickupDetailsViewController.m
//  MobileFresh
//
//  Created by saurabh agrawal on 12/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "PickupDetailsViewController.h"

@interface PickupDetailsViewController ()

@end

@implementation PickupDetailsViewController
@synthesize foodType,Picker;

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
    NSLog(@"sindei view controller");
    foodType.delegate = self;
    foodType.text= @"";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitFoodDetails:(id)sender {
    //TODO
    //post the food pickup details to server
    NSLog(@"submitting");
    BOOL emptyfoodType=[self checkEmptyFoodType];
    //Getting the foodtype value
   if (emptyfoodType)
    {
        [self sendSubmitServerRequest];
    }
        
   }
-(void)sendSubmitServerRequest
{
    NSMutableDictionary *offer = [[NSMutableDictionary alloc] init];
    [offer setObject:foodType.text forKey:@"offerdescription"];
    
    //getting value from date picker
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:Picker.date];
    NSLog(@"%@",dateString);
    [offer setObject:dateString forKey:@"usebydate"];
    //Getting latitude and longitude values
    [self uploadOffer:offer];
    //Posting Date time ,foodtype values
    NSString *strRequest;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newManagedObject
                                                       options:NSJSONWritingPrettyPrinted error:Nil];
    NSString *jsonGeocodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    strRequest = [NSString stringWithFormat:@"&foodtype=%@&time=%@&geocode=%@&status=%@",foodType.text,dateString,jsonGeocodeString ,@"wating"];
    SubmitListInt *submitInt = [[SubmitListInt alloc] initWithDelegate:self callback:@selector(postFoodData:)];
    [submitInt getSubmitList:strRequest];

}

-(void)postFoodData:(NSString *)succesStatus
{
    if([succesStatus isEqualToString:@"Success"])
    {
        [self performSegueWithIdentifier:@"submitFoodPick" sender:self];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information of FoodType"
                                    message:@"Please enter food type"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
}

-(BOOL) checkEmptyFoodType
    {
    if ([foodType.text isEqualToString:@""] )
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information of FoodType"
                                    message:@"Please enter food type"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
        
    }
    else
        return YES;

}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([foodType.text isEqualToString:@""]) {
//        foodType.text = @"placeholder text here...";
//        foodType.textColor = [UIColor lightGrayColor]; //optional
//    }
//    [foodType resignFirstResponder];
//}


//Getting current Geolocation lat,longitude values
-(void)uploadOffer:(NSDictionary*) offer
{
     NSLog(@"uploading offer");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    newManagedObject=[[NSMutableDictionary alloc]init];
//       if (![[offer objectForKey:@"usebydate"] isEqualToString:@""])
//       {
//        [newManagedObject setValue:[offer objectForKey:@"usebydate"] forKey:@"usebydate"];
    
           NSString *latString = [NSString stringWithFormat:@"%f",appDelegate.locationManager.location.coordinate.latitude];
           NSString *lonString = [NSString stringWithFormat:@"%f",appDelegate.locationManager.location.coordinate.longitude];
           NSLog(@"latString: %@", latString);
           NSLog(@"lonString: %@", lonString);
           [newManagedObject setValue:latString forKey:@"latitude"];
           [newManagedObject setValue:lonString forKey:@"longitude"];
    
    
}


////for moving textview up and down

#define kOFFSET_FOR_KEYBOARD 90.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text{
    if (range.length==0) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;

}
-(void)textViewDidBeginEditing:(UITextField *)sender
{
//    if ([sender isEqual:mailTf])
//    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }

////    }
}



//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
/////////
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
