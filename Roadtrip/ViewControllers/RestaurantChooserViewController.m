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
        UILabel *myLabel = [[UILabel alloc] initWithFrame: CGRectMake((i * self.width) / 2 + 40, 165, self.width - 65, 200)];
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 40, 220, self.width - 65, 200)];
        UILabel *phoneNum = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 40, 250, 200, 200)];
        UILabel *ratingTitle = [[UILabel alloc]initWithFrame:CGRectMake((i * self.width) / 2 + 60, 350, 200, 200)];
        UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 60, 390, 230, 200)];
        UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 250, 350, 200, 200)];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 250, 390, 260, 200)];
        UIImageView *foodPic = [[UIImageView alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 30, 30, self.width - 60, 200)];
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 20, 20, self.width - 40, 520)];
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 25, 420, self.width - 50, 2)];
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake((i * self.width) / 2 + 180, 420, 2, 115)];
        [foodPic setContentMode:UIViewContentModeScaleAspectFill];
        [foodPic setClipsToBounds:YES];
        
        // add restaurant name
        myLabel.text = self.restaurants[i][@"name"];
        [myLabel setFont:[UIFont boldSystemFontOfSize:30]];
        myLabel.numberOfLines = 0;
        
        // add restaurant address
        NSDictionary *location = self.restaurants[i][@"location"];
        NSArray *addressArray = location[@"display_address"];
        NSString *addressString = @"";
        for(NSString *addressPart in addressArray){
            addressString = [addressString stringByAppendingString:[NSString stringWithFormat:@"%@ ", addressPart]];
        }
        address.text = [addressString substringToIndex:[addressString length] - 1];
        [address setFont:[UIFont systemFontOfSize:17]];
        address.numberOfLines = 0;
        // add image for restaurant
        NSURL *posterURL = [NSURL URLWithString:self.restaurants[i][@"image_url"]];
        foodPic.image = nil;
        [foodPic setImageWithURL:posterURL];
        
        ratingTitle.text = @"Rating";
        rating.text = [NSString stringWithFormat:@"%@", self.restaurants[i][@"rating"]];
        [rating setFont:[UIFont systemFontOfSize:30]];
        
        phoneNum.text = self.restaurants[i][@"display_phone"];
        [phoneNum setFont:[UIFont systemFontOfSize:17]];
        
        priceTitle.text = @"Price";
        price.text = self.restaurants[i][@"price"];
        [price setFont:[UIFont systemFontOfSize:30]];
        
        UIImage *myImage = [UIImage imageNamed:@"RestaurantsShadow"];
        [background setImage:myImage];
        
        [horizontalLine setBackgroundColor:[UIColor grayColor]];
        
        [verticalLine setBackgroundColor:[UIColor grayColor]];
        
        [myView addSubview:background];
        [myView addSubview:ratingTitle];
        [myView addSubview:myLabel];
        [myView addSubview:address];
        [myView addSubview:foodPic];
        [myView addSubview:rating];
        [myView addSubview:phoneNum];
        [myView addSubview:priceTitle];
        [myView addSubview:horizontalLine];
        [myView addSubview:verticalLine];
        [myView addSubview:price];
        [self.scrollView addSubview:myView];
        //self.myView.nameLabel.text = [NSString stringWithFormat:@"Page:%i ", page];
        
        [self.scrollView addSubview:myView];
    }
    
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
- (IBAction)didPressSave:(id)sender {
    NSString *name = self.restaurants[self.pageControl.currentPage][@"name"];
    NSDictionary *location = self.restaurants[self.pageControl.currentPage][@"location"];
    NSArray *addressArray = location[@"display_address"];
    NSString *addressString = @"";
    for(NSString *addressPart in addressArray){
        addressString = [addressString stringByAppendingString:[NSString stringWithFormat:@"%@ ", addressPart]];
    }
    addressString = [addressString substringToIndex:[addressString length] - 1];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate didSave:self.index withName:name withAddress:addressString];

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
