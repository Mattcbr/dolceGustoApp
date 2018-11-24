//
//  RecipeModel.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapsuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeModel : NSObject

@property NSInteger *recipeId;
@property NSString *recipeName;
@property NSMutableArray <CapsuleModel *> *capsulesArray;

- (instancetype)initWithName:(NSString *)name Capsules:(NSMutableArray <CapsuleModel *> *)capsules andID:(NSInteger *)newRecipeId;
- (instancetype)initWithName:(NSString *)name andId:(int *)recipeId;

@end

NS_ASSUME_NONNULL_END
