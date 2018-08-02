//
//  RestaurantChooserViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/31/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "RestaurantChooserViewController.h"
#import "RestaurantChooserView.h"
#import "UIImageView+AFNetworking.h"

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
    self.scrollView.directionalLockEnabled = YES;
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
    NSLog(@"%@", self.restaurants);
    for(int i = 0; i < self.restaurants.count; i++){
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake((i * self.width) / 2, 0, self.width, 500)];
        UILabel *myLabel = [[UILabel alloc] initWithFrame: CGRectMake((i * self.width) / 2 + 20, 180, 200, 200)];
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 200, 600, 200)];
        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 220, 200, 200)];
        UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 240, 200, 200)];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 260, 200, 200)];
        UIImageView *foodPic = [[UIImageView alloc] initWithFrame:CGRectMake((i * self.width) / 2, 0, self.width, 250)];
        [foodPic setContentMode:UIViewContentModeScaleAspectFill];
        [foodPic setClipsToBounds:YES];
        
        // add restaurant name
        myLabel.text = self.restaurants[i][@"name"];
        myLabel.text = self.restaurants[i][@"name"];
        
        // add restaurant address
        NSDictionary *location = self.restaurants[i][@"location"];
        NSArray *addressArray = location[@"display_address"];
        NSString *addressString = @"";
        for(NSString *addressPart in addressArray){
            addressString = [addressString stringByAppendingString:[NSString stringWithFormat:@"%@ ", addressPart]];
        }
        address.text = [addressString substringToIndex:[addressString length] - 1];
        
        // add image for restaurant
        NSURL *posterURL = [NSURL URLWithString:self.restaurants[i][@"image_url"]];
        foodPic.image = nil;
        [foodPic setImageWithURL:posterURL];
        
        rating.text = [NSString stringWithFormat:@"Rating: %@", self.restaurants[i][@"rating"]];
        
        phoneNum.text = self.restaurants[i][@"display_phone"];
        
        price.text = self.restaurants[i][@"price"];
        
        [myView addSubview:myLabel];
        [myView addSubview:address];
        [myView addSubview:foodPic];
        [myView addSubview:rating];
        [myView addSubview:phoneNum];
        [myView addSubview:price];
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

- (void)createAlert:(NSString *)errorMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
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
- (IBAction)didPressSave:(id)sender {
    [self createAlert:@"Your restaurant has been saved to your schedule!"];
    NSString *name = self.restaurants[self.pageControl.currentPage][@"name"];
    [self.delegate didSave:self.index withName:name];
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
