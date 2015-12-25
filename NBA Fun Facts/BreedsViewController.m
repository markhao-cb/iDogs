//
//  BreedsViewController.m
//  iDogs
//
//  Created by Yu Qi Hao on 11/24/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "BreedsViewController.h"
#import "AppDelegate.h"
#import "Breeds.h"
#import "BreedsTableViewCell.h"
#import "BreedDetailsViewController.h"


@interface BreedsViewController () {
    NSMutableDictionary *_allBreeds;
    NSArray *keys;
}

@end

@implementation BreedsViewController {
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Breeds"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"idog_bg"]];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.db queryDB:[NSString stringWithFormat:@"select name from info order by name"] numOfColumns:1];
    NSMutableArray *breeds = [[NSMutableArray alloc] init];
    _allBreeds = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[appDelegate.db.rs count]; i++) {
        NSString *key = [appDelegate.db.rs[i][0] substringToIndex:1];
        Breeds *b = [[Breeds alloc] init:appDelegate.db.rs[i][0] breedImage:[appDelegate.db.rs[i][0] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        if ([_allBreeds objectForKey:key]==nil) {
            [breeds removeAllObjects];
            [breeds addObject:b];
            [_allBreeds setValue:[NSArray arrayWithArray:breeds] forKey:key];
        }
        else {
            [breeds addObject:b];
            [_allBreeds setValue:[NSArray arrayWithArray:breeds] forKey:key];
        }
    }
    keys = [[_allBreeds allKeys] sortedArrayUsingSelector:@selector(compare:)];
    filteredNames = [NSMutableArray arrayWithObject:[Breeds alloc]];
    UISearchBar *searchBar = (id)[self.view viewWithTag:777];
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate=self;
    searchController.searchResultsDataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 222) {
        return [[_allBreeds allKeys] count];
    } else {
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 222) {
        NSString *key = [[_allBreeds allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][section];
        return [[_allBreeds objectForKey:key] count];
    } else {
        return [filteredNames count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 222) {
        NSArray *sortedArray=[[_allBreeds allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return sortedArray[section];
    } else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return 20;
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BreedsTableViewCell *cell = (BreedsTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"BreedsTableViewCell"];
    NSArray *breeds = [_allBreeds objectForKey:[[_allBreeds allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.section]];
    Breeds *breed = breeds[indexPath.row];
    if (cell == nil) {
        cell = [[BreedsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BreedsTableViewCell"];
    }
    if(tableView.tag == 222) {
        cell.lblBreedName.text = breed.breedName;
        cell.ivBreedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",breed.breedImage]];
    } else {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchBreedTableViewCell" owner:nil options:nil];
        
        cell = (BreedsTableViewCell*)[topLevelObjects objectAtIndex:0];
        //        cell = (PlayersTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"PlayersTableViewCell"];
        
        cell.lblBreedName.text = ((Breeds*)(filteredNames[indexPath.row])).breedName;
        cell.ivBreedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",((Breeds*)(filteredNames[indexPath.row])).breedImage]];
        //cell.textLabel.text = ((Players*)(filteredNames[indexPath.row])).playerName;
        
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableView *tableView = (id)[self.view viewWithTag:222];
    NSIndexPath * indexPath = [tableView indexPathForSelectedRow];
    
    BreedDetailsViewController *bdVC = segue.destinationViewController;
    //    PlayersTableViewCell *cell = (PlayersTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"PlayersTableViewCell"];
    NSArray *breeds = [_allBreeds objectForKey:[[_allBreeds allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.section]];
    Breeds *breed = breeds[indexPath.row];
    bdVC.breedName = breed.breedName;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 222) {
        return [[_allBreeds allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    } else {
        return nil;
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"BreedsTableViewCell"];
    tableView.delegate = self;
    tableView.rowHeight = 84.0f;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Breeds *breeds, NSDictionary *b) {
            NSRange range = [breeds.breedName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }];
        for (NSString *key in keys) {
            NSArray *matches = [_allBreeds[key] filteredArrayUsingPredicate: predicate];
            [filteredNames addObjectsFromArray:matches];
        }
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 222) return;
    
    [searchController setActive:NO animated:YES];
    
    BreedDetailsViewController *bdVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc"];
    
    Breeds *breed = filteredNames[indexPath.row];
    bdVC.breedName = breed.breedName;
    
    [self.navigationController pushViewController:bdVC animated:true];
    
}







@end
