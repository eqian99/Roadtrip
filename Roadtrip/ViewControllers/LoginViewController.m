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

@interface LoginViewController () <SignupViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    
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
