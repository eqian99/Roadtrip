//
//  InvitesViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 8/1/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "InvitesViewController.h"
#import "InviteCell.h"
#import "Invite.h"

@interface InvitesViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation InvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.invitesTableView.dataSource = self;
    self.invitesTableView.delegate = self;
    self.invitesTableView.rowHeight = 115;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell" forIndexPath:indexPath];
    PFObject *invite = self.invites[indexPath.row];
    PFUser *sender = [invite objectForKey:@"sender"];
    PFObject *schedule = [invite objectForKey:@"schedule"];
    [schedule fetchIfNeeded];
    [sender fetchIfNeeded];
    NSDate *date = [schedule objectForKey:@"date"];
    cell.dateLabel.text = date.description;
    [cell.dateLabel sizeToFit];
    NSString *username = [sender objectForKey:@"username"];
    cell.usernameLabel.text = [NSString stringWithFormat:@"Invite from %@", username];
    [cell.usernameLabel sizeToFit];
    NSString *city = [schedule objectForKey:@"name"];
    cell.cityLabel.text = city;
    [cell.cityLabel sizeToFit];
    cell.invite = self.invites[indexPath.row];
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
