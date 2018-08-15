//
//  ProfileViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/23/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ProfileViewController.h"
#import "SearchPeopleViewController.h"
#import "InvitesViewController.h"
#import "FriendCell.h"
#import "TripCell.h"
#import "ProfileFriendCell.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Invite.h"
#import "Schedule.h"
#import "UIImageView+AFNetworking.h"
#import <Lottie/Lottie.h>
#import "ScheduleDetailViewController.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>
#import "PersonFace.h"
#import "PersistedFace.h"
#import "UIImage+FixOrientation.h"
#import "UIImage+Crop.h"


@interface ProfileViewController () <UIImagePickerControllerDelegate, SearchPeopleDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSMutableArray<PersistedFace*> * _selectedFaces;
    NSMutableArray<PersonFace*> * _baseFaces;
    UICollectionView * _imageContainer0;
    UICollectionView * _imageContainer1;
    UIScrollView * _resultContainer;
    UIButton * _findBtn;
    UILabel * _imageCountLabel;
    NSInteger _selectIndex;
    NSInteger _selectedTargetIndex;
    NSString * _largrFaceListId;
}
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *invitesButton;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *invites;
@property (strong, nonatomic) NSMutableArray *schedules;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *tripsCollectionView;
@property (strong, nonatomic) PFUser *currUser;
@property (strong, nonatomic) NSString *largrFaceListId;


@end

