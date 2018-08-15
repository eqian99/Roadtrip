//
//  ShareScheduleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/30/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleMembersViewController.h"
#import "AddPeopleScheduleViewController.h"
#import "Parse.h"
#import "../utils/UIImage+FixOrientation.h"
#import "../utils/UIImage+Crop.h"
#import "../utils/ImageHelper/ImageHelper.h"
#import "PersonFace.h"
#import "PersistedFace.h"
#import "MPOSimpleFaceCell.h"
#import "MBProgressHUD.h"
#import "PersonFace.h"
#import "../utils/ViewUtils.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>

@interface ScheduleMembersViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource> {
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

@end

@implementation ScheduleMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.membersTableView.delegate = self;
    self.membersTableView.dataSource = self;
    [self.membersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"memberCell"];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(didClickAddButton)];
    [self.navigationItem setRightBarButtonItem:customBtn];
    
    [self fetchMembersOfSchedule];
}

-(void) didClickAddButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Source" message:@"Where do you want to save your schedule to?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *usernameAction = [UIAlertAction actionWithTitle:@"Add by username" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"addFriendsSegue" sender:self];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Add by photo" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction: usernameAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSegueWithIdentifier:@"addFriendsSegue" sender:self];
}

-(void) fetchMembersOfSchedule {
    
    PFQuery *membersQuery = [self.schedule.membersRelation query];
    [membersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching members of schedule");
        } else {
            self.members = objects;
            [self.membersTableView reloadData];
        }
        
    }];
    
}

- (void)trainLargeFaceList {
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Training large face list";
    [HUD show: YES];
    
    [client trainLargeFaceList:_largrFaceListId completionBlock:^(NSError *error) {
        [HUD removeFromSuperview];
        if (error) {
            //[CommonUtil showSimpleHUD:@"Failed in training large face list." forController:self.navigationController];
        } else {
            [self findSimilarFace];
        }
    }];
}

- (void)findSimilarFace {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Finding similar faces";
    [HUD show: YES];
    
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithEndpointAndSubscriptionKey:@"https://westcentralus.api.cognitive.microsoft.com/face/v1.0" key:@"8bbc65bcabcd4cb9976ca05de721eb5b"];
    
    [client findSimilarWithFaceId:_baseFaces[_selectedTargetIndex].face.faceId largeFaceListId:_largrFaceListId completionBlock:^(NSArray<MPOSimilarPersistedFace *> *collection, NSError *error) {
        [HUD removeFromSuperview];
        
        if (error) {
            //[CommonUtil showSimpleHUD:@"Failed to find similar faces" forController:self.navigationController];
            return;
        }
        
        for (UIView * v in _resultContainer.subviews) {
            [v removeFromSuperview];
        }
        for (int i = 0; i < collection.count; i++) {
            MPOSimilarPersistedFace * result = collection[i];
            UIImageView * imageView = [[UIImageView alloc] initWithImage:((PersistedFace*)[self faceForId:result.persistedFaceId]).image];
            imageView.width = _resultContainer.width / 6;
            imageView.height = imageView.width;
            imageView.left = 5;
            imageView.top = 5 + (imageView.height + 5) * i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            UILabel * label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"confidence: %f", result.confidence.floatValue];
            [label sizeToFit];
            label.center = imageView.center;
            label.left = imageView.right + 30;
            
            [_resultContainer addSubview:imageView];
            [_resultContainer addSubview:label];
        }
        _resultContainer.contentSize = CGSizeMake(_resultContainer.width, 5 + collection.count * (5 + _resultContainer.width / 6));
        if (collection.count == 0) {
            //[CommonUtil showSimpleHUD:@"No similar faces." forController:self.navigationController];
        }
    }];
}

- (PersistedFace*)faceForId:(NSString*)faceId {
    for (PersistedFace * face in _selectedFaces) {
        if ([face.persistedFaceId isEqualToString:faceId]) {
            return face;
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"memberCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    PFUser *member = self.members[indexPath.row];
    cell.textLabel.text = [member valueForKey:@"username"];
    cell.detailTextLabel.text = [member valueForKey:@"publicEmail"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    //self.profilePic.image = editedImage;
    //PFFile *profilePicFile = [self getPFFileFromImage:self.profilePic.image];
    //[self.currUser setValue:profilePicFile forKey:@"profilePic"];
    
    //[self.currUser saveInBackground];
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"addFriendsSegue"]) {
        AddPeopleScheduleViewController *viewController = [segue destinationViewController];
        viewController.schedule = self.schedule;
        
    }
    
}


@end
