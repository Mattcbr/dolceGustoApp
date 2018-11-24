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

@property NSMutableArray *recipesArray;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipesArray = [[NSMutableArray alloc] init];
        [self createDataBase];
        [self verifyDBVersion];
        [self insertFakeRecipes];
    }
    return self;
}

#pragma mark Creating the database
- (void)createDataBase {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.sqlite"];
    if(!self.db){
        self.db = [FMDatabase databaseWithPath:path];
        NSLog(@"Created DB with path: %@", path);
    }
}

- (void)verifyDBVersion {
    if([self.db open]) {
        FMResultSet *versionTableExists= [self.db executeQuery:@"SELECT * FROM dbVersion"];
        if([versionTableExists next]) {
            uint32_t dbVersion = [versionTableExists intForColumn:@"version"];
            if (dbVersion < latestDBVersion){
                [self migrateDatabaseFromVersion:dbVersion];
            } else {
                NSLog(@"Database already in the latest version");
            }
        } else {
            [self createDatabaseWithLatestVersion];
        }
    }
}

- (void)createDatabaseWithLatestVersion {
    BOOL success = NO;
    BOOL didCreateRecipesTable = NO;
    BOOL didCreateCapsulesTable = NO;
    BOOL didCreateVersionTable = NO;
    if([self.db open]){
        didCreateRecipesTable = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)"];
        didCreateCapsulesTable = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Capsules (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, tracesqt INT, RecipeID INT)"];
        didCreateVersionTable = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS dbVersion (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, version INT)"];
        success = didCreateRecipesTable && didCreateCapsulesTable && didCreateVersionTable;
    }
    if (success) {
        [self updateDBVersionInDBTable];
        NSLog(@"New Database Created in version: %u", latestDBVersion);
    } else {
        NSLog(@"Database Creation Status:\nRecipes: %d\nCapsules: %d\nVersion: %d",didCreateRecipesTable, didCreateCapsulesTable, didCreateVersionTable);
    }
}

