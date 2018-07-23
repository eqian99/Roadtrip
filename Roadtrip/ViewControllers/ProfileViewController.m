//
//  ProfileViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/23/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentSearchesLabel;
@property (strong, nonatomic) PFUser *currUser;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.currUser == nil){
        self.currUser = [PFUser currentUser];
    }
    self.usernameLabel.text = [NSString stringWithFormat: @"%@", self.currUser.username];
    NSArray * places = [self.currUser valueForKey:@"cities"];
    if(places == nil){
        self.recentSearchesLabel.text = @"No recent searches";
    }
    else{
        NSString * recentPlaces = @"";
        for(int i = 0; i < 3; i++){
            if(places[i] != nil){
                recentPlaces = [recentPlaces stringByAppendingString:places[i]];
                if(i < 2){
                    recentPlaces = [recentPlaces stringByAppendingString:@"\n"];
                }
            }
            else{
                break;
            }
        }
        self.recentSearchesLabel.text = recentPlaces;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
