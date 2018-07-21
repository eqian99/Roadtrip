//
//  SelectionViewController.h
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SelectionViewController : UIViewController
{
    UIDatePicker *datePicker;
}
@property (strong, nonatomic)PFUser *currUser;


@end


