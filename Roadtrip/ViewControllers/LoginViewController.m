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
//#import "MBProgressHUD.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "ZCDashLabel.h"
#import "CBZSplashView.h"

#import <objc/runtime.h>


const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 50.0f;

const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;


@interface LoginViewController () <SignupViewControllerDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *usernameField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (strong, nonatomic) IBOutlet ZCAnimatedLabel *label;
@property (weak, nonatomic) IBOutlet UIButton *loginLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // splash view to reveal login
    self.loginLabel.layer.masksToBounds = YES;
    self.loginLabel.layer.cornerRadius = 8.0;
    
    UIImage *icon = [UIImage imageNamed:@"circle.png"];
    UIColor *color = [UIColor colorWithRed:0.33 green:0.20 blue:1.00 alpha:1.0];
    // UIColor *color = [UIColor colorWithRed:0.13 green:0.74 blue:1.00 alpha:1.0];
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    
    // CBZSplashView *splashView = [CBZSplashView splashViewWithBezierPath:bezier
                                                        //backgroundColor:color];
    splashView.animationDuration = 1.8;
    
    [self.view addSubview:splashView];
    [splashView startAnimation];
    
    // animated label "Wander"
    self.label = [[ZCAnimatedLabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 66, 150, 600, 200)];
    [self.view addSubview:self.label];
    
    object_setClass(self.label, [ZCDashLabel class]);
    self.label.layerBased = YES;
    
    [self.label setNeedsDisplay];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.label setAttributedString:self.label.attributedString];
        [self.label startAppearAnimation];
    });
    
    [self animateLabelAppear:YES];

    
    // textfield for login
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
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, self.usernameField.frame.size.height - borderWidth, self.usernameField.frame.size.width, self.usernameField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.usernameField.layer addSublayer:border];
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

    [self.usernameField becomeFirstResponder];
    
}

- (void) animateLabelAppear: (BOOL) appear
{
    self.label.animationDuration = 0.2;
    self.label.animationDelay = 0.25;
    self.label.text = @"Wander";
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:self.label.text attributes:@{NSFontAttributeName : [UIFont fontWithName:@"MarkerFelt-Wide" size:40.0], NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor whiteColor]}] mutableCopy];
    
    self.label.attributedString = mutableString;
    
    if (appear) {
        [self.label startAppearAnimation];
    }
    else {
        [self.label startDisappearAnimation];
    }
}

- (IBAction) animateAppear: (id) sender
{
    [self animateLabelAppear:YES];
}

- (IBAction) animateDisappear: (id) sender
{
    [self animateLabelAppear:NO];
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
    NSLog(@"pressed");
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self createError:@"Incorrect username or password"];
        } else {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
