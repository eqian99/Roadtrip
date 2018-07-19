//
//  selectEventsViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "selectEventsViewController.h"
#import "SelectLandmarksViewController.h"
#import "YelpManager.h"
#import "EventCell.h"
#import "SelectLandmarksViewController.h"
#import "GoogleMapsManager.h"
#import "Landmark.h"
#import "LandmarkCell.h"

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellsSelected;
@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getMyEvents];
    self.cellsSelected = [NSMutableArray new];
    
    
    // Do any additional setup after loading the view.
}

- (void)getMyEvents{
    
    YelpManager *myManager = [YelpManager new];
    NSString *startDate = [NSString stringWithFormat:@"%i", (int)self.startOfDayUnix];
    NSString *endDate = [NSString stringWithFormat:@"%i", (int)self.endOfDayUnix];
    NSLog(@"%@", startDate);
    [myManager getEventswithLatitude:37.7749 withLongitude:-122.4194 withUnixStartDate:startDate withUnixEndDate:endDate withCompletion:^(NSArray *eventsDictionary, NSError *error) {
        if(eventsDictionary){
            NSLog(@"%@", eventsDictionary);
            NSMutableArray *myEvents = [Event eventsWithArray:eventsDictionary];
            self.events = [myEvents copy];
            
            for(int i = 0; i < self.events.count; i++) {
                
                [self.cellsSelected addObject: @NO];
                
            }
            NSLog(@"%lu", self.events.count);
            [self getLandmarks];
        }
        else{
            NSLog(@"There was an error");
        }
    }];
    
    
}

-(void)getLandmarks{
    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    [myManagerGoogle getPlacesNearLatitude:37.7749 nearLongitude:-122.4194 withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             NSMutableArray *myLandmarks = [Landmark initWithArray:placesDictionaries];
             NSArray *myLandmarksArray = [myLandmarks copy];
             self.events = [self.events arrayByAddingObjectsFromArray:myLandmarksArray];
             
             for(int i = 0; i < self.events.count; i++) {
                 
                 [self.cellsSelected addObject: @NO];
                 
             }
             [self.tableView reloadData];
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


- (IBAction)didClickedDone:(id)sender {
    
    [self performSegueWithIdentifier:@"scheduleSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"landmarksSelectionSegue"]){
        
        SelectLandmarksViewController *viewController = [segue destinationViewController];
        
        NSMutableArray *mutableArray = [NSMutableArray new];
        
        for(int i = 0; i < self.events.count; i++){
            
            if([self.cellsSelected[i] isEqual:@YES]){
                
                NSLog(@"Is YES");
                [mutableArray addObject:self.events[i]];
                
            }
        }
        
        viewController.eventsSelected = [mutableArray copy];
        
    }
    
    SelectLandmarksViewController *selectLandmarksViewController = [segue destinationViewController];
    
    selectLandmarksViewController.latitude = self.latitude;

    selectLandmarksViewController.longitude = self.longitude;

    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    if([self.events[indexPath.row] isKindOfClass:[Event class]]){
        [cell setEvent:self.events[indexPath.row]];
    }
    else{
        [cell setLandmark:self.events[indexPath.row]];
    }
    
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
    NSLog(@"%lu", self.events.count);
    return self.events.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.cellsSelected.count > 0) {
        
        if([self.cellsSelected[indexPath.row] isEqual:@NO]) {
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            // check if there are conflicts
            if ([self checkOverlap])
            {
                [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            }
            
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            
        }
        
    }
    
}



// Checks whether there are overlaps in the events selected.
// Should be called whenever anything is selected/deselected.
- (BOOL) checkOverlap {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for(int i = 0; i < self.events.count; i++){
        
        if([self.cellsSelected[i] isEqual:@YES]){
            
            [mutableArray addObject:self.events[i]];
            
        }
    }
    
    // sort the events selected
    mutableArray = [NSMutableArray arrayWithArray: [Event sortEventArrayByEndDate:mutableArray]];
    
    for(int i = 0; i < mutableArray.count - 1; i++) {
        
        if (((Event *)mutableArray[i]).endTimeUnix > ((Event *)mutableArray[i+1]).startTimeUnix) {
            
            return true;
            
        };
        
    }
    
    return false;
}





@end
