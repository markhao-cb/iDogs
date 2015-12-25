//
//  BreedDetailsViewController.m
//  iDogs
//
//  Created by Yu Qi Hao on 11/24/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "BreedDetailsViewController.h"
#import "AppDelegate.h"
#import "InfoTableViewCell.h"

@interface BreedDetailsViewController () {
    NSMutableDictionary *_info;
    NSMutableArray *_allInfo;
    NSArray *keys;
}

@end

@implementation BreedDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Breed Info"];
    UILabel *breedName = (id)[self.view viewWithTag:12];
    breedName.text = _breedName;
    UIImageView *breedImage = (id)[self.view viewWithTag:13];
    breedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_breedName stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.db queryDB:[NSString stringWithFormat:@"select othername, nickname, country, weight, mweight, fweight, height, mheight, fheight, coat, color, littersize, lifespan from info where name = '%@'",_breedName] numOfColumns:13];
    _allInfo = [[NSMutableArray alloc] init];
    _info = [[NSMutableDictionary alloc] init];
    keys = @[@"01Other names", @"02Nicknames", @"03Country of Origin", @"04Weight",@"05Male Weight",@"06Female Weight",@"07Height",@"08Male Height",@"09Female Height",@"10Coat",@"11Color",@"12Litter size", @"13Life span"];
    for (int i=0; i<13; i++) {
        if (![appDelegate.db.rs[0][i] isEqualToString:@""] ) {
            NSString *key = keys[i];
            [_info setValue:appDelegate.db.rs[0][i] forKey:key];
        }
    }
    
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 15) {
        return [[_info allKeys] count];
    } else {
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 15) {
        NSArray *sortedArray=[[_info allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return [sortedArray[section] substringFromIndex:2 ];
        //return [_info allKeys][section];
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
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"InfoTableViewCell"];
    if (cell == nil) {
        cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoTableViewCell"];
    }
    if(tableView.tag == 15) {
        
        cell.lblInfo.text = [_info objectForKey:[[_info allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][indexPath.section]];

    }     return cell;
}

@end

