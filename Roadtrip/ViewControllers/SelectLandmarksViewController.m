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

@end

@implementation SelectLandmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getMyEvents];
}

- (void)getMyEvents{
    GoogleMapsManager *myManager = [GoogleMapsManager new];
    
    [myManager getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
    {
        if(placesDictionaries)
        {
            NSMutableArray *myPlacesArray = [Landmark initWithArray:placesDictionaries];
            for(Landmark *landmark in self.landmarks)
            {
                NSLog(@"%@, %@, %@", landmark.name, landmark.rating, landmark.address);
            }
        }
        else
        {
            NSLog(@"No places found");
        }
    }];

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
    LandmarkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
    return cell; 
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.landmarks.count;
}
 


@end