-(void)migrateDatabaseFromVersion:(uint32_t)version {
    BOOL success = YES;
    while(version < latestDBVersion) {
        switch (version) {
            case 0:
                success = [self updateDatabase0to1];
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
    BOOL didCreate = YES;
    if([self.db open]){
        didCreate = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)"];
        if(didCreate){
            NSLog(@"Recipes Table Successfully created");
        } else {
            NSLog(@"Error creating Recipes table: %@",self.db.lastErrorMessage);
        }
    }
    return didCreate;
}

- (BOOL)createCapsulesTable {
    BOOL didCreate = YES;
    if([self.db open]){
        didCreate = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Capsules (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, tracesqt INT, RecipeID INT)"];
        if(didCreate){
            NSLog(@"Capsules Table Successfully created");
        } else {
            NSLog(@"Error creating Capsules table: %@",self.db.lastErrorMessage);
        }
    }
    return didCreate;
}

- (BOOL)createVersionTable {
    BOOL didCreate = YES;
    if([self.db open]){
        didCreate = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS dbVersion (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, version INT)"];
        if(didCreate){
            NSLog(@"dbVersion Table Successfully created");
        } else {
            NSLog(@"Error creating dbVersion table: %@",self.db.lastErrorMessage);
        }
    }
    return didCreate;
}

#pragma mark Inserting Data
- (void)insertFakeRecipes {
    NSString *sql = @"INSERT INTO Recipes (id, name) VALUES ('1','FakeCoffe');"
    @"INSERT INTO Recipes (id, name) VALUES ('2','Matheus');"
    "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('fakecapsule1', '2', '1');"
    "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('fakecapsule2', '1', '1');"
    "INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES ('Mattcapsule1', '1', '2');";
    BOOL didInsert = [self.db executeStatements:sql];
    if(didInsert){
        NSLog(@"Fake Recipes Successfully inserted");
    }
}

- (void)insertNewRecipe:(RecipeModel *)newRecipe {
    NSInteger *recipeId = newRecipe.recipeId;
    NSString *recipeName = newRecipe.recipeName;
    NSString *query = @"INSERT INTO Recipes (id, name) VALUES (?,?)";
    BOOL didInsert = [self.db executeUpdate:query, [NSNumber numberWithInt: recipeId], recipeName];
    if(didInsert){
        NSLog(@"Recipe %@ added to the database", newRecipe.recipeName);
    }
}

- (void)insertNewCapsules:(NSArray *)capsulesArray ForRecipeID:(NSInteger *)recipeID {
    NSString *query = @"INSERT INTO Capsules (name, tracesqt, RecipeID) VALUES (?,?,?);";
    for (CapsuleModel *capsule in capsulesArray){
        NSString *name = capsule.capsuleName;
        NSInteger *tracesqt = capsule.capsuleQuantity;
        BOOL didInsert = [self.db executeUpdate:query,name,[NSNumber numberWithInt: tracesqt],[NSNumber numberWithInt: recipeID]];
        if(didInsert){
            NSLog(@"Capsule %@ added to the database", capsule.capsuleName);
        }
    }
}

- (NSInteger)getLatestRecipeId {
    NSInteger *latestRecipeId = 0;
    FMResultSet *Set = [self.db executeQuery:@"select max(id) as max from Recipes"];
    if([Set next]){
        latestRecipeId = [Set intForColumn:@"max"];
    }
    return latestRecipeId;
}

- (NSInteger)getLatestCapsuleId {
    NSInteger *latestCapsuleId = 0;
    FMResultSet *Set = [self.db executeQuery:@"select max(id) as max from Capsules"];
    if([Set next]){
        latestCapsuleId = [Set intForColumn:@"max"];
    }
    return latestCapsuleId;
}

#pragma mark Updating the Database Version in the database
- (void)updateDBVersionInDBTable {
    BOOL didInsert = [self.db executeUpdate:@"INSERT OR REPLACE INTO dbVersion (id, version) VALUES ('1',?)", @(latestDBVersion)];
    if(didInsert){
        NSLog(@"Database Version Successfully Update to: %d", @(latestDBVersion));
    }
}

#pragma mark Database Update Operations
- (BOOL)updateDatabase0to1 {
    BOOL didCreateRecipesTable = [self createRecipesTable];
    BOOL didCreateCapsulesTable = [self createCapsulesTable];
    BOOL didCreateVersionTable = [self createVersionTable];
    BOOL success = didCreateRecipesTable && didCreateCapsulesTable && didCreateVersionTable;
    return success;
}

//Criar create database with latest version
#pragma mark Getting data from the Database
- (void)getAllRecipesWithCompletion:(void (^)(NSMutableArray *recipesTest))completionBlock {
    FMResultSet *Set = [self.db executeQuery:@"SELECT name, id FROM Recipes"];
    while ([Set next]){
        NSLog(@"Recipe retrieved: %@", [Set stringForColumn:@"name"]);
        NSString *name = [Set stringForColumn:@"name"];
        NSInteger *recipeId = [Set intForColumn:@"id"];
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:name andId:recipeId];
        [self.recipesArray addObject:newRecipe];
    }
    
    if(completionBlock) {
        completionBlock(self.recipesArray);
    }
}

- (void)getCapsulesForRecipeId:(int)RecipeId WithCompletion:(void (^)(NSMutableArray *capsulesArray))completionBlock {
    NSMutableArray *capsulesArray = [[NSMutableArray alloc] init];
    FMResultSet *Set = [self.db executeQuery:@"Select * from Capsules where RecipeId = ?", @(RecipeId)];
    while ([Set next]) {
        NSString *capsuleName = [Set stringForColumn:@"name"];
        NSInteger *capsuleQuantity = [Set intForColumn:@"tracesqt"];
        CapsuleModel *newCapsule = [[CapsuleModel alloc] initWithName:capsuleName
                                                          andQuantity:capsuleQuantity];
        [capsulesArray addObject:newCapsule];
        NSLog(@"Capsule Retrieved: %@",newCapsule.capsuleName);
    }
    if(completionBlock){
        completionBlock(capsulesArray);
    }
}

@end
