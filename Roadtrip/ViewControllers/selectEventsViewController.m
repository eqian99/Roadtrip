//
//  selectEventsViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "selectEventsViewController.h"
#import "YelpManager.h"
#import "EventCell.h"

@interface selectEventsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation selectEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //[self getMyEvents];
    // Do any additional setup after loading the view.
}
/*
- (void)getMyEvents{
    YelpManager *myManager = [YelpManager new];
    if(self.categories.count == 0){
        NSString *startDate = @"1531872000";
        long endTimeLong = [startDate integerValue] + (60 * 60 * 24);
        //NSString *endDate = [NSString stringWithFormat:@"%ld", endTimeLong];
        NSString *endDate = @"1631872000";
        [myManager getEventswithLatitude:self.latitude withLongitude:self.longitude withUnixStartDate:startDate withUnixEndDate:endDate withCompletion:^(NSArray *eventsDictionary, NSError *error) {
            if(eventsDictionary){
                NSMutableArray *myEvents = [Event eventsWithArray:eventsDictionary];
                self.events = [myEvents copy];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    [cell setEvent:self.events[indexPath.row]];
    Event *myEvent = self.events[indexPath.row];
    NSLog(@"%@", myEvent.address);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

*/

@end
