//
//  MainScreenViewPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewPresenter.h"

@interface MainScreenViewPresenter ()

@property NSMutableArray <RecipeModel *> *recipesArray;

@end

@implementation MainScreenViewPresenter

- (instancetype)initWithViewController:(MainScreenCollectionViewController *)viewController
{
    self = [super init];
    if (self) {
        self.controller = viewController;
        self.recipesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark SaveRecipeDelegate

- (void)addNewRecipe:(RecipeModel *)recipe {
    [self.recipesArray addObject:recipe];
    [self.controller reloadWithArray:self.recipesArray];
    NSLog(@"Hello, Matt :D");
}

@end
