//
//  EventCell.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEvent:(Event *)event{
    [self.warningLabel setHidden:YES];
    _event = event;
    self.nameLabel.text = event.name;
    self.addressLabel.text = @"";


    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"E MMM d HH:mm Z y";
    formatter.dateFormat = @"yyyy-MM-dd HH:mm Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    if(event.startDate == nil){
        self.startEndLabel.text = @"";
    }
    else{
        NSString *startDateString = [formatter stringFromDate:event.startDate];
        NSString *endDateString = [formatter stringFromDate:event.endDate];
        if([startDateString isEqualToString:endDateString]){
            [formatter setDateFormat:@"hh:mm a"];
            [formatter setAMSymbol:@"AM"];
            [formatter setPMSymbol:@"PM"];
            NSString *startTimeString = [formatter stringFromDate:event.startDate];
            NSString *endTimeString = [formatter stringFromDate:event.endDate];
            NSString *startEndTime = [NSString stringWithFormat:@"%@ %@ - %@", startDateString, startTimeString, endTimeString];
            self.startEndLabel.text = startEndTime;
        }
        else{
            NSString *startEndDate = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
            [formatter setDateFormat:@"hh:mm a"];
            [formatter setAMSymbol:@"AM"];
            [formatter setPMSymbol:@"PM"];
            NSString *startTimeString = [formatter stringFromDate:event.startDate];
            NSString *endTimeString = [formatter stringFromDate:event.endDate];
            NSString *startEndTime = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
            self.startEndLabel.text = [NSString stringWithFormat:@"%@ %@", startEndDate, startEndTime];
        }
    }
    NSURL *posterURL = [NSURL URLWithString:event.imageUrl];
    
    // clear out the cell so that there is no flickering
    if(!event.isGoogleEvent){
        [UIView animateWithDuration:0.3 animations:^{
            self.posterView.alpha = 1.0;
        }];
        self.imageAnimation.duration = 0.5;
        self.imageAnimation.delay    = 0.5;
        self.imageAnimation.type     = CSAnimationTypeFadeIn;
        [self.imageAnimation startCanvasAnimation];
        self.posterView.image = nil;
        [self.posterView setImageWithURL:posterURL];
        
        self.posterView.layer.cornerRadius = 10;
        self.posterView.clipsToBounds = YES;
    }
    else{
        // Load image on a non-ui-blocking thread
        
        self.imageAnimation.duration = 0.5;
        self.imageAnimation.delay    = 0;
        self.imageAnimation.type     = CSAnimationTypeFadeIn;
        [self.imageAnimation startCanvasAnimation];
        NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"300",event.photoReference]];
        
        //NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        
        //UIImage *image = [UIImage imageWithData:photoData];
        
        [self.posterView setImageWithURL: photoURL];

    }
    //self.addressLabel.text = event.address;
}
- (IBAction)didSelect:(id)sender {
    
    
    [self.delegate eventCell:self];
    
}

-(void)setLandmark:(Landmark *)landmark{
    [self.warningLabel setHidden:YES];
    _landmark = landmark;
    
    self.nameLabel.text = landmark.name;
    
    self.addressLabel.text = landmark.address;

    self.startEndLabel.text = @"";
    //NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"200",landmark.photoReference]];
    
    //NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    //UIImage *image = [UIImage imageWithData:photoData];
    //self.posterView.image = nil;
    //self.posterView.image = image;
    self.imageAnimation.duration = 0.5;
    self.imageAnimation.delay    = 0.2;
    self.imageAnimation.type     = CSAnimationTypeFadeIn;
    [self.imageAnimation startCanvasAnimation];
    NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc",@"300",landmark.photoReference]];
    
    //NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    //UIImage *image = [UIImage imageWithData:photoData];
    
    [self.posterView setImageWithURL: photoURL];
}
@end
