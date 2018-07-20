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
#import "EventbriteManager.h"
#import "EventCell.h"
#import "SelectLandmarksViewController.h"
#import "GoogleMapsManager.h"
#import "Landmark.h"
#import "LandmarkCell.h"
#import "EventDetailsViewController.h"

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellsSelected;
@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //[self getMyEvents];
    self.cellsSelected = [NSMutableArray new];
    
    self.events = [NSMutableArray new];
    
    [self getEventsFromEventbrite];
    
    
    // Do any additional setup after loading the view.
}


//- (void)getMyEvents{
//
//    YelpManager *myManager = [YelpManager new];
//    NSString *startDate = [NSString stringWithFormat:@"%i", (int)self.startOfDayUnix];
//    NSString *endDate = [NSString stringWithFormat:@"%i", (int)self.endOfDayUnix];
//    NSLog(@"%@", startDate);
//    [myManager getEventswithLatitude:37.7749 withLongitude:-122.4194 withUnixStartDate:startDate withUnixEndDate:endDate withCompletion:^(NSArray *eventsDictionary, NSError *error) {
//        if(eventsDictionary){
//
//            NSLog(@"%@", eventsDictionary);
//
//            NSMutableArray *myEvents = [Event eventsWithArray:eventsDictionary];
//
//            self.events = [myEvents copy];
//
//            self.events = [Event eventsWithYelpArray:eventsDictionary];
//
//
//            self.events = [Event eventsWithYelpArray:eventsDictionary];
//
//            for(int i = 0; i < self.events.count; i++) {
//
//                [self.cellsSelected addObject: @NO];
//
//            }
//            [self getLandmarks];
//        }
//        else{
//            NSLog(@"There was an error");
//        }
//    }];
//
//
//}

/*
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
            self.events = [Event eventsWithYelpArray:eventsDictionary];
            
            self.events = [Event eventsWithYelpArray:eventsDictionary];
            
            for(int i = 0; i < self.events.count; i++) {
                
                [self.cellsSelected addObject: @NO];
                
            }
            [self getLandmarks];
        }
        else{
            NSLog(@"There was an error");
        }
    }];
    
    
}
 */


-(void) getEventsFromEventbrite {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    //(37.7749, -122.4194);
    NSLog(@"%f", self.latitude);
    
    [[EventbriteManager new] getEventsWithCoordinates:coordinate completion:^(NSArray *events, NSError *error) {
       
    
        if(error) {
            
            
            NSLog(@"There was an error");
        } else {
            
            for(NSDictionary *event in events) {
                
                //For every event dictionary, get the venue id, and get the address and coordinates
                
                NSString *venueId = event[@"venue_id"];
                
                [[EventbriteManager new] getVenueWithId:venueId completion:^(NSDictionary *venue, NSError *error) {
                   
                    
                    if(error) {
                        
                        NSLog(@"Error getting venue: %@", error.description);
                        
                    } else {
                        
                        
                        NSString *addressString = venue[@"localized_address_display"];
                        
                        NSString *latitude = [NSString stringWithFormat:@"%f", self.latitude];
                        //venue[@"latitude"];
                        
                        NSString *longitude = [NSString stringWithFormat:@"%f", self.longitude];
                        //venue[@"longitude"];
                        
                        
                        Event *newEvent = [[Event new] initWithEventbriteDictionary:event withLatitude:latitude withLongitude:longitude withAddress:addressString];
                        
                        [self.events addObject:newEvent];
                        
                        //[self.tableView reloadData];
                        [self getLandmarks];
                        
                    }
                    
                }];
                
            }
            
            
            
            
        }
        
        
    }];
    
    
}

-(void)getLandmarks{
    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    [myManagerGoogle getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             NSMutableArray *myLandmarks = [Landmark initWithArray:placesDictionaries];
             
             for(Landmark *landmark in myLandmarks) {
                 
                 [self.events addObject:landmark];
                 
             }
             
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
    
    /*
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

    */
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];

    EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
    eventDetailsViewController.activities = self.events;
    eventDetailsViewController.index = indexPath.row;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    if([[self.events objectAtIndex:indexPath.row] isKindOfClass:[Event class]]){
            
        [cell setEvent: [self.events objectAtIndex:indexPath.row]];
    
    }
    else{
        
        [cell setLandmark: [self.events objectAtIndex:indexPath.row]];
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
