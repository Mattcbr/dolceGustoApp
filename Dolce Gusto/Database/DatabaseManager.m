//
//  DatabaseManager.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "DatabaseManager.h"
#import "RecipeModel.h"

static const uint32_t latestDBVersion = 1;

@interface DatabaseManager ()

// @property FMDatabase *db;
@property FMDatabaseQueue *dbQueue;

@end

@implementation DatabaseManager

#pragma mark Creating a Singleton
+ (id)sharedManager {
    static DatabaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDataBase];
        [self verifyDBVersion];
        [self insertFakeRecipes];
    }
    return self;
}

#pragma mark Creating the database
- (void)createDataBase {
    if (!self.dbQueue) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.sqlite"];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        NSLog(@"Created DB with path: %@", path);
    }
}

- (void)verifyDBVersion {
    __weak typeof(self) weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        __strong typeof(self) strongSelf = weakSelf;
        FMResultSet *versionTableExists= [db executeQuery:@"SELECT version FROM dbVersion"];
        if ([versionTableExists next]) {
            uint32_t dbVersion = [versionTableExists intForColumn:@"version"];
            if (dbVersion < latestDBVersion){
                [strongSelf migrateDatabaseFromVersion:dbVersion];
            } else {
                NSLog(@"Database already in the latest version");
            }
        } else {
            [strongSelf createDatabaseWithLatestVersion];
        }
    }];
}

- (void)createDatabaseWithLatestVersion {
    [self.dbQueue inDeferredTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if (![db executeUpdate:@"CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)"]) {
            NSLog(@"Could not create table Recipes");
            *rollback = YES;
            return;
        }

        if (![db executeUpdate:@"CREATE TABLE IF NOT EXISTS Capsules (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, tracesqt INT, RecipeID INT)"]) {
            NSLog(@"Could not create table Capsules");
            *rollback = YES;
            return;
        }

        if (![db executeUpdate:@"CREATE TABLE IF NOT EXISTS dbVersion (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, version INT)"]) {
            NSLog(@"Could not create table dbVersion");
            *rollback = YES;
            return;
        }
        
        [self updateDBVersionInDBTable];
        NSLog(@"New Database Created in version: %u", latestDBVersion);
    }];
}

-(void)migrateDatabaseFromVersion:(uint32_t)version {
    BOOL success = YES;
    while(version < latestDBVersion) {
        switch (version) {
            case 0:
                success = [self migrateDatabase0to1];
                if(success) {
                    version = 1;
                }
                break;
            default:
                break;
        }
        if(!success){
            NSLog(@"Failed to migrate database from version %u", version);
            break;
        }
    }
    [self updateDBVersionInDBTable];
}

#pragma mark Creating the Tables
- (BOOL)createRecipesTable {
    __block BOOL didCreate = YES;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        didCreate = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)"];
        if(didCreate){
            NSLog(@"Recipes Table Successfully created");
        } else {
            NSLog(@"Error creating Recipes table: %@",db.lastErrorMessage);
        }
    }];
    return didCreate;
}

- (BOOL)createCapsulesTable {
    __block BOOL didCreate = YES;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        didCreate = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Capsules (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, tracesqt INT, RecipeID INT)"];
        if(didCreate){
            NSLog(@"Capsules Table Successfully created");
        } else {
            NSLog(@"Error creating Capsules table: %@",db.lastErrorMessage);
        }
    }];
    return didCreate;
}

- (BOOL)createVersionTable {
    __block BOOL didCreate = YES;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        didCreate = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS dbVersion (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, version INT)"];
        if(didCreate){
            NSLog(@"dbVersion Table Successfully created");
        } else {
            NSLog(@"Error creating dbVersion table: %@",db.lastErrorMessage);
        }

    }];
    return didCreate;
}

