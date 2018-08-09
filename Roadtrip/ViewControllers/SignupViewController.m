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
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 50.0f;

const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface SignupViewController ()
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *emailField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPasswordField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // textfield for signup
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self.view setTintColor:[UIColor whiteColor]];
#endif
    
    UIColor *floatingLabelColor = [UIColor whiteColor];
    
    self.usernameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.usernameField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.usernameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.usernameField.floatingLabelTextColor = floatingLabelColor;
    self.usernameField.floatingLabelYPadding = 0;
    self.usernameField.textColor = [UIColor whiteColor];
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.keepBaseline = YES;
    
    // add white bottom border
    CALayer *border_user = [CALayer layer];
    CGFloat borderWidth = 2;
    border_user.borderColor = [UIColor whiteColor].CGColor;
    border_user.frame = CGRectMake(0, self.usernameField.frame.size.height - borderWidth, self.usernameField.frame.size.width, self.usernameField.frame.size.height);
    border_user.borderWidth = borderWidth;
    [self.usernameField.layer addSublayer:border_user];
    self.usernameField.layer.masksToBounds = YES;
    
    self.passwordField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.passwordField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.passwordField.floatingLabelTextColor = floatingLabelColor;
    self.passwordField.floatingLabelYPadding = 0;
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.keepBaseline = YES;
    
    // add white bottom border
    CALayer *border_pw = [CALayer layer];
    border_pw.borderColor = [UIColor whiteColor].CGColor;
    border_pw.frame = CGRectMake(0, self.passwordField.frame.size.height - borderWidth, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
    border_pw.borderWidth = borderWidth;
    [self.passwordField.layer addSublayer:border_pw];
    self.passwordField.layer.masksToBounds = YES;
    
    self.emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.emailField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.emailField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.emailField.floatingLabelTextColor = floatingLabelColor;
    self.emailField.floatingLabelYPadding = 0;
    self.emailField.textColor = [UIColor whiteColor];
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.keepBaseline = YES;
    
    // add white bottom border
    CALayer *border_email = [CALayer layer];
    border_email.borderColor = [UIColor whiteColor].CGColor;
    border_email.frame = CGRectMake(0, self.passwordField.frame.size.height - borderWidth, self.emailField.frame.size.width, self.emailField.frame.size.height);
    border_email.borderWidth = borderWidth;
    [self.emailField.layer addSublayer:border_email];
    self.emailField.layer.masksToBounds = YES;
    
    self.confirmPasswordField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.confirmPasswordField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Confirm email", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.confirmPasswordField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.confirmPasswordField.floatingLabelTextColor = floatingLabelColor;
    self.confirmPasswordField.floatingLabelYPadding = 0;
    self.confirmPasswordField.textColor = [UIColor whiteColor];
    self.confirmPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPasswordField.keepBaseline = YES;
    
    // add white bottom border
    CALayer *border_pw2 = [CALayer layer];
    border_pw2.borderColor = [UIColor whiteColor].CGColor;
    border_pw2.frame = CGRectMake(0, self.passwordField.frame.size.height - borderWidth, self.confirmPasswordField.frame.size.width, self.confirmPasswordField.frame.size.height);
    border_pw2.borderWidth = borderWidth;
    [self.confirmPasswordField.layer addSublayer:border_pw2];
    self.confirmPasswordField.layer.masksToBounds = YES;
    
    [self.emailField becomeFirstResponder];
    
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
    
    PFObject *userNotification = [PFObject objectWithClassName:@"UserNotifications"];
    [newUser setValue:self.emailField.text forKey:@"publicEmail"];
    [newUser setValue:userNotification forKey:@"userNotifications"];
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
