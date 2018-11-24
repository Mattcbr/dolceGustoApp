//
//  CapsulesListPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListPresenter.h"
#import "DatabaseManager.h"

@interface CapsulesListPresenter ()

@property NSMutableArray <CapsuleModel *> *capsulesArray;
@property CapsulesListViewController *controller;
@property DatabaseManager *dbManager;

@end

@implementation CapsulesListPresenter

- (instancetype)initWithViewController:(CapsulesListViewController *)capsulesListController {
    self = [super init];
    if (self) {
        self.controller = capsulesListController;
        self.capsulesArray = [[NSMutableArray alloc] init];
        self.dbManager = [DatabaseManager sharedManager];
    }
    return self;
}

-(void)didPressSaveWithCoffeeName:(NSString *)coffeeName andCapsules:(NSArray *)capsulesArray {
    NSString *coffeeNameToValidate = [coffeeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([coffeeNameToValidate isEqualToString:@""]){
        [self.controller displayErrorWithType:@"missingName"];
    } else if (capsulesArray.count == 0){
        [self.controller displayErrorWithType:@"missingCapsules"];
    } else {
        NSInteger latestRecipeId = [self.dbManager getLatestRecipeId];
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:coffeeName
                                                          Capsules:self.capsulesArray
                                                             andID:(latestRecipeId + 1)];
        
        [self.dbManager insertNewRecipe:newRecipe];
        [self.dbManager insertNewCapsules:capsulesArray ForRecipeID:(latestRecipeId + 1)];
        [self.controller.delegate addNewRecipe:newRecipe];
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark CapsuleDelegate

- (void)addNewCapsule:(nonnull CapsuleModel *)capsule {
    [self.capsulesArray addObject:capsule];
    [self.controller updateCapsulesArray:self.capsulesArray];
}

@end
