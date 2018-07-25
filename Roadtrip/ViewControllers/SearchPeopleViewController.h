//
//  SearchPeopleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/25/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPeopleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *peopleSearchBar;



@property (strong, nonatomic) NSArray *users;


@end