#pragma mark Inserting Data
- (void)insertFakeRecipes {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO Recipes (id, name) VALUES ('1','FakeCoffe');"
        @"INSERT INTO Recipes (id, name) VALUES ('2','Matheus');"
        "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('fakecapsule1', '2', '1');"
        "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('fakecapsule2', '1', '1');"
        "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('Mattcapsule1', '1', '2');";
        BOOL didInsert = [db executeStatements:sql];
        if(didInsert){
            NSLog(@"Fake Recipes Successfully inserted");
        }
    }];
}

- (void)insertNewRecipe:(RecipeModel *)newRecipe {
    [self.dbQueue inDeferredTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if(![self insertNewRecipeInternal:newRecipe db:db]){
            *rollback = YES;
            return;
        }
        if(![self insertNewCapsulesInternal:newRecipe.capsulesArray forRecipeId:newRecipe.recipeId db:db]){
            *rollback = YES;
            return;
        }
    }];
}
    
- (BOOL)insertNewRecipeInternal:(RecipeModel *)newRecipe db:(FMDatabase *)db {
    NSString *recipeName = newRecipe.recipeName;
    NSString *query = @"INSERT INTO Recipes (name, id) VALUES (?,?)";
    BOOL didInsert = [db executeUpdate:query, recipeName, [NSNumber numberWithInteger:newRecipe.recipeId]];
    if (didInsert) {
        NSLog(@"Recipe %@ added to the database", newRecipe.recipeName);
    }
    return didInsert;
}

- (BOOL)insertNewCapsulesInternal:(NSArray *)capsulesArray forRecipeId:(NSInteger)recipeId db:(FMDatabase *)db {
    NSString *query = @"INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES (?,?,?);";
    BOOL didInsert = NO;
    for (CapsuleModel *capsule in capsulesArray){
        NSString *name = capsule.capsuleName;
        NSInteger tracesqt = capsule.capsuleQuantity;
        didInsert = [db executeUpdate:query, name, @(tracesqt), @(recipeId)];
        if (didInsert) {
            NSLog(@"Capsule %@ added to the database", capsule.capsuleName);
        }
    }
    return didInsert;
}

#pragma mark Updating Data
- (void)updateRecipe:(RecipeModel *)updatedRecipe withCompletion:(void (^)(void))completionBlock {
    NSString *query = @"UPDATE Recipes SET name = ? WHERE id = ?";
    BOOL didInsert = [self.db executeUpdate:query, updatedRecipe.recipeName, [NSNumber numberWithInteger:updatedRecipe.recipeId]];
    if(didInsert){
        NSLog(@"Recipe Updated");
    }
    if(completionBlock){
        completionBlock();
    }
}

- (void)updateCapsules:(NSArray *)updatedCapsulesArray {
    NSString *query = @"UPDATE Capsules SET name = ?, tracesqt = ? WHERE id = ?";
    NSMutableArray *newCapsulesArray = [[NSMutableArray alloc] init];
    NSInteger RecipeId;
    
    for (CapsuleModel *capsule in updatedCapsulesArray) {
        if (!capsule.capsuleId){
            capsule.capsuleId = [self getLatestCapsuleId]+1;
            [newCapsulesArray addObject:capsule];
            RecipeId = capsule.recipeId;
            break;
        }
        BOOL didInsert = [self.db executeUpdate:query, capsule.capsuleName, [NSNumber numberWithInteger: capsule.capsuleQuantity], [NSNumber numberWithInteger:capsule.capsuleId]];
        if(didInsert){
            NSLog(@"Capsule Updated");
        }
    }
    if (newCapsulesArray.count > 0){
        [self insertNewCapsules:newCapsulesArray forRecipeId:RecipeId];
    }
}

- (void)updateDBVersionInDBTable {
    BOOL didInsert = [self.db executeUpdate:@"INSERT OR REPLACE INTO dbVersion (id, version) VALUES ('1',?)", @(latestDBVersion)];
    if(didInsert){
        NSLog(@"Database Version Successfully Update to: %d", latestDBVersion);
    }
}

