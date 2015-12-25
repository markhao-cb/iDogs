//
//  FlickrPhotoCellCollectionViewCell.m
//  iDogs
//
//  Created by Yu Qi Hao on 12/2/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "FlickrPhotoCellCollectionViewCell.h"
#import "FlickrPhoto.h"

@implementation FlickrPhotoCellCollectionViewCell

-(void) setPhoto:(FlickrPhoto *)photo {
    
    if(_photo != photo) {
        _photo = photo;
    }
    self.imageView.image = _photo.thumbnail;
}

@end
