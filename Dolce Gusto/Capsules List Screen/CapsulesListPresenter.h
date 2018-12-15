//
//  CapsulesListPresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapsulesListViewController.h"
#import "AddCapsuleDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapsulesListPresenter : NSObject <AddCapsuleDelegate>

- (instancetype)initWithViewController:(CapsulesListViewController *)capsulesListController;
-(void)didPressSaveWithCoffeeName:(NSString *)coffeeName andCapsules:(NSArray *)capsulesArray isEditing:(BOOL)isEditing;
- (void)deleteRecipe:(RecipeModel*)recipe;

@property NSMutableArray <CapsuleModel *> *capsulesArray;

@end

NS_ASSUME_NONNULL_END
