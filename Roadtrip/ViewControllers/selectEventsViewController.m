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

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate, EventCellDelegate>
@property (nonatomic, strong) NSMutableArray *events;

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *events;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *cellsSelected;

@property (assign, nonatomic) int previousWarningCellIndex;

@property (assign, nonatomic) int landmarksCount;

@property (strong, nonatomic) NSMutableArray *eventsArray;

@property (strong, nonatomic) NSMutableArray *longEventsArray;

@property (strong, nonatomic) NSMutableArray *landmarksArray;

@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Change navigation item
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", self.city, self.stateAndCountry];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //[self getMyEvents];
    self.cellsSelected = [NSMutableArray new];
    
    self.events = [NSMutableArray new];
    
    [self getEventsFromEventbrite];
   
    
    
    // let nil be the state indicating there is no previous cell with warning
    self.previousWarningCellIndex = nil;
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
    
    NSLog(@"Coordinates: %f , %f", self.latitude, self.longitude);
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
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
    
    for(int i = 0; i < self.events.count; i++) {
        
        if([[self.cellsSelected objectAtIndex:i] isEqual:@YES]) {
            
            Event *event = [self.events objectAtIndex:i];
            
            NSLog(@"Event: %@. Coorindates: %@ , %@", event.name, event.latitude, event.longitude);
            
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
        
        if([[self.cellsSelected objectAtIndex:indexPath.row]isEqual:@YES]){
            
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];

        }
        else{
            
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];

        }
        
        
    }
    
    cell.delegate = self;
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
    
}

- (void)eventCell:(EventCell *)eventCell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
    
    NSLog(@"Index of cell selected: %ld", indexPath.row);
    
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
    // disable warning sign after another click
    if (self.previousWarningCellIndex) {
        
        NSLog(@"Should disable");
        
        // [((EventCell *)[tableView cellForRowAtIndexPath:self.previousWarningCellIndex]) setHidden: YES];
        
        self.previousWarningCellIndex = nil;
        
    }
    
    if(self.cellsSelected.count > 0) {
        
        if([self.cellsSelected[indexPath.row] isEqual:@NO]) {
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
            // check if there are conflicts
            if ([self checkOverlap])
            {
            
                //display warning label
                [((EventCell *)[tableView cellForRowAtIndexPath:indexPath]).warningLabel setHidden:NO];
                
                self.previousWarningCellIndex = indexPath.row;
                
                [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            }
            
            else
            {
                
                if ([self.events[indexPath.row] isKindOfClass:[Landmark class]])
                {
                    self.landmarksCount += 1;
                }
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
        } else {
            
            if ([self.events[indexPath.row] isKindOfClass:[Landmark class]])
            {
                self.landmarksCount -= 1;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
            
            
        }
        
    } else {
        
        //Uncheck mark
        
        [eventCell.checkBoxButton setImage:[UIImage imageNamed:@"uncheckBox"] forState:UIControlStateNormal];
        
        [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
        
        
    }
    
    
    NSLog(@"Event selected from selectEventsViewController");
    
    
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
        return nil;
    }
    
    // add the free time before start of first event
    double start = self.startOfDayUnix;
    
    double end = ((Event *)shortEventsArray[0]).startTimeUnix;
    
    double duration = ((Event *)shortEventsArray[0]).startTimeUnix - self.startOfDayUnix;
    
    while (duration > 7200)
    {
        duration = duration - 7200;
        
        end = start + 7200;

        NSArray *startElement = [NSArray arrayWithObjects: [NSNumber numberWithDouble:7200], [NSNumber numberWithDouble:start], [NSNumber numberWithDouble:end], nil];
        
        [freeBlocks addObject: startElement];
        
        start = end;
        
    }

    
    for(int i = 0; i < shortEventsArray.count - 1; i++) {
        
        if (((Event *)shortEventsArray[i]).endTimeUnix > ((Event *)shortEventsArray[i+1]).startTimeUnix) {
            
            double start = ((Event *)shortEventsArray[i]).endTimeUnix;
            
            double end = ((Event *)shortEventsArray[i+1]).startTimeUnix;
            
            double duration = ((Event *)shortEventsArray[i+1]).startTimeUnix - ((Event *)shortEventsArray[i]).endTimeUnix;
            
            while (duration > 7200)
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
    
    while (duration > 7200)
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
- (BOOL) checkOverlap {
    
    self.eventsArray = [NSMutableArray new];
    
    self.longEventsArray = [NSMutableArray new];
    
    self.landmarksArray = [NSMutableArray new];
    
    for(int i = 0; i < self.events.count; i++){
        
        if([self.cellsSelected[i] isEqual:@YES]){
            
            if ([self.events[i] isKindOfClass:[Event class]])
            {
                if (((Event *) self.events[i]).isFlexible)
                {
                    [self.longEventsArray addObject:self.events[i]];
                }
                else
                {
                    [self.eventsArray addObject:self.events[i]];
                }
            }
            
            else if ([self.events[i] isKindOfClass:[Landmark class]])
            {
                [self.landmarksArray addObject:self.events[i]];
            }
        }
    }

    // sort the events selected
    self.eventsArray = [NSMutableArray arrayWithArray: [Event sortEventArrayByEndDate:self.eventsArray]];
    
    // get all free blocks
    NSMutableArray *freeBlocks = [self getFreeBlocks:self.eventsArray];
    
    /* label the free blocks
     * 0 means not free
     * 1 means free for 2 or more hours
     */
    NSMutableArray *freeBlocksLabeled = [[NSMutableArray alloc] init];
    int count = 0;

    // check if the blocks are greater than one hour
    for (int i = 0; i < freeBlocks.count; i++)
    {
        if ([freeBlocks[i][0] intValue] > 7200)
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
        return true;
    }
    
    for(int i = 0; i < self.eventsArray.count - 1; i++) {
        
        if (((Event *)self.eventsArray[i]).endTimeUnix > ((Event *)self.eventsArray[i+1]).startTimeUnix) {
            
            return true;
            
        };
        
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
            }
        }
    }
    
    for (int i = 0; i < self.landmarksArray.count; i++)
    {
        NSLog(@"%f, %f", ((Event *)self.landmarksArray[i]).startTimeUnixTemp, ((Event *)self.landmarksArray[i]).endTimeUnixTemp);
    }
    
    for (int i = 0; i < self.longEventsArray.count; i++)
    {
        NSLog(@"%f, %f", ((Event *)self.longEventsArray[i]).startTimeUnixTemp, ((Event *)self.longEventsArray[i]).endTimeUnixTemp);
    }
    
    for (int i = 0; i < self.eventsArray.count; i++)
    {
        NSLog(@"%f, %f", ((Event *)self.eventsArray[i]).startTimeUnix, ((Event *)self.eventsArray[i]).endTimeUnix);
    }
    
    return false;
}





@end
