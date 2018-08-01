//
//  SelectLandmarksViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectLandmarksViewController.h"
#import "LandmarkCell.h"
#import "Landmark.h"
#import "GoogleMapsManager.h"

@interface SelectLandmarksViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *landmarks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellsSelected;

@end

@implementation SelectLandmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getLandmarks];
    
    self.cellsSelected = [NSMutableArray new];
}

- (void)getLandmarks{
    NSLog(@"BEGIN LANDMARK CALL");
    GoogleMapsManager *myManager = [GoogleMapsManager new];
    /*
    [myManager getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
    {
        if(placesDictionaries)
        {
            NSMutableArray *myLandmarks = [Landmark initWithArray:placesDictionaries];
            NSLog(@"%@", placesDictionaries);
            self.landmarks = [myLandmarks copy];
            
            for(int i = 0; i < self.landmarks.count; i++) {
                
                [self.cellsSelected addObject: @NO];
                
            }
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"No places found");
        }
    }];*/

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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LandmarkCell"];
    
    [cell setLandmark: self.landmarks[indexPath.row]];
    
    
    if(self.cellsSelected.count > 0){
        
        if([[self.cellsSelected objectAtIndex:indexPath.row]isEqual:@YES]){
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else{
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
    }
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.landmarks.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LandmarkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.cellsSelected.count > 0) {
        
        if([self.cellsSelected[indexPath.row] isEqual:@NO]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            
        }
        
    }
}


@end
