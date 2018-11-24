//
//  MainScreenViewPresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenCollectionViewController.h"
#import "SaveRecipeDelegate.h"
#import "DatabaseManager.h"

@interface MainScreenViewPresenter : NSObject <SaveRecipeDelegate>

@property (weak,nonatomic) MainScreenCollectionViewController *controller;
@property NSMutableArray <RecipeModel *> *recipesArray;

-(instancetype)initWithViewController: (MainScreenCollectionViewController *)viewController;
-(id<SaveRecipeDelegate>)createSaveRecipeDelegate;
-(void) didPressAdd;

@end
