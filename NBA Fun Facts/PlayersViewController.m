//
//  PlayersViewController.m
//  NBA Fun Facts
//
//  Created by Yu Qi Hao on 11/9/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "PlayersViewController.h"
#import "DBAPI.h"
#import "AppDelegate.h"
#import "PlayersTableViewCell.h"
#import "PlayerDetailsViewController.h"
#import "Player.h"

@interface PlayersViewController () {
   
    NSMutableDictionary *_allPlayers;
    NSArray *keys;
}

@end

@implementation PlayersViewController {
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.db queryDB:[NSString stringWithFormat:@"select name, team from roster order by name"] numOfColumns:2];
    NSMutableArray * players = [[NSMutableArray alloc]init];
    _allPlayers = [[NSMutableDictionary alloc]init];
    for (int i=0; i<[appDelegate.db.rs count]; i++) {
        NSString *key = [appDelegate.db.rs[i][0] substringToIndex:1];
        Player *p = [[Player alloc] init:appDelegate.db.rs[i][0] playerTeam:appDelegate.db.rs[i][1]];
        if ([_allPlayers objectForKey:key] == nil) {
            [players removeAllObjects];
            [players addObject:p];
            [_allPlayers setValue:[NSArray arrayWithArray:players] forKey:key];
        }
        else {
            [players addObject:p];
            [_allPlayers setValue:[NSArray arrayWithArray:players] forKey:key];
        }
    }
    keys = [[_allPlayers allKeys] sortedArrayUsingSelector:@selector(compare:)];
    filteredNames = [NSMutableArray arrayWithObject:[Player alloc]];
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
        return [[_allPlayers allKeys] count];
    } else {
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 222) {
        NSString *key = [[_allPlayers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][section];
        return [[_allPlayers objectForKey:key] count];
    } else {
        return [filteredNames count];
    }
   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 222) {
        NSArray *sortedArray=[[_allPlayers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    PlayersTableViewCell *cell = (PlayersTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"PlayersTableViewCell"];
    NSArray *players = [_allPlayers objectForKey:[[_allPlayers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.section]];
    Player *player = players[indexPath.row];
    if (cell == nil) {
        cell = [[PlayersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayersTableViewCell"];
    }
    if(tableView.tag == 222) {
        cell.lblplayername.text = player.playerName;
//        cell.lblplayerteam.text = player.playerTeam;
    } else {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchPlayerTableViewCell" owner:nil options:nil];
        
        cell = (PlayersTableViewCell*)[topLevelObjects objectAtIndex:0];
        //        cell = (PlayersTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"PlayersTableViewCell"];
        
        cell.lblplayername.text = ((Player*)(filteredNames[indexPath.row])).playerName;
//        cell.lblplayerteam.text = ((Player*)(filteredNames[indexPath.row])).playerTeam;
        //cell.textLabel.text = ((Players*)(filteredNames[indexPath.row])).playerName;
        
    }
    return cell;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView
//  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        return nil;
//    } else {
//        return indexPath;
//    }
//}

//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    _playername = _players[indexPath.row][0];
//    NSString *message = [[NSString alloc] initWithFormat:
//                         @"You selected %@", _playername];
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableView *tableView = (id)[self.view viewWithTag:222];
    NSIndexPath * indexPath = [tableView indexPathForSelectedRow];
    PlayerDetailsViewController *pdVC = segue.destinationViewController;
//    PlayersTableViewCell *cell = (PlayersTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"PlayersTableViewCell"];
    NSArray *players = [_allPlayers objectForKey:[[_allPlayers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.section]];
    Player *player = players[indexPath.row];
    pdVC.playername = player.playerName;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 222) {
        return [[_allPlayers allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    } else {
        return nil;
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"PlayersTableViewCell"];
    tableView.rowHeight = 84.0f;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *b) {
            NSRange range = [player.playerName rangeOfString:searchString options:NSCaseInsensitiveSearch];
             return range.location != NSNotFound;
         }];
        for (NSString *key in keys) {
            NSArray *matches = [_allPlayers[key] filteredArrayUsingPredicate: predicate];
            [filteredNames addObjectsFromArray:matches];
        }
    }
    return YES;
}



@end
