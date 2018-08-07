//
//  LoginViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/14/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "SignupViewController.h"
#import "YelpManager.h"
#import "Event.h"
#import "Restaurant.h"
#import "GoogleMapsManager.h"
#import "Landmark.h"
#import "MBProgressHUD.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"


const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;


@interface LoginViewController () <SignupViewControllerDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self.view setTintColor:[UIColor blueColor]];
#endif
    
    UIColor *floatingLabelColor = [UIColor brownColor];
    
    self.usernameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.usernameField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.usernameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.usernameField.floatingLabelTextColor = floatingLabelColor;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameField.keepBaseline = YES;
    //[self.usernameField setOpaque:NO];
    
    self.passwordField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.passwordField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.passwordField.floatingLabelTextColor = floatingLabelColor;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordField.keepBaseline = YES;
    
    // [self.usernameField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
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

- (void)didSignUp{


    [self performSegueWithIdentifier:@"mainSegue" sender:nil];

}


- (IBAction)pressedLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self createError:@"Incorrect username or password"];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"mainSegue" sender:nil];
            // display view controller that needs to shown after successful login
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    SignupViewController *signUpController = (SignupViewController *)navController;
    signUpController.delegate = self;
}


@end
