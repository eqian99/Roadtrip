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
#import "EventMapViewController.h"
#import "MBProgressHUD.h"

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate, EventCellDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellsSelected;
@property (nonatomic) int eventsSelected;
@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Change navigation item
    
    self.eventsSelected = 0;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", self.city, self.stateAndCountry];
    
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
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.startOfDayUnix];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.endOfDayUnix];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    
    startDateString = [startDateString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    
    endDateString = [endDateString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[EventbriteManager new] getEventsWithCoordinates: coordinate withStartDateUTC:startDateString completion:^(NSArray *events, NSError *error) {
        
        if(error) {
            
            NSLog(@"Error getting events with time ranges");
            
        } else {
            for(NSDictionary *event in events) {
                //For every event dictionary, get the venue id, and get the address and coordinates
                
                NSString *venueId = event[@"venue_id"];
                [[EventbriteManager new] getVenueWithId:venueId completion:^(NSDictionary *venue, NSError *error) {
                    
                    if(error) {
                        
                        NSLog(@"Error getting venue: %@", error.description);
                        
                    } else {
                        
                        NSString *addressString = venue[@"localized_address_display"];
                        
                        NSString *latitude = venue[@"latitude"];
                        
                        NSString *longitude = venue[@"longitude"];
                        
                        Event *newEvent = [[Event new] initWithEventbriteDictionary:event withLatitude:latitude withLongitude:longitude withAddress:addressString];
                        
                        [self.events addObject:newEvent];
                        
                        [self.cellsSelected addObject:@NO];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        //[self.tableView reloadData];
                        
                        
                    }
                    
                }];
                
            }
            
            
        }
        [self getLandmarks];
        
        
    }];
    
    
    
}


-(void)getLandmarks{
    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    [myManagerGoogle getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             NSLog(@"%@", placesDictionaries);
             NSMutableArray *myLandmarks = [Landmark initWithArray:placesDictionaries];
             
             if(self.events.count == 0){
                 self.events = myLandmarks;
             }
             else{
                 for(Landmark *landmark in myLandmarks) {
                     
                     [self.events addObject:landmark];
                     
                     [self.cellsSelected addObject:@NO];
                     
                 }
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
    
    //[self performSegueWithIdentifier:@"scheduleSegue" sender:self];
}


#pragma mark - Navigation

- (IBAction)didPressMap:(id)sender {
    
    
    [self performSegueWithIdentifier:@"eventsMapSegue" sender:self];
    
    
}


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
    
    if([segue.identifier isEqualToString:@"eventDetailSegue"]) {
    
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.activities = self.events;
        eventDetailsViewController.index = indexPath.row;
        
        
    } else if ([segue.identifier isEqualToString:@"eventsMapSegue"]) {
        
        EventMapViewController *viewController = [segue destinationViewController];
        
        NSArray *selectedEvents = [self getEventsSelected];
        
        viewController.events = selectedEvents;
        
    }
    
}

-(NSArray *) getEventsSelected {
    
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for(int i = 0; i < self.cellsSelected.count; i++) {
        
        if([[self.cellsSelected objectAtIndex:i] isEqual:@YES]) {
            
            Event *event = [self.events objectAtIndex:i];
            
            [mutableArray addObject:event];
            
        }
        
        
    }
    
    return [mutableArray copy];
    
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
        
        NSLog(@"cellsSelected Count: %ld Indexpath.row: %ld", self.cellsSelected.count, indexPath.row);
        
        if(self.cellsSelected.count > indexPath.row) {
            
            if([[self.cellsSelected objectAtIndex:indexPath.row]isEqual:@YES]){
                
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                
            }
            else{
                
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
                
            }
            
            
        }
        
        
        
    }
    
    cell.delegate = self;
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
    
}

//Method triggered when u select the checkbox in the event cell

- (void)eventCell:(EventCell *)eventCell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
    
    if([self.cellsSelected[indexPath.row] isEqual:@NO]) {
        
        [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
        
        // check if there are conflicts
        if ([self checkOverlap])
        {
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
        }
        
        else
        {
            
            //Check mark
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
            
            self.eventsSelected += 1;
            
        }
        
    } else {
        
        //Uncheck mark
        
        [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
        
        [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
        
        self.eventsSelected -= 1;
        
    }
    
    
    NSLog(@"Event selected from selectEventsViewController");
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
    
}



// Checks whether there are overlaps in the events selected.
// Should be called whenever anything is selected/deselected.
- (BOOL) checkOverlap {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    
    for(int i = 0; i < self.events.count; i++){
        
        if([self.cellsSelected[i] isEqual:@YES]){
            
            [mutableArray addObject:self.events[i]];
            
            break;
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
