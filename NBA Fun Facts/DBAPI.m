//
//  DBAPI.m
//  NBA Fun Facts
//
//  Created by Yu Qi Hao on 11/11/14.
//  Copyright (c) 2014 Yu Qi Hao. All rights reserved.
//


#import "DbAPI.h"



@implementation DBAPI

@synthesize database;
@synthesize rs;


- (id)init
{
    self = [super init];
    if ( self )
    {
        if ([self setOrCreateDatabase:@"dog.db"]) return self;
        else return nil;
    }
    return self;
}

- (BOOL) setOrCreateDatabase:(NSString*) databaseName{
    //NSLog(@"entering checkAndCreateDatabase");
    
    rs = [[NSMutableArray alloc] init];
    
    // Get the path to the documents directory and append the databaseName
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    NSLog(@"databasepath=%@", databasePath);
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success)
    {
        NSLog(@"databasePath %@ already exists", databasePath);
        if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
            database = NULL;
        return TRUE;
    }
    else
        NSLog(@"databasePath %@ not already exists, to create", databasePath);
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    
    if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
    {
        database = NULL;
        return FALSE;
    }
    else
        return TRUE;
}


- (void) prepareDBTransaction
{
    sqlite3_exec(database, "PRAGMA synchronous = 0;", NULL, NULL, NULL);
    sqlite3_exec(database, "PRAGMA temp_store = 2;", NULL, NULL, NULL);
    sqlite3_exec(database, "BEGIN TRANSACTION;", NULL, NULL, NULL);
}

- (void) execStmt:(NSString*)stmt
{
    
    int code = sqlite3_exec(database, [stmt cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
    //int code = sqlite3_exec(database, "insert into program values (null, '境外频道', '凤凰资讯台', '忠旺股市风向标(8/2/2010)', '2010-02-08 20:30:00', '')",
    //NULL, NULL, NULL);
    if (code!= SQLITE_OK)
        //NSLog(@"execStmt: %@ ok", stmt);
        //else
        NSLog(@"execStmt: %@ bad, code=%d", stmt, code);
}

- (void) endDBTransaction
{
    if(sqlite3_exec(database, "COMMIT TRANSACTION;", NULL, NULL, NULL)== SQLITE_OK)
    {
        NSLog(@"COMMIT TRANSACTION ok");
    }
    else NSLog(@"COMMIT TRANSACTION not ok");
}


- (void) modifyDB:(NSString*) stmt
{
    //NSLog(@"entering modifyDB: stmt=%@", stmt);
    if (database==NULL)
    {
        NSLog(@"queryDB failed: database==NULL");
        return;
    }
    
    sqlite3_stmt *compiledStatement;
    int code = sqlite3_prepare_v2(database, [stmt UTF8String], -1, &compiledStatement, NULL);
    if (code == SQLITE_OK)
    {
        if (SQLITE_DONE != sqlite3_step(compiledStatement))
            NSLog(@"prepare ok but add not ok:%s", sqlite3_errmsg(database));
        //else NSLog(@"db modified: %@", stmt);
        sqlite3_reset(compiledStatement);
    }
    else NSLog(@"prepare fails:%d, stmt:%@", code, stmt);
    sqlite3_finalize(compiledStatement);
    
}


- (void) queryDB:(NSString*)stmt numOfColumns:(int)cols
{
    //	NSLog(@"entering queryDB:stmt=%@", stmt);
    if (database==NULL)
    {
        NSLog(@"queryDB failed: database==NULL");
        return;
    }
    
    sqlite3_stmt *compiledStatement;
    [self.rs removeAllObjects];
    int result = sqlite3_prepare_v2(database, [stmt UTF8String], -1, &compiledStatement, NULL);
    if (result== SQLITE_OK)
    {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableArray *row = [[NSMutableArray alloc] init];
            for (int i=1; i<=cols; i++)
            {
                if (sqlite3_column_text(compiledStatement, i-1) == NULL) {
                    [row addObject:@""];
                    continue;
                }
                NSString *col = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i-1)];
                [row addObject:col];
                //NSLog(@"col=%@",col);
            }
            [self.rs addObject:row];
        }
    }
    sqlite3_finalize(compiledStatement);
}



@end
