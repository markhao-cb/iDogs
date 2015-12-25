//
//  Breeds.h
//  iDogs
//
//  Created by Yu Qi Hao on 11/24/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Breeds : NSObject

@property (nonatomic, retain) NSString *breedName;
@property (nonatomic, retain) NSString *breedImage;


-(id)init:(NSString *)breedName breedImage:(NSString *)breedImage;

@end
