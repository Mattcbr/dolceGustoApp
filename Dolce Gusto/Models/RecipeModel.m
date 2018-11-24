//
//  RecipeModel.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "RecipeModel.h"

@implementation RecipeModel

- (instancetype)initWithName:(NSString *)name Capsules:(NSMutableArray <CapsuleModel *> *)capsules andID:(NSInteger *)newRecipeId {
    self = [super init];
    if (self) {
        _recipeName = name;
        _capsulesArray = capsules;
        _recipeId = newRecipeId;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name andId:(int *)recipeId
{
    self = [super init];
    if (self) {
        _recipeName = name;
        _capsulesArray = [[NSMutableArray alloc] init];
        _recipeId = recipeId;
    }
    return self;
}

@end
