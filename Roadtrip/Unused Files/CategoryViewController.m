//
//  CategoryViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "CategoryViewController.h"
#import "selectEventsViewController.h"
#import "SelectLandmarksViewController.h"

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button_music;
@property (weak, nonatomic) IBOutlet UIButton *button_visual_arts;
@property (weak, nonatomic) IBOutlet UIButton *button_performing_arts;
@property (weak, nonatomic) IBOutlet UIButton *button_lectures_books;
@property (weak, nonatomic) IBOutlet UIButton *button_food_and_drink;
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
    [self addButtonsToArray];
    [self createButtonsDict];
}
-(void)viewWillAppear:(BOOL)animated{
    self.categories = [[NSMutableArray alloc] init];
    [self.categories removeAllObjects];
}

-(void)addButtonsToArray{
    self.buttons = @[self.button_music, self.button_visual_arts, self.button_performing_arts, self.button_lectures_books, self.button_food_and_drink, self.button_sports_active_life, self.button_nightlife, self.button_kids_family, self.button_other];
}


- (void)createButtonsDict{
    self.buttonsDict = @{self.button_music.titleLabel.text : @"music", self.button_visual_arts.titleLabel.text : @"visual-arts", self.button_performing_arts.titleLabel.text : @"performing-arts", self.button_lectures_books.titleLabel.text : @"lectures-books", self.button_food_and_drink.titleLabel.text : @"food-and-drink", self.button_sports_active_life.titleLabel.text : @"sports-active-life", self.button_nightlife.titleLabel.text : @"nightlife", self.button_kids_family.titleLabel.text : @"kids-family", self.button_other.titleLabel.text : @"other"};
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
    [self performSegueWithIdentifier:@"EventsChooserSegue" sender:nil];
}


- (IBAction)clicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
}

- (IBAction)clickedDontWantEvents:(id)sender {
    
    
    [self performSegueWithIdentifier:@"skipEventsSegue" sender:nil];

}


    


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"EventsChooserSegue"]){
     
        selectEventsViewController *selectEventsViewController = [segue destinationViewController];
        selectEventsViewController.categories = self.categories;
        selectEventsViewController.latitude = self.latitude;
        selectEventsViewController.longitude = self.longitude;
        //Pass over data about the start time
        selectEventsViewController.startOfDayUnix = self.startOfDayUnix;
        selectEventsViewController.endOfDayUnix = self.endOfDayUnix;
        
        
    } else if ([segue.identifier isEqualToString:@"skipEventsSegue"]){
        
        SelectLandmarksViewController *landmarksViewController = [segue destinationViewController];
        
        landmarksViewController.latitude = self.latitude;
        landmarksViewController.longitude = self.longitude;
        
        
    }
}




@end
