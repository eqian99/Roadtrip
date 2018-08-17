//
//  RecognizedFriendsViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/15/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface RecognizedFriendsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *recognizedTableView;
@property (strong, nonatomic) NSDictionary *userPhotosDictionary;

@property (strong, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSArray *friends;


@end