@implementation ProfileViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchInvites];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.schedules = [NSMutableArray new];
    _largrFaceListId = @"8c641dc3-b437-43c5-afec-5eb8089cd462";
    
    _baseFaces = [NSMutableArray new];
    _selectedFaces = [NSMutableArray new];
    
    self.friendsCollectionView.delegate = self;
    self.friendsCollectionView.dataSource = self;
    
    self.tripsCollectionView.delegate = self;
    self.tripsCollectionView.dataSource = self;
    
    if(self.currUser == nil){
        self.currUser = [PFUser currentUser];
    }
    self.usernameLabel.text = [NSString stringWithFormat: @"%@", self.currUser.username];

    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    [self.usernameLabel adjustsFontSizeToFitWidth];
    
    PFFile *image = [self.currUser valueForKey:@"profilePic"];
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        self.profilePic.image = postImageView.image;
        self.profilePic.layer.masksToBounds = YES;
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    }];
    
    [self fetchFriendsOfCurrentUser];
    [self fetchSchedulesFromParse];
    
    
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
            [self.friendsCollectionView reloadData];
            [self.tripsCollectionView reloadData];
        }
    }];
}
-(void) fetchInvites {
    PFObject *userNotificationsObject = [[PFUser currentUser] objectForKey:@"userNotifications"];
    PFRelation *userNotifications = [userNotificationsObject relationForKey:@"notifications"];
    PFQuery *notificationsQuery = [userNotifications query];
    [notificationsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error getting invites");
        } else {
            NSLog(@"Successfully fetched invites");
            NSMutableArray *invitesArray = [NSMutableArray new];
            for(PFObject *notification in objects){
                [invitesArray addObject:notification];
            }
            self.invites = [invitesArray copy];
        }
    }];
}
-(void) fetchSchedulesFromParse {
    
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *schedulesRelation = [currentUser relationForKey:@"schedules"];
    PFQuery *schedulesQuery = [schedulesRelation query];
    [schedulesQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error fetching schedules");
        } else {
            for(PFObject *parseSchedule in objects) {
                Schedule *schedule = [Schedule new];
                schedule.name = [parseSchedule valueForKey:@"name"];
                schedule.eventsRelation = [parseSchedule relationForKey:@"events"];
                schedule.membersRelation = [parseSchedule relationForKey:@"members"];
                schedule.createdDate = parseSchedule.createdAt;
                schedule.parseObject = parseSchedule;
                schedule.creator = [parseSchedule objectForKey:@"Creator"];
                schedule.scheduleDate = [parseSchedule objectForKey:@"date"];
                schedule.photoReference = [parseSchedule objectForKey:@"photoReference"];
                [self.schedules addObject:schedule];
                [self.tripsCollectionView reloadData];
            }
            NSLog(@"Got schedules (%lu) ", objects.count);
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
    
    UIImage * _selectedImage;
    if (info[UIImagePickerControllerEditedImage])
        _selectedImage = info[UIImagePickerControllerEditedImage];
    else
        _selectedImage = info[UIImagePickerControllerOriginalImage];
    [_selectedImage fixOrientation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *data = UIImageJPEGRepresentation(_selectedImage, 0.8);
    if(_selectIndex != 0){
        MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
        [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
            if (error) {
                // [CommonUtil showSimpleHUD:@"Detection failed" forController:self.navigationController];
                return;
            }
            
            NSMutableArray * faces = [[NSMutableArray alloc] init];
            
            for (MPOFace *face in collection) {
                UIImage *croppedImage = [_selectedImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
                PersonFace *obj = [[PersonFace alloc] init];
                obj.image = croppedImage;
                obj.face = face;
                [faces addObject:obj];
            }
            
            [_baseFaces removeAllObjects];
            [_baseFaces addObjectsFromArray:faces];
            _findBtn.enabled = NO;
            _selectedTargetIndex = -1;
            NSLog(@"Faces in Wander!!!! : %lu" , collection.count);
            NSLog(@"%d faces in total", _baseFaces.count);
            _imageCountLabel.text =  [NSString stringWithFormat:@"%d faces in total", (int32_t)_selectedFaces.count];
            [_imageContainer0 reloadData];
            [_imageContainer1 reloadData];
            if (collection.count == 0) {
                // [CommonUtil showSimpleHUD:@"No face detected." forController:self.navigationController];
            }
        }];
    }else {
        [self addFace:data image:_selectedImage];
    }
}



    
- (void)addFace:data image:(UIImage *) image{
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    [client addFaceInLargeFaceList:_largrFaceListId data:data userData:nil faceRectangle:nil  completionBlock:^(MPOAddPersistedFaceResult *addPersistedFaceResult, NSError *error) {
        if (error) {
            // [CommonUtil showSimpleHUD:@"Failed in adding face" forController:self.navigationController];
            return;
        }
        // [CommonUtil showSimpleHUD:@"Successed in adding face" forController:self.navigationController];
        
        PersistedFace *obj = [[PersistedFace alloc] init];
        obj.image = image;
        obj.persistedFaceId = addPersistedFaceResult.persistedFaceId;
        
        [_selectedFaces addObject:obj];
        NSLog(@"%d faces in total", (int32_t)_selectedFaces.count);
        _imageCountLabel.text =  [NSString stringWithFormat:@"%d faces in total", (int32_t)_selectedFaces.count];
        [_imageContainer0 reloadData];
        [_imageContainer1 reloadData];
        
    }];
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

- (IBAction)didtapImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Source" message:@"From where do you want your image?" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        _selectIndex = 1;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction: galleryAction];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (IBAction)didTapAddFriend:(id)sender {
    [self performSegueWithIdentifier:@"searchPeopleSegue" sender:self];
}

- (void)fetchFriends {
    [self fetchFriendsOfCurrentUser];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.friendsCollectionView) {
        return self.friends.count;
    } else {
        return self.schedules.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.friendsCollectionView) {
        ProfileFriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileFriendCell" forIndexPath:indexPath];
        PFUser *friend = self.friends[indexPath.row];
        NSString *username = [friend valueForKey:@"username"];
        PFFile *image = [friend valueForKey:@"profilePic"];
        [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            cell.profileImageView.image = profileImage;
        }];
        cell.profileImageView.layer.masksToBounds = YES;
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2;
        cell.nameLabel.text = username;
        cell.nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.nameLabel adjustsFontSizeToFitWidth];

        return cell;
    } else {
        TripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tripCell" forIndexPath:indexPath];
        Schedule *schedule = self.schedules[indexPath.row];
        cell.schedule = schedule;
        cell.cityLabel.text = schedule.name;
        [cell.cityLabel sizeToFit];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocalizedDateFormatFromTemplate:@"MMMMd"];
        cell.dateLabel.text = [formatter stringFromDate:schedule.scheduleDate];
        [cell.dateLabel sizeToFit];
        if([schedule.photoReference isEqualToString:@"null"]){
            [cell.cityImageView setImage:[UIImage imageNamed:@"cityClipart"]];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                // Load image on a non-ui-blocking thread
                NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"300",schedule.photoReference]];
                NSLog(@"Photo URL: %@", photoURL);
                [cell.cityImageView setImageWithURL: photoURL];
            });
        }
        
        PFUser *creator = schedule.creator;
        [creator fetchIfNeeded];
        NSString *creatorUsername = [creator objectForKey:@"username"];
        cell.creatorLabel.text = [NSString stringWithFormat:@"Created by %@", creatorUsername];
        return cell;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"searchPeopleSegue"]) {
        SearchPeopleViewController *viewController = [segue destinationViewController];
        viewController.searchDelegate = self;
    } else if ([segue.identifier isEqualToString:@"invitesSegue"]) {
        InvitesViewController *viewController = [segue destinationViewController];
        viewController.invites = self.invites;
    } else if([segue.identifier isEqualToString:@"scheduleDetailSegue"]) {
        ScheduleDetailViewController *viewController = [segue destinationViewController];
        TripCell *cell = sender;
        Schedule *schedule = cell.schedule;
        viewController.schedule = schedule;
    }
    
    
}


@end
