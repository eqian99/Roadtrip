//
//  LocationTableViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "LocationTableViewController.h"
#import "GoogleMapsManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTableViewController () <UISearchResultsUpdating>

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.citiesArray.count;

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    
    [[GoogleMapsManager new] autocomplete:searchText withCompletion:^(NSArray *predictionDictionaries, NSError *error) {
       
        if(error) {
            
            NSLog(@"There was an error");
            
        } else {
            
            NSMutableArray *mutableCities = [NSMutableArray new];
            NSMutableArray *mutableSecondaries = [NSMutableArray new];
            NSMutableArray *mutableLatitudes = [NSMutableArray new];
            NSMutableArray *mutableLongitudes = [NSMutableArray new];

            for(NSDictionary *cityDictionary in predictionDictionaries) {
             
                NSDictionary *structured = cityDictionary[@"structured_formatting"];
                
                
                [[GoogleMapsManager new] getPlacesDetailsWithId:cityDictionary[@"place_id"] withCompletion:^(NSDictionary *placeDictionary, NSError *error) {
                   
                    if(error) {
                        
                        NSLog(error.description);
                        
                        
                    } else {
                        
                        NSString *city = placeDictionary[@"name"];
                        
                        NSString *stateAndCountry = structured[@"secondary_text"];
                        
                        NSDictionary *geometryDictionary = placeDictionary[@"geometry"];
                        
                        NSDictionary *locationDictionary = geometryDictionary[@"location"];
                        
                        NSString *latitude = locationDictionary[@"lat"];
                        
                        NSString *longitude = locationDictionary[@"lng"];
                        
                        [mutableLatitudes addObject:latitude];
                        
                        [mutableLongitudes addObject:longitude];
                        
                        [mutableCities addObject: city];
                        
                        [mutableSecondaries addObject:stateAndCountry];
                        
                        self.latitudes = [mutableLatitudes copy];
                        
                        self.longitudes = [mutableLongitudes copy];
                        
                        self.citiesArray = [mutableCities copy];
                        
                        self.secondaryArray = [mutableSecondaries copy];
                        
                        [self.tableView reloadData];

                        
                    }
                    
                }];
                
                
            }
            
            
        }
        
    }];
        
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.citiesArray[indexPath.row];
    
    cell.detailTextLabel.text = self.secondaryArray[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *city = self.citiesArray[indexPath.row];
    
    NSString *stateAndCountry = self.secondaryArray[indexPath.row];
    
    NSString *latitude = self.latitudes[indexPath.row];
    
    NSString *longitude = self.longitudes[indexPath.row];
    
    NSLog(@"city: %@ latitude: %@ longitude: %@", city ,latitude, longitude);
    [self.cityDelegate changeCityText:city withStateAndCountry:stateAndCountry withLatitude:latitude withLongitude:longitude];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
