//
//  SchedulesViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/26/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedulesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *schedulesTableView;
@property (strong, nonatomic) NSMutableArray *schedules;


@end
