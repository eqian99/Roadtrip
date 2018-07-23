//
//  SignupViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/15/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createError:(NSString *)errorMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)pressedSignUp:(id)sender {
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    if(![self.passwordField.text isEqualToString:self.confirmPasswordField.text]){
        [self createError:@"Passwords don't match"];
        return;
    }
    
    // call sign up function on the object
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Error: %@", error.localizedDescription);
            
            // there was an error so call helper method to build error message
            if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.emailField.text isEqual:@""]){
                [self createError:@"Missing username or password or email"];
            }
            else if([error.localizedDescription rangeOfString:@"Email address format is invalid."].location != NSNotFound){
                [self createError:@"Email address format is invalid"];
            }
            else if([error.localizedDescription rangeOfString:@"Account already exists for this email address"].location != NSNotFound){
                [self createError:@"User already exists for that email address"];
            }
            else{
                [self createError:@"User already exists for that username"];
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didSignUp];
            
            // manually segue to logged in view
        }
    }];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
