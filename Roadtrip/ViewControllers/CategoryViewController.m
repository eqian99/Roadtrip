//
//  CategoryViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "CategoryViewController.h"
#import "SelectLocationViewController.h"

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

@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSDictionary *buttonsDict;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categories = [[NSMutableArray alloc] init];
    [self addButtonsToArray];
    [self createButtonsDict];
}

-(void)addButtonsToArray{
    self.buttons = @[self.button_music, self.button_visual_arts, self.button_performing_arts, self.button_film, self.button_lectures_books, self.button_fashion, self.button_food_and_drink, self.button_festivals_fairs, self.button_charities, self.button_sports_active_life, self.button_nightlife, self.button_kids_family, self.button_other];
}


- (void)createButtonsDict{
    self.buttonsDict = @{self.button_music.titleLabel.text : @"music", self.button_visual_arts.titleLabel.text : @"visual-arts", self.button_performing_arts.titleLabel.text : @"performing-arts", self.button_film.titleLabel.text : @"film", self.button_lectures_books.titleLabel.text : @"lectures-books", self.button_fashion.titleLabel.text : @"fashion", self.button_food_and_drink.titleLabel.text : @"food-and-drink", self.button_festivals_fairs.titleLabel.text : @"festivals-fairs", self.button_charities.titleLabel.text : @"charities", self.button_sports_active_life.titleLabel.text : @"sports-active-life", self.button_nightlife.titleLabel.text : @"nightlife", self.button_kids_family.titleLabel.text : @"kids-family", self.button_other.titleLabel.text : @"other"};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedDone:(id)sender {
    for(UIButton *button in self.buttons){
        if(button.selected == YES){
            [self.categories addObject:self.buttonsDict[button.titleLabel.text]];
        }
    }
    [self performSegueWithIdentifier:@"LocationSegue" sender:nil];
}


- (IBAction)clicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
}

    


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SelectLocationViewController *selectLocationViewController = [segue destinationViewController];
    selectLocationViewController.categories = self.categories;
}




@end
