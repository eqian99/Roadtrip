//
//  ScheduleViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

// Set an array of all free blocks given an array of scheduled events
- (NSMutableArray *) getFreeBlocks {
    
    NSMutableArray *freeBlocks = [[NSMutableArray alloc] init];
    
    // add the free time before start of first event
    [freeBlocks addObject: [NSNumber numberWithFloat:
                [((Event *)self.eventsSelected[0]).startDate timeIntervalSince1970] - self.startOfDayUnix]];
    
    for(int i = 0; i < self.eventsSelected.count - 1; i++) {
        
        if (((Event *)self.eventsSelected[i]).endTimeUnix > ((Event *)self.eventsSelected[i+1]).startTimeUnix) {
            
            // add free time between all time intervals
            [freeBlocks addObject: [NSNumber numberWithFloat: ((Event *)self.eventsSelected[i+1]).startTimeUnix - ((Event *)self.eventsSelected[i]).endTimeUnix]];
            
        };
        
    }
    
    return freeBlocks;
    
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

@end
