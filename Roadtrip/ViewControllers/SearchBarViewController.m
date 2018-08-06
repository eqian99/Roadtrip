//
//  SearchBarViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 8/3/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SearchBarViewController.h"
#import "LocationTableViewController.h"

@interface SearchBarViewController () <CityDelegate, UISearchControllerDelegate>
@property (strong, nonatomic) UISearchController *citySearchController;
@property (strong, nonatomic)NSString *city;
@property (strong, nonatomic)NSString *stateAndCountry;
@property (strong, nonatomic)NSString *latitude;
@property (strong, nonatomic)NSString *longitude;
@property (strong, nonatomic) NSString *photoReference;
@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LocationTableViewController *locationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationTableViewController"];
    self.citySearchController = [[UISearchController alloc]initWithSearchResultsController:locationTableViewController];
    self.citySearchController.searchResultsUpdater = locationTableViewController;
    self.citySearchController.delegate = self;
    UISearchBar *searchBar = self.citySearchController.searchBar;
    [searchBar sizeToFit];
    searchBar.placeholder = @"Search for cities";
    self.navigationItem.titleView = self.citySearchController.searchBar;
    self.citySearchController.hidesNavigationBarDuringPresentation = false;
    self.citySearchController.dimsBackgroundDuringPresentation = true;
    self.definesPresentationContext = true;
    locationTableViewController.cityDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        searchController.searchResultsController.view.hidden = NO;
    });
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    searchController.searchResultsController.view.hidden = NO;
}
- (void)closeViewController:(NSString *)cityString withStateAndCount:(NSString *)stateAndCountry withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude withPhotoReference:(NSString *)photoReference {
    
    self.city = cityString;
    self.stateAndCountry = stateAndCountry;
    self.latitude = latitude;
    self.longitude = longitude;
    self.photoReference = photoReference;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate changeCityText:cityString withStateAndCountry:stateAndCountry withLatitude:latitude withLongitude:longitude withPhotoReference:photoReference];
    
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
