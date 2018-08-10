
#import "ScheduleDetailViewController.h"
#import "EventDetailsViewController.h"
#import "ScheduleMembersViewController.h"
#import "ScheduleEventCell.h"
#import "Parse.h"
#import "RestaurantChooserViewController.h"
#import "Landmark.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "EventCollectionCell.h"
#import "MemberCollectionCell.h"
@interface ScheduleDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eventsCollectionView.delegate = self;
    self.eventsCollectionView.dataSource = self;
    
    self.membersCollectionView.delegate = self;
    self.membersCollectionView.dataSource = self;
    
    self.podEvents = [NSMutableArray new];
    self.selectedView = 0;
    
    self.cityLabel.text = self.schedule.name;
    [self.cityLabel sizeToFit];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocalizedDateFormatFromTemplate:@"MMMMd"];
    NSLog(@"%@", [formatter stringFromDate:self.schedule.createdDate]);
    self.dateLabel.text = [formatter stringFromDate:self.schedule.scheduleDate];
    
    [self.dateLabel sizeToFit];
    
    
    NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"500",self.schedule.photoReference]];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:photoData];
    self.scheduleCoverImage.image = nil;
    self.scheduleCoverImage.image = image;
    
    [self.scheduleView setDaysToShow:1];
    self.scheduleView.weekFlowLayout.show24Hours = YES;
    self.scheduleView.daysToShowOnScreen = 1;
    self.scheduleView.daysToShow = 0;
    self.scheduleViewRect = self.scheduleView.frame;
    
    self.events = [NSMutableArray new];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithTitle:@"Members" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareButton)];
    [self.navigationItem setRightBarButtonItem:customBtn];
    
    [self getEventsFromSchedule];
    [self fetchMembersOfSchedule];
}
-(void) didClickShareButton {
    [self performSegueWithIdentifier:@"shareScheduleSegue" sender:self];
}
-(void) getEventsFromSchedule {
    PFRelation *eventsRelation = self.schedule.eventsRelation;
    PFQuery *eventsQuery = [eventsRelation query];
    [eventsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting events from schedule");
        } else {
            NSLog(@"Successfully fetched events from schedule");
            for(PFObject *activity in objects) {
                NSString *name = [activity valueForKey:@"name"];
                NSLog(@"%@" , name);
                if([[activity valueForKey:@"isLandmark"] boolValue]) {
                    Landmark *landmark = [Landmark new];
                    landmark.placeId = [activity valueForKey:@"eventId"];
                    landmark.name = name;
                    landmark.photoReference = [activity valueForKey:@"photoReference"];
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    landmark.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    landmark.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    landmark.address = [activity valueForKey:@"address"];
                    landmark.rating = [activity valueForKey:@"rating"];
                    [self.events addObject:landmark];
                    MSEvent *landmarkEvent = [MSEvent make:startDate end:endDate title:name subtitle:landmark.address];
                    [self.podEvents addObject:landmarkEvent];
                } else if([[activity valueForKey:@"isMeal"] boolValue]){
                    Event *meal = [Event new];
                    meal.name = name;
                    meal.eventDescription = [activity valueForKey:@"eventDescription"];
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    meal.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    meal.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    meal.isMeal = true;
                    [self.events addObject:meal];
                    MSEvent *mealEvent = [MSEvent make:startDate end:endDate title:name subtitle:@"Restaurant"];
                    [self.podEvents addObject:mealEvent];
                } else {
                    
                    Event *event = [Event new];
                    event.name = name;
                    event.eventDescription = [activity valueForKey:@"eventDescription"];
                    event.photoReference = [activity valueForKey:@"photoReference"];
                    event.imageUrl = [activity valueForKey:@"photoReference"];
                    event.eventId = [activity valueForKey:@"eventId"];
                    event.venueId = [activity valueForKey:@"valueId"];
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    event.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    event.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    event.address = [activity valueForKey:@"address"];
                    [self.events addObject:event];
                    MSEvent *msEvent = [MSEvent make:startDate end:endDate title:name subtitle: event.address];
                    [self.podEvents addObject:msEvent];
                    
                }
            }
            
            [self.eventsCollectionView reloadData];
            self.scheduleView.daysToShowOnScreen = 1;
            self.scheduleView.daysToShow = 0;
            NSArray *eventsForScheduleView = [self.podEvents copy];
            NSLog(@"Event #: %lu", eventsForScheduleView.count);
            self.scheduleView.events = eventsForScheduleView;
        }

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchMembersOfSchedule {
    PFQuery *membersQuery = [self.schedule.membersRelation query];
    [membersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching members of schedule");
        } else {
            self.members = objects;
            [self.membersCollectionView reloadData];
        }
    }];
}

