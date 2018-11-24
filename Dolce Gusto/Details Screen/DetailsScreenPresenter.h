//
//  DetailsScreenPresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/20/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsScreenViewController.h"
#import "RecipeModel.h"
#import "CapsuleModel.h"
#import "DatabaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsScreenPresenter : NSObject

@property (weak,nonatomic) DetailsScreenViewController *controller;
@property DatabaseManager *dbManager;
@property NSMutableArray <CapsuleModel *> *capsulesArray;

-(instancetype)initWithViewController: (DetailsScreenViewController *)viewController;
-(void) getCapsulesForRecipe:(RecipeModel *)recipe;
@end

NS_ASSUME_NONNULL_END
