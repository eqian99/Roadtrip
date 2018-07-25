//
//  ProfileViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/23/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentSearchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;



@property (strong, nonatomic) PFUser *currUser;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    
    self.friendsTableView.rowHeight = 80;
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];

    return cell;
    
}

- (IBAction)didTapAddFriend:(id)sender {
    
    
    [self performSegueWithIdentifier:@"searchPeopleSegue" sender:self];
    
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
