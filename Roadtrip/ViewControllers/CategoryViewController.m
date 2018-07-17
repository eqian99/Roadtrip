//
//  CategoryViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button_music;
@property (weak, nonatomic) IBOutlet UIButton *button_visual_arts;
@property (weak, nonatomic) IBOutlet UIButton *button_performing_arts;
@property (weak, nonatomic) IBOutlet UIButton *button_film;
@property (weak, nonatomic) IBOutlet UIButton *button_lectures_books;
@property (weak, nonatomic) IBOutlet UIButton *button_fashion;
@property (weak, nonatomic) IBOutlet UIButton *button_food_and_drink;
@property (weak, nonatomic) IBOutlet UIButton *button_festivals_fairs;
@property (weak, nonatomic) IBOutlet UIButton *button_charities;
@property (weak, nonatomic) IBOutlet UIButton *button_sports_active_life;
@property (weak, nonatomic) IBOutlet UIButton *button_nightlife;
@property (weak, nonatomic) IBOutlet UIButton *button_kids_family;
@property (weak, nonatomic) IBOutlet UIButton *button_other;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
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