- (IBAction)didPressScheduleButton:(id)sender {
    self.selectedView = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect newRect = self.segmentImageView.frame;
        
        newRect.origin.x = self.scheduleButton.frame.origin.x - self.segmentImageView.frame.size.width / 2.5;
        
        self.segmentImageView.frame = newRect;
        
        UIImage *whiteScheduleImage = [UIImage imageNamed:@"scheduleIconWhite"];
        UIImage *blackEventImage = [UIImage imageNamed:@"eventIconBlack"];
        [self.scheduleButton setImage:whiteScheduleImage forState:UIControlStateNormal];
        [self.eventButton setImage:blackEventImage forState:UIControlStateNormal];
        
        
        self.scheduleView.frame = self.scheduleViewRect;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)didPressButtonIcon:(id)sender {
    self.selectedView = 1;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect newRect = self.segmentImageView.frame;
        
        newRect.origin.x = self.eventButton.frame.origin.x - self.segmentImageView.frame.size.width / 2.5;
        
        self.segmentImageView.frame = newRect;
        
        
        UIImage *blackScheduleImage = [UIImage imageNamed:@"scheduleIconBlack"];
        UIImage *whiteEventImage = [UIImage imageNamed:@"eventIconWhite"];
        [self.scheduleButton setImage:blackScheduleImage forState:UIControlStateNormal];
        [self.eventButton setImage:whiteEventImage forState:UIControlStateNormal];
        
        CGRect newScheduleRect = self.scheduleView.frame;
        
        newScheduleRect.origin.x -= self.scheduleViewRect.size.width;
        
        self.scheduleView.frame = newScheduleRect;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"eventDetailSegue"]) {
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.activities = self.events;
        eventDetailsViewController.index = self.indexSelected;
    } else if([[segue identifier] isEqualToString:@"shareScheduleSegue"]){
        ScheduleMembersViewController *viewController = [segue destinationViewController];
        viewController.schedule = self.schedule;
    } else if([[segue identifier] isEqualToString:@"foodSegue"]){
       
        RestaurantChooserViewController *restaurantChooser = [segue destinationViewController];
        restaurantChooser.restaurants = self.restaurants;
//        restaurantChooser.delegate = self;
//        restaurantChooser.index = (int)self.index;
        
    }
}
- (void)weekView:(id)sender eventSelected:(MSEventCell *)eventCell {
    MSEvent *event = eventCell.event;
    for(int i = 0; i < self.events.count; i++){
        if(self.podEvents[i] == event){
            self.indexSelected = i;
        }
    }
    [self performSegueWithIdentifier:@"eventDetailSegue" sender:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.eventsCollectionView){
        return self.events.count;
    }
    return self.members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.eventsCollectionView){
        EventCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
        if([self.events[indexPath.row] isKindOfClass:[Event class]]){
            Event *event = self.events[indexPath.row];
            NSURL *posterURL = [NSURL URLWithString:event.imageUrl];
            [cell.eventImage setImageWithURL:posterURL];
            cell.nameLabel.text = event.name;
            cell.descriptionLabel.text = event.eventDescription;
        } else {
            Landmark *landmark = self.events[indexPath.row];
            NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"500",landmark.photoReference]];
            [cell.eventImage setImageWithURL:photoURL];
            cell.nameLabel.text = landmark.name;
            cell.descriptionLabel.text = @"A beautiful landmark";
        }
        return cell;
    }
    MemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    PFUser *member = self.members[indexPath.row];
    PFFile *image = [member valueForKey:@"profilePic"];
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *profileImage = [UIImage imageWithData:imageData];
        cell.memberProfileImageView.image = profileImage;
    }];
    cell.memberProfileImageView.layer.masksToBounds = YES;
    cell.memberProfileImageView.layer.cornerRadius = cell.memberProfileImageView.frame.size.width / 2;

    return cell;
}

@end
