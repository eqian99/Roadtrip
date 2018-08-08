//
//  AddPeopleScheduleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/30/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "AddPeopleScheduleViewController.h"
#import "Parse.h"

@interface AddPeopleScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddPeopleScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    [self.friendsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"friendCell"];
    self.friendsTableView.rowHeight = 100;
    
    [self fetchFriends];

}

-(void) fetchFriends {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *friendsRelation = [currentUser relationForKey:@"friends"];
    PFQuery *friendsQuery = [friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting friends");
        } else {
            self.friends = objects;
            [self.friendsTableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"friendCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PFUser *friend = self.friends[indexPath.row];
    cell.textLabel.text = [friend valueForKey:@"username"];
    NSLog(@"Friend email: %@", [friend valueForKey:@"publicEmail"]);
    cell.detailTextLabel.text = [friend valueForKey:@"publicEmail"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFUser *selectedFriend = self.friends[indexPath.row];
    PFObject *schedule = self.schedule.parseObject;
    NSString *friendName = [selectedFriend valueForKey:@"username"];
    NSString *message = [NSString stringWithFormat:@"Send invite to %@ ?", friendName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add friend?" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PFObject *selectedFriendNotifications = [selectedFriend valueForKey:@"userNotifications"];
        PFRelation *notificationsRelation = [selectedFriendNotifications relationForKey:@"notifications"];
        PFObject *notification = [PFObject objectWithClassName:@"Notification"];
        [notification setObject:[PFUser currentUser] forKey:@"sender"];
        [notification setObject: schedule forKey:@"schedule"];
        [notificationsRelation addObject:notification];
        [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                NSLog(@"Error saving notification");
            }else{
                NSLog(@"Successfully created notification");
                [selectedFriendNotifications saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"Error saving notification for friend");
                    }else{
                        NSLog(@"Successfully created notification for friend");
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                }];
            }
            
        }];
        
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
