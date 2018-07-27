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
#import "UIImageView+AFNetworking.h"
#import "ScheduleViewController.h"
#import "Event.h"
#import "Landmark.h"

static int *const EVENTS = 0;
static int *const LANDMARKS = 1;


@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate, EventCellDelegate>

@property (nonatomic, strong) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *eventsSelected;

@property (nonatomic, strong) NSMutableArray *landmarks;
@property (nonatomic, strong) NSMutableArray *landmarksSelected;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *eventsLandmarksControl;

//@property (assign, nonatomic) Boolean firstTime;

@property (assign, nonatomic) int count;

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSMutableArray *longEventsArray;
@property (nonatomic, strong) NSMutableArray *landmarksArray;

@property (nonatomic) int activitiesSelected;

//used so that we can remove the conflicting event that was just added to array
@property (nonatomic, strong) Event *eventSelected;
@property (nonatomic, strong) Landmark *landmarkSelected;
@property (nonatomic, strong) NSString *typeSelected;

@property (nonatomic, assign) Boolean didDeselect;



@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Change navigation item
    
    self.eventsSelected = 0;
    //self.firstTime = YES;
    self.count = 0;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", self.city, self.stateAndCountry];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self getMyEvents];
    
    self.eventsSelected = [NSMutableArray new];
    self.landmarksSelected = [NSMutableArray new];
    
    self.events = [NSMutableArray new];
    self.landmarks = [NSMutableArray new];
    
    [self getEventsFromEventbrite];
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)didChangeEventsLandmarksControl:(id)sender {
    
    if(self.eventsLandmarksControl.selectedSegmentIndex == EVENTS) {
        
        NSLog(@"Events selected");
        [self getEventsFromEventbrite];
        
    } else {
        
        NSLog(@"Landmarks selected");
        [self getLandmarks];
        
    }

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
                if(event.startDate != nil && event.endDate != nil){
                    NSTimeInterval eventStartUnix = [event.startDate timeIntervalSince1970];
                    NSTimeInterval eventEndUnix = [event.endDate timeIntervalSince1970];
                    if(eventStartUnix < self.endOfDayUnix && eventEndUnix > self.startOfDayUnix){
                        [self.events addObject:event];
                        
                        [self.eventsSelected addObject:@NO];
                    }
                }
                else if(event.startDate != nil){
                    NSTimeInterval eventStartUnix = [event.startDate timeIntervalSince1970];
                    if(eventStartUnix < self.endOfDayUnix ){
                        [self.events addObject:event];
                        
                        [self.eventsSelected addObject:@NO];
                    }
                }
                else if(event.endDate != nil){
                    NSTimeInterval eventEndUnix = [event.endDate timeIntervalSince1970];
                    if(eventEndUnix > self.startOfDayUnix){
                        [self.events addObject:event];
                        
                        [self.eventsSelected addObject:@NO];
                    }
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }
        
    }];
    
    
    
}


-(void)getLandmarks{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    [myManagerGoogle getPlacesNearLatitude:self.latitude nearLongitude:self.longitude withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             
             self.landmarks = [Landmark initWithArray:placesDictionaries];
             
             for(Landmark *landmark in self.landmarks) {
                 
                 [self.landmarksSelected addObject:@NO];
                 
             }
             [MBProgressHUD hideHUDForView:self.view animated:YES];

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

- (void)createError:(NSString *)errorMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"eventDetailSegue"]) {
    
        UITableViewCell *tappedCell = sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        NSInteger indexSelected = self.eventsLandmarksControl.selectedSegmentIndex;
        
        if(indexSelected == EVENTS){
        
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        
        eventDetailsViewController.activities = self.events;
        
        eventDetailsViewController.index = indexPath.row;
        }
        else{
            EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
            
            eventDetailsViewController.activities = self.landmarks;
            
            eventDetailsViewController.index = indexPath.row;
        }
        
    } else if ([segue.identifier isEqualToString:@"eventsMapSegue"]) {
        
        EventMapViewController *viewController = [segue destinationViewController];
        
        NSArray *selectedEvents = [self getEventsSelected];
        
        NSArray *selectedLandmarks = [self getLandmarksSelected];
        
        viewController.landmarks = selectedLandmarks;
        
        viewController.events = selectedEvents;
        
    }
    else if([segue.identifier isEqualToString:@"scheduleSegue"]){
        ScheduleViewController *scheduleViewController = [segue destinationViewController];
        
        NSArray * allEvents = [self.eventsArray arrayByAddingObjectsFromArray:self.longEventsArray];
        
        allEvents = [allEvents arrayByAddingObjectsFromArray:self.landmarksArray];
        
        scheduleViewController.city = self.city;
        
        scheduleViewController.eventsSelected = allEvents;
        
        for(int i = 0; i < allEvents.count; i++){
            NSLog(@"%@", allEvents[i]);
        }
    }
    
}

