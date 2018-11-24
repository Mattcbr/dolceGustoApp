//
//  MainScreenViewPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewPresenter.h"

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
        //weakSelf no bloco (weak self e dentro strong self)
        __weak typeof(self) weakSelf = self;
        [weakSelf.dbManager getAllRecipesWithCompletion:^(NSMutableArray * _Nonnull recipesTest) {
            __strong typeof(self) strongSelf = weakSelf;
            NSLog(@"Successfull Completion");
            [strongSelf updateAllRecipes:recipesTest];
        }];
    }
    return self;
}

//Criar método pra buscar as coisas no DB

- (id<SaveRecipeDelegate>)createSaveRecipeDelegate {
    return self;
}

-(void)updateAllRecipes:(NSMutableArray *)recipes {
    self.recipesArray = recipes;
    [self.controller reloadRecipes];
}

#pragma mark SaveRecipeDelegate

- (void)addNewRecipe:(RecipeModel *)recipe {
    [self.recipesArray addObject:recipe];
    [self.controller reloadRecipes];
}

-(void)didPressAdd {
    [self.controller showAddScreen];
}
@end
