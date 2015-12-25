
//
//  ImageViewController.m
//  iDogs
//
//  Created by Yu Qi Hao on 12/2/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "ImageViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoCellCollectionViewCell.h"
#import "AppDelegate.h"

@interface ImageViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UINavigationItem *navItem;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic,weak) IBOutlet UILabel *lblBot;
@property (nonatomic,weak) IBOutlet UIImageView *ivPhoto;
@property (nonatomic,strong) NSMutableDictionary *searchResults;
@property (nonatomic,strong) NSMutableArray *searches;
@property (nonatomic,strong) Flickr *flickr;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
-(IBAction)shareButtonTapped:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showActivity:self.view aiStyle:UIActivityIndicatorViewStyleWhite];
    });
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"idog_bg"]];
    [appDelegate.db queryDB:[NSString stringWithFormat:@"select name from info order by random() limit 1"] numOfColumns:1];
    [self.lblBot setText:appDelegate.db.rs[0][0]];
    
    

    // Do any additional setup after loading the view.
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc]init];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
   
    // 1
    [self.flickr searchFlickrForTerm:[_lblBot.text stringByAppendingString:@" dog"] completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if(results && [results count] > 0) {
            // 2
            if(![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %lu photos matching %@", (unsigned long)[results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
            }
            // 3
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate hideActivity];
                });
                
            });
        } else { // 1
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate hideActivity];
                [_ivPhoto setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_lblBot.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]]]];
            });

        } }];

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

-(IBAction)shareButtonTapped:(id)sender {
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 1
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if(results && [results count] > 0) {
            // 2
            if(![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %lu photos matching %@", (unsigned long)[results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results; }
            // 3
            
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate showActivity:self.view aiStyle:UIActivityIndicatorViewStyleWhite];
                });
               [self.collectionView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate hideActivity];
                });

            });
        } else { // 1
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        } }];
    [textField resignFirstResponder];
    return YES; 
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm] count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoCellCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm]
    [indexPath.row];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    self.searchResults[searchTerm][indexPath.row];
    // 2
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    retval.height += 35; retval.width += 35; return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}





























@end
