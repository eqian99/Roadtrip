//
//  RecognizedFriendsViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 8/15/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "RecognizedFriendsViewController.h"
#import "RecognizedFriendCell.h"

@interface RecognizedFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RecognizedFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recognizedTableView.delegate = self;
    self.recognizedTableView.dataSource = self;
    self.recognizedTableView.rowHeight = 225;
    
    [self.recognizedTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userPhotosDictionary.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecognizedFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recognizedCell" forIndexPath:indexPath];
    NSArray *keys = [self.userPhotosDictionary allKeys];
    UIImage *image = [self.userPhotosDictionary valueForKey:keys[indexPath.row]];
    cell.photoTaken.image = image;
    cell.photoTaken.layer.masksToBounds = YES;
    cell.photoTaken.layer.cornerRadius = cell.photoTaken.frame.size.width / 2;
    cell.usernameLabel.text = keys[indexPath.row];
    return cell;
}

- (IBAction)didPressInviteAll:(id)sender {
    
    NSArray *dictionaryKeys = [self.userPhotosDictionary allKeys];
    PFObject *mySchedule = self.schedule.parseObject;

    for(NSString *usernameValue in dictionaryKeys){
        for(PFUser *friend in self.friends){
            NSString *friendUsername = [friend valueForKey:@"username"];
            
            if([friendUsername isEqualToString:usernameValue]){
                PFObject *selectedFriendNotifications = [friend valueForKey:@"userNotifications"];
                PFRelation *notificationsRelation = [selectedFriendNotifications relationForKey:@"notifications"];
                PFObject *notification = [PFObject objectWithClassName:@"Notification"];
                [notification setObject:[PFUser currentUser] forKey:@"sender"];
                [notification setObject: mySchedule forKey:@"schedule"];
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
                                //[self dismissViewControllerAnimated:YES completion:nil];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                        }];
                    }
                    
                }];
            }
        }
    }
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
