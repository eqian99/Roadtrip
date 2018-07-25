//
//  SearchPeopleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/25/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SearchPeopleViewController.h"
#import "UserCell.h"
#import "Parse.h"

@interface SearchPeopleViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation SearchPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usersTableView.delegate = self;
    self.usersTableView.dataSource = self;
    self.usersTableView.rowHeight = 95;
    
    self.peopleSearchBar.delegate = self;
    
    
}

-(void) fetchUsersWithUsernameThatContainsString: (NSString *) string {
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" containsString: string];
    
    [query includeKey:@"publicEmail"];
    
    query.limit = 5;
    
    // fetch data asynchronously
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        
        if (users != nil) {
            // do something with the array of object returned by the call
            
            self.users = users;
            
            NSLog(@"%lu", self.users.count);
            
            [self.usersTableView reloadData];
            
        } else {
            
            NSLog(@"%@", error.localizedDescription);
            
        }
    }];
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"Searched %@", searchText);
    
    [self fetchUsersWithUsernameThatContainsString:searchText];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    PFUser *user = self.users[indexPath.row];
    
    NSString *username = [user valueForKey:@"username"];
    NSString *email = [user valueForKey:@"publicEmail"];
    
    cell.usernameLabel.text = username;
    cell.emailLabel.text = email;
    
    [cell.usernameLabel sizeToFit];
    [cell.emailLabel sizeToFit];
    

    
    return cell;
    
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
