//
//  MainScreenViewPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewPresenter.h"
#import "notificationsConstants.h"

@interface MainScreenViewPresenter ()
@property DatabaseManager *dbManager; //Tirar de property
@end


@implementation MainScreenViewPresenter

- (instancetype)initWithViewController:(MainScreenCollectionViewController *)viewController
{
    self = [super init];
    if (self) {
        self.controller = viewController;
        self.recipesArray = [[NSMutableArray alloc] init];
        self.dbManager = [DatabaseManager sharedManager];
        [self getRecipesFromDB];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeRecipesArray)
                                                     name:kDidEditRecipe
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDeleteRecipe:)
                                                     name:kDidDeleteRecipe
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDeleteCapsule:)
                                                     name:kDidDeleteCapsule
                                                   object:nil];
    }
    return self;
}

#pragma Database Getter

- (void)getRecipesFromDB {
    __weak typeof(self) weakSelf = self;
    [self.dbManager getAllRecipesWithCompletion:^(NSMutableArray * _Nonnull recipesArray) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateAllRecipes:recipesArray];
    }];
}

- (id<SaveRecipeDelegate>)createSaveRecipeDelegate {
    return self;
}

-(void)updateAllRecipes:(NSMutableArray *)recipes {
    self.recipesArray = recipes;
    [self.controller reloadRecipes];
}

#pragma mark SaveRecipeDelegate

- (void)didChangeRecipesArray {
    [self getRecipesFromDB];
}

-(void)didPressAdd {
    [self.controller showAddScreen];
}

#pragma Data Deletion Handlers

- (void)didDeleteRecipe:(NSNotification *)notification {
    RecipeModel *deletedRecipe = (RecipeModel *)notification.object;
    [self.dbManager deleteRecipe:deletedRecipe withCompletion:^{
        [self didChangeRecipesArray];
    }];
}

- (void)didDeleteCapsule:(NSNotification *)notification {
    CapsuleModel *deletedCapsule = (CapsuleModel *)notification.object;
    [self.dbManager deleteCapsule:deletedCapsule];
}

-(void)deleteRecipe:(RecipeModel *)recipe {
    [self.dbManager deleteRecipe:recipe withCompletion:^{
        [self didChangeRecipesArray];
    }];
}
@end
