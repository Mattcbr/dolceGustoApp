//
//  SaveRecipeDelegate.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "RecipeModel.h"
#import <Foundation/Foundation.h>

@protocol SaveRecipeDelegate <NSObject>

- (void)addNewRecipe:(RecipeModel *)recipe;

@end

