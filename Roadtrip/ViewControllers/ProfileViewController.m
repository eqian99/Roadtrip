//
//  ProfileViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/23/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ProfileViewController.h"
#import "SearchPeopleViewController.h"
#import "FriendCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, SearchPeopleDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentSearchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (strong, nonatomic) NSArray *friends;



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
    
    [self fetchFriendsOfCurrentUser];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchFriendsOfCurrentUser {
    
    PFRelation *friendsRelation = [[PFUser currentUser] relationForKey:@"friends"];
    
    PFQuery *friendsQuery = [friendsRelation query];
    
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        if(error) {
            
            NSLog(@"Error getting friend relations");
            
        } else {
            
            self.friends = objects;
            
            NSLog(@"Got friends");
            
            [self.friendsTableView reloadData];
            
        }
        
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    PFUser *friend = self.friends[indexPath.row];
    
    
    NSString *username = [friend valueForKey:@"username"];
    NSString *email = [friend valueForKey:@"publicEmail"];
    
    cell.friendNameLabel.text = username;
    cell.friendEmailLabel.text = email;
    
    [cell.friendNameLabel sizeToFit];
    [cell.friendEmailLabel sizeToFit];
    

    return cell;
    
}

- (IBAction)didTapAddFriend:(id)sender {
    
    
    [self performSegueWithIdentifier:@"searchPeopleSegue" sender:self];
    
}

- (void)fetchFriends {
    
    [self fetchFriendsOfCurrentUser];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"searchPeopleSegue"]) {
        
        SearchPeopleViewController *viewController = [segue destinationViewController];
        
        viewController.searchDelegate = self;

    }
    
    
}


@end
