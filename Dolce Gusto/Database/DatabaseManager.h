//
//  DatabaseManager.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "SaveRecipeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

- (void)getAllRecipesWithCompletion:(void (^)(NSMutableArray *recipesTest))completionBlock;
- (void)getCapsulesForRecipeId:(int)RecipeId WithCompletion:(void (^)(NSMutableArray *capsulesArray))completionBlock;
- (NSInteger)getLatestRecipeId;
- (void)insertNewRecipe:(RecipeModel *)newRecipe;
- (void)insertNewCapsules:(NSArray *)capsulesArray ForRecipeID:(NSInteger *)recipeID;

+ (id)sharedManager;

@property FMDatabase *db;
@property (nonatomic, weak) id<SaveRecipeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
