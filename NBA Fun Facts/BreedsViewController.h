//
//  BreedsViewController.h
//  iDogs
//
//  Created by Yu Qi Hao on 11/24/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreedsViewController : UIViewController
<UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSString *breedname;
@end
