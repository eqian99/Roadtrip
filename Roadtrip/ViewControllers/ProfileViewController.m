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
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, SearchPeopleDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentSearchesLabel;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;



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
    
    PFFile *image = [self.currUser valueForKey:@"profilePic"];
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        self.profilePic.image = postImageView.image;
        self.profilePic.layer.masksToBounds = YES;
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    }];
    
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

- (IBAction)takeProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (IBAction)tappedChooseFromCamera:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = editedImage;
    PFFile *profilePicFile = [self getPFFileFromImage:self.profilePic.image];
    [self.currUser setValue:profilePicFile forKey:@"profilePic"];
    
    [self.currUser saveInBackground];
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}

- (IBAction)didTapSchedules:(id)sender {
    
    [self performSegueWithIdentifier:@"showUserSchedules" sender:self];
    
}


- (IBAction)tappedLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
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
