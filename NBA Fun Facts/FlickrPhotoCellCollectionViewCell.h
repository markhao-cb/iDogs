//
//  FlickrPhotoCellCollectionViewCell.h
//  iDogs
//
//  Created by Yu Qi Hao on 12/2/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;
@interface FlickrPhotoCellCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;

@end
