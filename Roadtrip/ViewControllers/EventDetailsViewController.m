//
//  EventDetailsViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/19/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventDetailsViewController.h"

#import "UIImageView+AFNetworking.h"


@interface EventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *addressRatingLabel;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[self.activities objectAtIndex:self.index] isKindOfClass:[Event class]]){
        
        Event *event = [self.activities objectAtIndex:self.index];
        self.nameLabel.text = event.name;
        
        [self.nameLabel sizeToFit];
        
        self.descriptionLabel.text = event.eventDescription;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //formatter.dateFormat = @"E MMM d HH:mm Z y";
        formatter.dateFormat = @"yyyy-MM-dd HH:mm Z y";
        
        formatter.dateStyle = NSDateFormatterShortStyle;
        
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        NSString *startDateString = [formatter stringFromDate:event.startDate];
        
        NSString *endDateString = [formatter stringFromDate:event.endDate];
        
        if([startDateString isEqualToString:endDateString]){
            
            [formatter setDateFormat:@"hh:mm a"];
            
            [formatter setAMSymbol:@"AM"];
            
            [formatter setPMSymbol:@"PM"];
            
            NSString *startTimeString = [formatter stringFromDate:event.startDate];
            
            NSString *endTimeString = [formatter stringFromDate:event.endDate];
            
            NSString *startEndTime = [NSString stringWithFormat:@"%@ %@ - %@", startDateString, startTimeString, endTimeString];
            
            self.timeLabel.text = startEndTime;
        }
        else{
            NSString *startEndDate = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
            self.timeLabel.text = startEndDate;
        }
        self.addressRatingLabel.text = event.address;
        
        NSURL *posterURL = [NSURL URLWithString:event.imageUrl];
        
        self.coverImageView.image = nil;
        
        [self.coverImageView setImageWithURL:posterURL];
        
    }
    else{
        Landmark *landmark = [self.activities objectAtIndex:self.index];
        self.nameLabel.text = landmark.name;
        
        [self.nameLabel sizeToFit];

        
        self.timeLabel.text = landmark.address;
        
        
        self.addressRatingLabel.text = [NSString stringWithFormat: @"Rating: %@", landmark.rating];
        
        self.descriptionLabel.text = @"No description available";
        
        NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"200",landmark.photoReference]];
        
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        
        UIImage *image = [UIImage imageWithData:photoData];
        
        self.coverImageView.image = nil;
        
        self.coverImageView.image = image;
        
        
        
    }
    [self.descriptionLabel sizeToFit];
    
    CGFloat maxHeight = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 40.0;
    
    self.scrollView.contentSize = CGSizeMake(self.descriptionLabel.frame.size.width, maxHeight);
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

@end
