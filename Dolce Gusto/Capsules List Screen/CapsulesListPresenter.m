//
//  CapsulesListPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListPresenter.h"
#import "DatabaseManager.h"
#import "notificationsConstants.h"
#import "NSString+Validation.h"

@interface CapsulesListPresenter ()

@property CapsulesListViewController *controller;
@property DatabaseManager *dbManager;

@end

@implementation CapsulesListPresenter

- (instancetype)initWithViewController:(CapsulesListViewController *)capsulesListController {
    self = [super init];
    if (self) {
        self.controller = capsulesListController;
        self.capsulesArray = [[NSMutableArray alloc] init];
        self.dbManager = [DatabaseManager sharedManager];
    }
    return self;
}

-(void)didPressSaveWithCoffeeName:(NSString *)coffeeName andCapsules:(NSArray *)capsulesArray isEditing:(BOOL)isEditing {
    if (!coffeeName.isValidString){
        [self.controller displayErrorWithType:@"missingName"];
    } else if (capsulesArray.count == 0){
        [self.controller displayErrorWithType:@"missingCapsules"];
    } else if(isEditing) {
        NSInteger idForRecipe = self.controller.recipe.recipeId;
        RecipeModel *editedRecipe = [[RecipeModel alloc] initWithName:coffeeName
                                                             capsules:capsulesArray
                                                                andId:idForRecipe];
        __weak typeof(self) weakSelf = self;
        [self.dbManager updateRecipe:editedRecipe withCompletion:^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [strongSelf.dbManager updateCapsules:capsulesArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidEditRecipe
                                                                object:nil];
            [strongSelf.controller.navigationController popToRootViewControllerAnimated:YES];
        }];
        
    } else {
        NSInteger latestRecipeId = [self.dbManager getLatestRecipeId];
        NSInteger latestCapsuleId = [self.dbManager getLatestCapsuleId];
        
        for (CapsuleModel *capsule in capsulesArray) {
            latestCapsuleId++;
            [capsule addCapsuleId:latestCapsuleId andRecipeId:(latestRecipeId+1)];
        }
        
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:coffeeName
                                                          capsules:self.capsulesArray
                                                             andId:(latestRecipeId + 1)];
        
        //Deveria fazer uma cadeia de completion blocks aqui??
        //Fazer aquela parada de atomicidade
        [self.dbManager insertNewRecipe:newRecipe];
//        [self.dbManager insertNewCapsules:capsulesArray forRecipeId:newRecipe.recipeId];
        [self.controller.delegate didChangeRecipesArray];
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)deleteRecipe:(RecipeModel*)recipe {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidDeleteRecipe
                                                        object:recipe];
    [self.controller.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark CapsuleDelegate

- (void)addNewCapsule:(nonnull CapsuleModel *)capsule {
    if(self.controller.recipe.recipeId){
        capsule.recipeId = self.controller.recipe.recipeId;
    }
    [self.capsulesArray addObject:capsule];
    [self.controller didUpdateCapsulesArray];
}

- (void)editCapsule:(CapsuleModel *)capsule{
    NSUInteger indexToReplace = self.controller.selectedCapsuleIndex;
    [self.capsulesArray removeObjectAtIndex:indexToReplace];
    [self.capsulesArray insertObject:capsule atIndex:indexToReplace];
    [self.controller didUpdateCapsulesArray];
}

- (void)deleteCapsule:(CapsuleModel *)capsule{
    [self.capsulesArray removeObject:capsule];
    [self.controller didUpdateCapsulesArray];
}

@end
