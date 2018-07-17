//
//  SignupViewController.h
//  Roadtrip
//
//  Created by Emma Qian on 7/15/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignupViewControllerDelegate
- (void)didSignUp;
@end

@interface SignupViewController : UIViewController
@property (nonatomic, weak) id<SignupViewControllerDelegate>delegate;
@end
