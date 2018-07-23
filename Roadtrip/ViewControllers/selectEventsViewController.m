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

static int *const EVENTS = 0;
static int *const LANDMARKS = 1;


@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate, EventCellDelegate>

@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *eventsSelected;

@property (nonatomic, strong) NSMutableArray *landmarks;
@property (nonatomic, strong) NSMutableArray *landmarksSelected;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsLandmarksControl;



@property (nonatomic) int activitiesSelected;


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
    
    self.eventsSelected = [NSMutableArray new];
    self.landmarksSelected = [NSMutableArray new];
    
    self.events = [NSMutableArray new];
    self.landmarks = [NSMutableArray new];
    
    [self getEventsFromEventbrite];
    
    [self getLandmarks];
   
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)didChangeEventsLandmarksControl:(id)sender {

    [self.tableView reloadData];
    
}

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
            
            NSArray *eventsTemp = [Event eventsWithEventbriteArray:events];
            
            for(Event *event in eventsTemp) {
                NSTimeInterval eventStartUnix = [event.startDate timeIntervalSince1970];
                if(eventStartUnix < self.endOfDayUnix){
                    [self.events addObject:event];
                    [self.eventsSelected addObject:@NO];
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
            
        }
        
    }];
    
    
    
}


-(void)getLandmarks{
    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    [myManagerGoogle getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             
             self.landmarks = [Landmark initWithArray:placesDictionaries];
             
             for(Landmark *landmark in self.landmarks) {
                 
                 [self.landmarksSelected addObject:@NO];
                 
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
    
    for(int i = 0; i < self.eventsSelected.count; i++) {
        
        if([[self.eventsSelected objectAtIndex:i] isEqual:@YES]) {
            
            Event *event = [self.events objectAtIndex:i];
            
            [mutableArray addObject:event];
            
        }
        
        
    }
    
    return [mutableArray copy];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    NSInteger indexSelected = self.eventsLandmarksControl.selectedSegmentIndex;
    
    if(indexSelected == EVENTS) {
        
        [cell setEvent: [self.events objectAtIndex:indexPath.row]];
    
        if(self.eventsSelected.count > 0){
            
            NSLog(@"cellsSelected Count: %ld Indexpath.row: %ld", self.eventsSelected.count, indexPath.row);
            
            if(self.eventsSelected.count > indexPath.row) {
                
                if([[self.eventsSelected objectAtIndex:indexPath.row]isEqual:@YES]){
                    
                    [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                    
                }
                else{
                    
                    [cell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
                    
                }
                
            }
            
        }
        
    }else if( indexSelected == LANDMARKS) {
        
        [cell setLandmark: [self.landmarks objectAtIndex:indexPath.row]];

        if(self.landmarksSelected.count > 0){
            
            NSLog(@"cellsSelected Count: %ld Indexpath.row: %ld", self.eventsSelected.count, indexPath.row);
            
            if(self.landmarksSelected.count > indexPath.row) {
                
                if([[self.landmarksSelected objectAtIndex:indexPath.row]isEqual:@YES]){
                    
                    [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                    
                }
                else{
                    
                    [cell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
                    
                }
                
            }
            
        }
        
    }
    
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger activitySelected = self.eventsLandmarksControl.selectedSegmentIndex;
    
    if(activitySelected == EVENTS) {
        
        return self.events.count;
        
    } else {
        
        return self.landmarks.count;
        
    }
    
}

//Method triggered when u select the checkbox in the event cell

- (void)eventCell:(EventCell *)eventCell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
    
    NSInteger activitySelected = self.eventsLandmarksControl.selectedSegmentIndex;
    
    if(activitySelected == EVENTS) {
     
        if([self.eventsSelected[indexPath.row] isEqual:@NO]) {
            
            [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            // check if there are conflicts
//            if ([self checkOverlap])
//            {
//                [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
//            }
//
//            else
//            {
            
                //Check mark
                
                [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                
                self.activitiesSelected += 1;
                
           // }
            
        } else {
            
            //Uncheck mark
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
            
            [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            self.activitiesSelected -= 1;
            
        }
        
    } else if (activitySelected == LANDMARKS) {
        
        if([self.landmarksSelected[indexPath.row] isEqual:@NO]) {
            
            [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            // check if there are conflicts
            if ([self checkOverlap])
            {
                [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            }
            
            else
            {
                
                //Check mark
                
                [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                
                self.activitiesSelected += 1;
                
            }
            
        } else {
            
            //Uncheck mark
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
            
            [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            self.activitiesSelected -= 1;
            
        }
        
        
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
        
        if([self.eventsSelected[i] isEqual:@YES]){
            
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
