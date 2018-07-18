//
//  SelectLandmarksViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectLandmarksViewController.h"


@interface SelectLandmarksViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *landmarks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectLandmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

/*
>>>>>>> Stashed changes
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.landmarks.count;
}
 
 */

@end
