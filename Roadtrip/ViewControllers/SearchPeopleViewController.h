//
//  SearchPeopleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/25/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchPeopleDelegate

-(void) fetchFriends;

@end

@interface SearchPeopleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *peopleSearchBar;

@property (strong, nonatomic) NSArray *users;

@property (weak, nonatomic) id<SearchPeopleDelegate> searchDelegate;

@end
