//
//  DBAPI.h
//  NBA Fun Facts
//
//  Created by Yu Qi Hao on 11/11/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBAPI : NSObject{
    
    sqlite3 *database;
    NSMutableArray *rs;
}

@property sqlite3 *database;
@property (nonatomic, retain) NSMutableArray *rs;

- (id)init;
- (void) modifyDB:(NSString*) stmt;
- (void) queryDB:(NSString*)stmt numOfColumns:(int)cols;
- (void) prepareDBTransaction;
- (void) execStmt:(NSString*) stmt;
- (void) endDBTransaction;

- (BOOL) setOrCreateDatabase:(NSString*) databaseName;

@end