#pragma mark Deleting Data
- (void)deleteRecipe:(RecipeModel *)deletedRecipe withCompletion:(void (^)(void))completionBlock {
    NSString *query = @"DELETE FROM Recipes WHERE id = ?";
    BOOL didDelete = [self.db executeUpdate:query, [NSNumber numberWithInteger:deletedRecipe.recipeId]];
    if(didDelete){
        NSLog(@"Recipe Deleted");
    }
    NSString *capsulesQuery = @"DELETE FROM Capsules WHERE RecipeID = ?";
    BOOL didDeleteCapsules = [self.db executeUpdate:capsulesQuery, [NSNumber numberWithInteger:deletedRecipe.recipeId]];
    
    if(completionBlock){
        completionBlock();
    }
}

- (void)deleteCapsule:(CapsuleModel *)deletedCapsule {
    NSString *query = @"DELETE FROM Capsules WHERE id = ?";
    BOOL didDelete = [self.db executeUpdate:query, [NSNumber numberWithInteger:deletedCapsule.capsuleId]];
    if(didDelete){
        NSLog(@"Capsule Deleted");
    }
}

#pragma mark Database Version Migration Operations
- (BOOL)migrateDatabase0to1 {
    BOOL didCreateRecipesTable = [self createRecipesTable];
    BOOL didCreateCapsulesTable = [self createCapsulesTable];
    BOOL didCreateVersionTable = [self createVersionTable];
    BOOL success = didCreateRecipesTable && didCreateCapsulesTable && didCreateVersionTable;
    return success;
}

#pragma mark Getting data from the Database
- (void)getAllRecipesWithCompletion:(void (^)(NSMutableArray *recipesTest))completionBlock {
    FMResultSet *Set = [self.db executeQuery:@"SELECT name, id FROM Recipes"];
    self.recipesArray = [[NSMutableArray alloc] init];
    while ([Set next]){
        NSLog(@"Recipe retrieved: %@", [Set stringForColumn:@"name"]);
        NSString *name = [Set stringForColumn:@"name"];
        NSInteger recipeId = [Set intForColumn:@"id"];
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:name andId:recipeId];
        [self.recipesArray addObject:newRecipe];
    }
    
    if(completionBlock) {
        completionBlock(self.recipesArray);
    }
}

- (void)getCapsulesForRecipeId:(NSInteger)recipeId withCompletion:(void (^)(NSMutableArray *capsulesArray))completionBlock {
    NSMutableArray *capsulesArray = [[NSMutableArray alloc] init];
    FMResultSet *Set = [self.db executeQuery:@"Select * from Capsules where RecipeId = ?", @(recipeId)];
    while ([Set next]) {
        NSInteger capsuleId = [Set intForColumn:@"id"];
        NSString *capsuleName = [Set stringForColumn:@"name"];
        NSInteger capsuleQuantity = [Set intForColumn:@"tracesqt"];
        CapsuleModel *newCapsule = [[CapsuleModel alloc] initWithId:capsuleId
                                                               name:capsuleName
                                                           quantity:capsuleQuantity
                                                        andRecipeId:recipeId];
        [capsulesArray addObject:newCapsule];
        NSLog(@"Capsule Retrieved: %@",newCapsule.capsuleName);
    }
    if (completionBlock) {
        completionBlock(capsulesArray);
    }
}

- (NSInteger)getLatestRecipeId {
    NSInteger latestRecipeId = 0;
    FMResultSet *Set = [self.db executeQuery:@"select max(id) as max from Recipes"];
    if([Set next]){
        latestRecipeId = [Set intForColumn:@"max"];
    }
    return latestRecipeId;
}

- (NSInteger)getLatestCapsuleId {
    NSInteger latestCapsuleId = 0;
    FMResultSet *Set = [self.db executeQuery:@"select max(id) as max from Capsules"];
    if([Set next]){
        latestCapsuleId = [Set intForColumn:@"max"];
    }
    return latestCapsuleId;
}

@end
