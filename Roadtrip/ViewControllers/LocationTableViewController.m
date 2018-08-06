//
//  LocationTableViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "LocationTableViewController.h"
#import "GoogleMapsManager.h"
#import "Parse.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *locationTableView;

@end

@implementation LocationTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
//    [self getRecentSearches];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getRecentSearches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getRecentSearches {
    PFUser *currUser = [PFUser currentUser];
    NSArray *places = [currUser valueForKey:@"myCitiesSearched"];
    
    if(places != nil){
        
        self.recentSearchesArray = places;
        
        [self.locationTableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.citiesArray.count != 0) {
        
        return self.citiesArray.count;
        
    } else {
        
        return self.recentSearchesArray.count;
        
    }
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //NSString *searchText = searchController.searchBar.text;

    NSLog(@"Update search results");
    
    self.searchText = searchController.searchBar.text;
    
    if([self.searchText isEqualToString:@""]) {

        
        [self.locationTableView reloadData];
        
    } else {
        
        [[GoogleMapsManager new] autocomplete:self.searchText withCompletion:^(NSArray *predictionDictionaries, NSError *error) {
            
            if(error) {
                
                NSLog(@"There was an error");
                
            } else {
                
                NSMutableArray *mutableCities = [NSMutableArray new];
                
                NSMutableArray *mutableSecondaries = [NSMutableArray new];
                
                NSMutableArray *mutableLatitudes = [NSMutableArray new];
                
                NSMutableArray *mutableLongitudes = [NSMutableArray new];
                
                NSMutableArray *mutablePhotoReferences = [NSMutableArray new];
                
                for(NSDictionary *cityDictionary in predictionDictionaries) {
                    
                    NSDictionary *structured = cityDictionary[@"structured_formatting"];
                    
                    [[GoogleMapsManager new] getPlacesDetailsWithId:cityDictionary[@"place_id"] withCompletion:^(NSDictionary *placeDictionary, NSError *error) {
                        
                        if(error) {
                            
                            NSLog(@"%@", error.description);
                            
                            
                        } else {
                            
                            NSArray *photosDictionaries = placeDictionary[@"photos"];
                            NSDictionary *photoDictionary = photosDictionaries[0];
                            NSString *photoReference = photoDictionary[@"photo_reference"];
                            NSString *city = placeDictionary[@"name"];
                            NSString *stateAndCountry = structured[@"secondary_text"];
                            NSDictionary *geometryDictionary = placeDictionary[@"geometry"];
                            NSDictionary *locationDictionary = geometryDictionary[@"location"];
                            NSString *latitude = locationDictionary[@"lat"];
                            NSString *longitude = locationDictionary[@"lng"];
                            
                            if(!photoReference) {
                                NSLog(@"%@ doesn't have a picture", city);
                                [mutablePhotoReferences addObject: @"null"];
                            } else {
                                [mutablePhotoReferences addObject: photoReference];
                            }
                            [mutableLatitudes addObject:latitude];
                            [mutableLongitudes addObject:longitude];
                            [mutableCities addObject: city];
                            [mutableSecondaries addObject:stateAndCountry];
                            
                            self.photoReferences = [mutablePhotoReferences copy];
                            self.latitudes = [mutableLatitudes copy];
                            self.longitudes = [mutableLongitudes copy];
                            self.citiesArray = [mutableCities copy];
                            self.secondaryArray = [mutableSecondaries copy];
                            [self.locationTableView reloadData];
                            
                        }
                        
                    }];
                    
                }
                
            }
            
        }];
        
    }
    
    
        
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    if([self.searchText isEqualToString:@""]) {
        
        if(indexPath.row < self.recentSearchesArray.count){
            
            PFObject *parseCity = self.recentSearchesArray[indexPath.row];
            if(parseCity != nil){
                [parseCity fetchIfNeeded];
                
                cell.textLabel.text = parseCity[@"name"];
                cell.detailTextLabel.text = parseCity[@"stateAndCountry"];
            }
             
        }
        else{
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
         
    } else {
     
        cell.textLabel.text = self.citiesArray[indexPath.row];
        
        cell.detailTextLabel.text = self.secondaryArray[indexPath.row];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.searchText isEqualToString:@""]){
        PFObject * parseCity = self.recentSearchesArray[indexPath.row];
        [parseCity fetchIfNeeded];
        NSString *city = parseCity[@"name"];
        NSString *stateAndCountry = parseCity[@"stateAndCountry"];
        NSString *latitude = parseCity[@"latitude"];
        NSString *longitude = parseCity[@"longitude"];
        NSString *photoReference = parseCity[@"photoReference"];
        NSLog(@"city: %@ latitude: %@ longitude: %@", city ,latitude, longitude);
        [self.cityDelegate closeViewController:city withStateAndCount:stateAndCountry withLatitude:latitude withLongitude:longitude withPhotoReference:photoReference];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else{
        NSString *city = self.citiesArray[indexPath.row];
        NSString *stateAndCountry = self.secondaryArray[indexPath.row];
        NSString *latitude = self.latitudes[indexPath.row];
        NSString *longitude = self.longitudes[indexPath.row];
        NSString *photoReference = self.photoReferences[indexPath.row];
        
        NSLog(@"city: %@ latitude: %@ longitude: %@", city ,latitude, longitude);
        
        [self.cityDelegate closeViewController:city withStateAndCount:stateAndCountry withLatitude:latitude withLongitude:longitude withPhotoReference:photoReference];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
