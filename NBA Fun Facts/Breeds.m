//
//  Breeds.m
//  iDogs
//
//  Created by Yu Qi Hao on 11/24/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import "Breeds.h"

@implementation Breeds

-(id)init:(NSString *)breedName breedImage:(NSString *)breedImage {
    _breedName = breedName;
    _breedImage = breedImage;
    return self;
}
@end
