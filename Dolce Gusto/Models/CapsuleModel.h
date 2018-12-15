//
//  CapsuleModel.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CapsuleModel : NSObject

@property NSInteger capsuleId;
@property NSString *capsuleName;
@property NSInteger capsuleQuantity;
@property NSInteger recipeId;

- (instancetype)initWithName:(NSString *)name andQuantity:(NSInteger)quantity;
- (instancetype)initWithId:(NSInteger)capsuleId name:(NSString *)name quantity:(NSInteger)quantity andRecipeId:(NSInteger)recipeId;
- (void)addCapsuleId:(NSInteger)newCapsuleId andRecipeId:(NSInteger)newRecipeId;

@end

NS_ASSUME_NONNULL_END
