//
//  RestaurantChooserViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/31/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "RestaurantChooserViewController.h"
#import "RestaurantChooserView.h"
@interface RestaurantChooserViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int width;
@end

@implementation RestaurantChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.width = self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(self.width * self.restaurants.count, 568);
    /*
    for(NSDictionary *restaurant in self.restaurants){
        NSLog(@"%@", restaurant);
    }
     */
    CGRect frame;
    frame.origin.x = 0;
    frame.size = self.scrollView.frame.size;
    //UIView *myView = [[UIView alloc] initWithFrame:frame];
    //myView.backgroundColor = [UIColor redColor];
    for(int i = 0; i < self.restaurants.count; i++){
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake((i * self.width) / 2, 0, self.width, 500)];
        UILabel *myLabel = [[UILabel alloc] initWithFrame: CGRectMake((i * self.width) / 2 + 20, 20, 200, 200)];
        myLabel.text = self.restaurants[i][@"name"];
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 40, 600, 200)];
        myLabel.text = self.restaurants[i][@"name"];
        NSDictionary *location = self.restaurants[i][@"location"];
        NSArray *addressArray = location[@"display_address"];
        NSString *addressString = @"";
        for(NSString *addressPart in addressArray){
            addressString = [addressString stringByAppendingString:[NSString stringWithFormat:@"%@", addressPart]];
        }
        NSLog(@"%@", addressString);
        address.text = [addressString substringToIndex:[addressString length] - 1];
        
        [myView addSubview:myLabel];
        [myView addSubview:address];
        [self.scrollView addSubview:myView];
        //self.myView.nameLabel.text = [NSString stringWithFormat:@"Page:%i ", page];
        
        [self.scrollView addSubview:myView];
    }
    /*
    UILabel *myLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, 400, 200)];
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 600, 200)];
    myLabel.text = self.restaurants[0][@"name"];
    NSDictionary *location = self.restaurants[0][@"location"];
    NSArray *addressArray = location[@"display_address"];
    address.text = addressArray[0];
    [myView addSubview:myLabel];
    [myView addSubview:address];
    [self.scrollView addSubview:myView];
     */
    self.pageControl.numberOfPages = self.restaurants.count;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //RestaurantChooserView *restaurantChoice = [RestaurantChooserView new];
    
    int page = (int)(scrollView.contentOffset.x / self.width);
    self.pageControl.currentPage = page;
    //NSLog(@"%i", page);
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