-(NSArray *) getEventsSelected {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for(int i = 0; i < self.eventsSelected.count; i++) {
        
        if([[self.eventsSelected objectAtIndex:i] isEqual:@YES]) {
            
            Event *event = [self.events objectAtIndex:i];
            
            NSLog(@"Venue Id In selectEvents: %@", event.venueId);
            
            [mutableArray addObject:event];
            
        }
        
    }
    
    return [mutableArray copy];
    
}

-(NSArray *) getLandmarksSelected {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for(int i = 0; i < self.landmarksSelected.count; i++) {
        
        if([[self.landmarksSelected objectAtIndex:i] isEqual:@YES]) {
            
            Landmark *landmark = [self.landmarks objectAtIndex:i];
            
            [mutableArray addObject:landmark];
            
        }
    
    }
    
    return [mutableArray copy];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    [cell.warningLabel setHidden:YES];
    // also helps reduce choppiness
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    NSInteger indexSelected = self.eventsLandmarksControl.selectedSegmentIndex;
    
    if(indexSelected == EVENTS) {
        
        [cell setEvent: [self.events objectAtIndex:indexPath.row]];
        
        // load in background to prevent choppy scrolling
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            // Load image on a non-ui-blocking thread
            
            NSURL *posterURL = [NSURL URLWithString:cell.event.imageUrl];
            
            [cell.posterView setImageWithURL: posterURL];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                // Assign image back on the main thread
            });
            
        });
        
        if(self.eventsSelected.count > 0){
            
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
        
        // load in background to prevent choppy scrolling
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            // Load image on a non-ui-blocking thread
            
            NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"200",cell.landmark.photoReference]];
            
            
            NSData *photoData = [NSData dataWithContentsOfURL:photoURL];

            UIImage *image = [UIImage imageWithData:photoData];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                // Assign image back on the main thread
                
                cell.posterView.image = image;
                

            });
            
        });
        
        if(self.landmarksSelected.count > 0){
            
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger activitySelected = self.eventsLandmarksControl.selectedSegmentIndex;
    if(activitySelected == EVENTS) {
        if(self.events.count == 0 && self.count == 4){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self createError:@"There are no events happening today"];
            //self.firstTime = NO;
            self.count++;
        }
        self.count++;
        return self.events.count;
        
    } else {
        
        return self.landmarks.count;
        
    }
    
}
/*
- (void)hideCheckmark:(EventCell *)eventCell{
    
}
*/
//Method triggered when u select the checkbox in the event cell

