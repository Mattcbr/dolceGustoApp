//
//  DetailsScreenPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/20/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "DetailsScreenPresenter.h"

@implementation DetailsScreenPresenter

- (instancetype)initWithViewController: (DetailsScreenViewController *)viewController {
    self = [super init];
    if (self) {
        self.controller = viewController;
        self.capsulesArray = [[NSMutableArray alloc] init];
        self.dbManager = [DatabaseManager sharedManager];
    }
    return self;
}

-(void) getCapsulesForRecipe:(RecipeModel *)recipe {
    __weak typeof(self) weakSelf = self;
    [self.dbManager getCapsulesForRecipeId:recipe.recipeId withCompletion:^(NSMutableArray * _Nonnull capsulesArray) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf didLoadCapsules:capsulesArray];
    }];
}

-(void) didLoadCapsules:(NSMutableArray *)capsulesArray {
    self.capsulesArray = capsulesArray;
    [self.controller didReceiveCapsules];
}

@end
