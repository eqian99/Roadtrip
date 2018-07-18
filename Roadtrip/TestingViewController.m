//
//  TestingViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "TestingViewController.h"
#import "YelpManager.h"
#import "Event.h"

@interface TestingViewController ()

@end

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *categoriesArray = @[@"music", @"fashion"];
    /*
    [[YelpManager new] getEventsWithCategories:categoriesArray withLatitude:37.773972 withLongitude:-122.431297 withUnixStartDate:@"1531775681" withUnixEndDate:@"1546304461" withCompletion:^(NSDictionary *eventsDictionary, NSError *error) {
       
        
        if(error != nil) {
            
            NSLog(@"Error");
            
        } else {
            
            
            NSLog(@"%@", eventsDictionary);
            
        }
        
        
    }];
     */
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