- (void)eventCell:(EventCell *)eventCell {
    self.eventSelected = nil;
    self.landmarkSelected = nil;
    self.typeSelected = @"";
    NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
    
    NSInteger activitySelected = self.eventsLandmarksControl.selectedSegmentIndex;
    
    if(activitySelected == EVENTS) {
        
        if([self.eventsSelected[indexPath.row] isEqual:@NO]) {
            self.eventSelected = self.events[indexPath.row];
            self.typeSelected = @"event";
            [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            if ([self makeSchedule]) {
                
                [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                
                self.activitiesSelected += 1;
                
            }
            else {
                [eventCell.warningLabel setHidden:NO];
                [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            }
            
        } else {
            
            //Uncheck mark
            if(((Event *)self.events[indexPath.row]).isFlexible){
                [self removeLongEvent:self.events[indexPath.row]];
            }
            else{
                [self removeShortEvent: self.events[indexPath.row]];
            }
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
            
            [self.eventsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            self.activitiesSelected -= 1;
            
        }
        
    } else if (activitySelected == LANDMARKS) {
        
        if([self.landmarksSelected[indexPath.row] isEqual:@NO]) {
            self.landmarkSelected = self.landmarks[indexPath.row];
            self.typeSelected = @"landmark";
            [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            if ([self makeSchedule]) {
                
                [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
                
                self.activitiesSelected += 1;
                
            }
            else
            {
                [eventCell.warningLabel setHidden:NO];
                [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            }
            
        } else {
            
            [self removeLandmark:self.landmarks[indexPath.row]];
            //Uncheck mark
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
            
            [self.landmarksSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            self.activitiesSelected -= 1;
            
        }
        
        
    }
    
    
    NSLog(@"Event selected from selectEventsViewController");
    
    
}

-(void) removeShortEvent: (Event *)event{
    int i = 0;
    while(i < self.eventsArray.count && self.eventsArray[i] != event){
        i++;
    }
    [self.eventsArray removeObjectAtIndex:i];
}

-(void) removeLongEvent:(Event *)event{
    int i = 0;
    while(i < self.longEventsArray.count && self.longEventsArray[i] != event){
        i++;
    }
    [self.longEventsArray removeObjectAtIndex:i];
}

-(void) removeLandmark:(Landmark *)landmark{
    int i = 0;
    while(i < self.landmarksArray.count && self.landmarksArray[i] != landmark){
        i++;
    }
    [self.landmarksArray removeObjectAtIndex:i];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

// Set an array of all free blocks given an array of scheduled events
- (NSMutableArray *) getFreeBlocks:(NSMutableArray *) shortEventsArray {
    
    NSMutableArray *freeBlocks = [[NSMutableArray alloc] init];
    
    /*
     NSMutableArray *mutableArray = [NSMutableArray new];
     
     for(int i = 0; i < self.events.count; i++){
     
     if([self.cellsSelected[i] isEqual:@YES]){
     
     [mutableArray addObject:self.events[i]];
     
     }
     }
     
     // sort the events selected
     mutableArray = [NSMutableArray arrayWithArray: [Event sortEventArrayByEndDate:mutableArray]];
     */
    
    if (shortEventsArray.count == 0)
    {
        double start = self.startOfDayUnix;
        
        double end = self.endOfDayUnix;
        
        double duration = self.endOfDayUnix - self.startOfDayUnix;
        
        while (duration >= 7200)
        {
            duration = duration - 7200;
            
            end = start + 7200;
            
            NSArray *startElement = [NSArray arrayWithObjects: [NSNumber numberWithDouble:7200], [NSNumber numberWithDouble:start], [NSNumber numberWithDouble:end], nil];
            
            [freeBlocks addObject: startElement];
            
            start = end;
            
        }
        
        return freeBlocks;
    }
    
    
    // add the free time before start of first event
    double start = self.startOfDayUnix;
    
    double end = ((Event *)shortEventsArray[0]).startTimeUnix;
    
    double duration = ((Event *)shortEventsArray[0]).startTimeUnix - self.startOfDayUnix;
    
    while (duration >= 7200)
    {
        duration = duration - 7200;
        
        end = start + 7200;
        
        NSArray *startElement = [NSArray arrayWithObjects: [NSNumber numberWithDouble:7200], [NSNumber numberWithDouble:start], [NSNumber numberWithDouble:end], nil];
        
        [freeBlocks addObject: startElement];
        
        start = end;
        
    }
    
    
    for(int i = 0; i < shortEventsArray.count - 1; i++) {
        
        if (((Event *)shortEventsArray[i]).endTimeUnix < ((Event *)shortEventsArray[i+1]).startTimeUnix) {
            
            double start = ((Event *)shortEventsArray[i]).endTimeUnix;
            
            double end = ((Event *)shortEventsArray[i+1]).startTimeUnix;
            
            double duration = ((Event *)shortEventsArray[i+1]).startTimeUnix - ((Event *)shortEventsArray[i]).endTimeUnix;
            
            while (duration >= 7200)
            {
                duration = duration - 7200;
                
                end = start + 7200;
                
                NSArray *startElement = [NSArray arrayWithObjects: [NSNumber numberWithDouble:7200], [NSNumber numberWithDouble:start], [NSNumber numberWithDouble:end], nil];
                
                [freeBlocks addObject: startElement];
                
                start = end;
                
            }
            
        };
        
    }
    
    start = ((Event *)shortEventsArray[shortEventsArray.count - 1]).endTimeUnix;
    
    end = self.endOfDayUnix;
    
    duration = self.endOfDayUnix - ((Event *)shortEventsArray[shortEventsArray.count - 1]).endTimeUnix;
    
    while (duration >= 7200)
    {
        duration = duration - 7200;
        
        end = start + 7200;
        
        NSArray *startElement = [NSArray arrayWithObjects: [NSNumber numberWithDouble:7200], [NSNumber numberWithDouble:start], [NSNumber numberWithDouble:end], nil];
        
        [freeBlocks addObject: startElement];
        
        start = end;
        
    }
    
    return freeBlocks;
    
}


// Checks whether there are overlaps in the events selected.
// Should be called whenever anything is selected/deselected.
- (BOOL) makeSchedule{
    self.eventsArray = [NSMutableArray new];
    if(self.breakfastUnixTime != 0.0){
        Event *breakfast = [Event new];
        
        breakfast.name = @"Breakfast";
        breakfast.startTimeUnix = self.breakfastUnixTime;
        breakfast.endTimeUnix = self.breakfastUnixTime + 60 * 60;
        breakfast.startTimeUnixTemp = breakfast.startTimeUnix;
        breakfast.endTimeUnixTemp = breakfast.endTimeUnix;
        [self.eventsArray addObject:breakfast];
    }
    
    if(self.lunchUnixTime != 0.0){
        Event *lunch = [Event new];
        lunch.name = @"Lunch";
        lunch.startTimeUnix = self.lunchUnixTime;
        lunch.endTimeUnix = self.lunchUnixTime + 60 * 60;
        lunch.startTimeUnixTemp = lunch.startTimeUnix;
        lunch.endTimeUnixTemp = lunch.endTimeUnix;
        [self.eventsArray addObject:lunch];
    }
    
    if(self.dinnerUnixTime != 0.0){
        Event *dinner = [Event new];
        dinner.name = @"Dinner";
        dinner.startTimeUnix = self.dinnerUnixTime;
        dinner.endTimeUnix = self.dinnerUnixTime + 60 * 60;
        dinner.startTimeUnixTemp = dinner.startTimeUnix;
        dinner.endTimeUnixTemp = dinner.endTimeUnix;
        [self.eventsArray addObject:dinner];
    }
    
    self.longEventsArray = [NSMutableArray new];
    
    self.landmarksArray = [NSMutableArray new];
    
    for(int i = 0; i < self.eventsSelected.count; i++){
        
        if([self.eventsSelected[i] isEqual:@YES]){
            
            if (((Event *) self.events[i]).isFlexible)
            {
                [self.longEventsArray addObject:self.events[i]];
            }
            else
            {
                [self.eventsArray addObject:self.events[i]];
            }
            
        }
    }
    
    for(int i = 0; i < self.landmarksSelected.count; i++)
    {
        if ([self.landmarksSelected[i] isEqual:@YES])
        {
            [self.landmarksArray addObject:self.landmarks[i]];
        }
    }
    
    // sort the events selected
    self.eventsArray = [NSMutableArray arrayWithArray: [Event sortEventArrayByEndDate:self.eventsArray]];
    
    // get all free blocks
    NSMutableArray *freeBlocks = [self getFreeBlocks:self.eventsArray];
    
    NSLog(@"Number of free blocks: %lu", freeBlocks.count);
    
    /*
     * label the free blocks
     * 0 means not free
     * 1 means free for 2 or more hours
     */
    NSMutableArray *freeBlocksLabeled = [[NSMutableArray alloc] init];
    int count = 0;
    
    // check if the blocks are greater than one hour
    for (int i = 0; i < freeBlocks.count; i++)
    {
        if ([freeBlocks[i][0] intValue] >= 7200)
        {
            freeBlocksLabeled[i] = [NSNumber numberWithInt: 1];
            count ++;
        }
        else
        {
            freeBlocksLabeled[i] = [NSNumber numberWithInt: 0];
        }
    }
    
    if (count < self.longEventsArray.count + self.landmarksArray.count)
    {
        NSLog(@"RETURNED EARLY");
        if([self.typeSelected isEqualToString:@"event"]){
            int i = 0;
            while(self.longEventsArray[i] != self.eventSelected){
                i++;
            }
            [self.longEventsArray removeObjectAtIndex:i];
        }
        else if([self.typeSelected isEqualToString:@"landmark"]){
            int i = 0;
            while(self.landmarksArray[i] != self.landmarkSelected){
                i++;
            }
            [self.landmarksArray removeObjectAtIndex:i];
        }
        return false;
    }
    
    if (self.eventsArray.count > 1) {
    
        for(int i = 1; i < (self.eventsArray.count) ; i++) {
            
            if (((Event *)self.eventsArray[i-1]).endTimeUnix > ((Event *)self.eventsArray[i]).startTimeUnix) {
                if(((Event*)self.eventsArray[i - 1]) == self.eventSelected){
                    NSLog(@"hello i - 1");
                    [self.eventsArray removeObjectAtIndex:i - 1];
                }
                else if(((Event *)self.eventsArray[i]) == self.eventSelected){
                    NSLog(@"hello i");
                    [self.eventsArray removeObjectAtIndex:i];
                }
                NSLog(@"RETURNED EARLY EVENTS");
                return false;
                
            }
            
        }
        
    }
    
    for (int i = 0; i < self.longEventsArray.count; i++)
    {
        for (int j = 0; j < freeBlocksLabeled.count; j++)
        {
            if (freeBlocksLabeled[j] == [NSNumber numberWithInt: 1])
            {
                ((Event *)self.longEventsArray[i]).startTimeUnixTemp = [((NSNumber *)freeBlocks[j][1]) doubleValue];
                ((Event *)self.longEventsArray[i]).endTimeUnixTemp = [((NSNumber *)freeBlocks[j][2]) doubleValue];
                freeBlocksLabeled[j] = [NSNumber numberWithInt: 0];
                break;
            }
        }
    }
    
    for (int i = 0; i < self.landmarksArray.count; i++)
    {
        for (int j = 0; j < freeBlocksLabeled.count; j++)
        {
            if (freeBlocksLabeled[j] == [NSNumber numberWithInt: 1])
            {
                ((Event *)self.landmarksArray[i]).startTimeUnixTemp = [((NSNumber *)freeBlocks[j][1]) doubleValue];
                ((Event *)self.landmarksArray[i]).endTimeUnixTemp = [((NSNumber *)freeBlocks[j][2]) doubleValue];
                freeBlocksLabeled[j] = [NSNumber numberWithInt: 0];
                break;
            }
        }
    }
    
    for (int i = 0; i < self.landmarksArray.count; i++)
    {
        NSLog(@"Landmark: %f, %f", ((Event *)self.landmarksArray[i]).startTimeUnixTemp, ((Event *)self.landmarksArray[i]).endTimeUnixTemp);
    }
    
    for (int i = 0; i < self.longEventsArray.count; i++)
    {
        NSLog(@"Long events: %f, %f", ((Event *)self.longEventsArray[i]).startTimeUnixTemp, ((Event *)self.longEventsArray[i]).endTimeUnixTemp);
    }
    
    for (int i = 0; i < self.eventsArray.count; i++)
    {
        NSLog(@"Events: %f, %f", ((Event *)self.eventsArray[i]).startTimeUnix, ((Event *)self.eventsArray[i]).endTimeUnix);
    }
    
    return true;
}



@end
