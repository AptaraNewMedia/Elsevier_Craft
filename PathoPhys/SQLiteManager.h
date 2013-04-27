//
//  SQLiteManager.h
//  Springer1.1
//
//  Created by PUN-MAC-012 on 31/01/13.
//  Copyright (c) 2013 PUN-MAC-012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


enum errorCodes {
	kDBNotExists,
	kDBFailAtOpen,
	kDBFailAtCreate,
	kDBErrorQuery,
	kDBFailAtClose
};

@interface SQLiteManager : NSObject
{
    
	sqlite3 *db; // The SQLite db reference
	NSString *databaseName; // The database name
}

+ (id) sharedDatabase;

- (id)init;

// SQLite Operations
- (NSError *) openDatabase;
- (NSError *) doQuery:(NSString *)sql;
- (NSArray *) getRowsForQuery:(NSString *)sql;
- (NSError *) closeDatabase;

- (NSString *)getDatabaseDump;
- (void)createDatabaseInApplicationDirectory;
@end
