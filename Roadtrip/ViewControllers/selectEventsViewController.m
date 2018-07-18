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
    if(self.categories.count == 0){
        [myManager getEventswithLatitude:self.latitude withLongitude:self.longitude withUnixStartDate:startDate withUnixEndDate:endDate withCompletion:^(NSArray *eventsDictionary, NSError *error) {
            if(eventsDictionary){
                NSMutableArray *myEvents = [Event eventsWithArray:eventsDictionary];
                NSLog(@"%@", eventsDictionary);
                self.events = [myEvents copy];
                
                for(int i = 0; i < self.events.count; i++) {
                    
                    [self.cellsSelected addObject: @NO];
                    
                }
                [self.tableView reloadData];
            }
            else{
                NSLog(@"There was an error");
            }
        }];
    }
    else{
        [myManager getEventsWithCategories:self.categories withLatitude:self.latitude withLongitude:self.longitude withUnixStartDate:startDate withUnixEndDate:endDate withCompletion:^(NSArray *eventsDictionary, NSError *error) {
            if(eventsDictionary){
                NSMutableArray *myEvents = [Event eventsWithArray:eventsDictionary];
                NSLog(@"%@", eventsDictionary);
                self.events = [myEvents copy];
                for(int i = 0; i < self.events.count; i++) {
                    
                    [self.cellsSelected addObject: @NO];
                    
                }
                [self.tableView reloadData];
            }
            else{
                NSLog(@"There was an error");
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didClickedDone:(id)sender {
    
    [self performSegueWithIdentifier:@"landmarksSelectionSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    SelectLandmarksViewController *selectLandmarksViewController = [segue destinationViewController];
    
    selectLandmarksViewController.latitude = self.latitude;

    selectLandmarksViewController.longitude = self.longitude;

    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    [cell setEvent:self.events[indexPath.row]];
    
    Event *myEvent = self.events[indexPath.row];
    
    NSLog(@"%@", myEvent.address);
    
    
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
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@YES];
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.cellsSelected replaceObjectAtIndex:indexPath.row withObject:@NO];
            
            
        }
        
    }
    
    

}



@end
