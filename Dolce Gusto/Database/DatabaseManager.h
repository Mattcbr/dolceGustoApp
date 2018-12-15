//
//  DatabaseManager.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "RecipeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

- (void)getAllRecipesWithCompletion:(void (^)(NSMutableArray *recipesTest))completionBlock;
- (void)getCapsulesForRecipeId:(NSInteger)recipeId withCompletion:(void (^)(NSMutableArray *capsulesArray))completionBlock;
- (NSInteger)getLatestRecipeId;
- (NSInteger)getLatestCapsuleId;
- (void)insertNewRecipe:(RecipeModel *)newRecipe;
- (void)insertNewCapsules:(NSArray *)capsulesArray forRecipeId:(NSInteger)recipeId;
- (void)updateRecipe:(RecipeModel *)updatedRecipe withCompletion:(void (^)(void))completionBlock;
- (void)updateCapsules:(NSArray *)updatedCapsulesArray;
- (void)deleteRecipe:(RecipeModel *)deletedRecipe withCompletion:(void (^)(void))completionBlock;
- (void)deleteCapsule:(CapsuleModel *)deletedCapsule;

+ (id)sharedManager;

@end

NS_ASSUME_NONNULL_END
