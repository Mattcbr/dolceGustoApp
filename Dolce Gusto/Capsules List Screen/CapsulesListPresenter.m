//
//  CapsulesListPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListPresenter.h"

@interface CapsulesListPresenter ()

@property NSMutableArray <CapsuleModel *> *capsulesArray;
@property CapsulesListViewController *controller;

@end

@implementation CapsulesListPresenter

- (instancetype)initWithViewController:(CapsulesListViewController *)capsulesListController {
    self = [super init];
    if (self) {
        self.controller = capsulesListController;
        self.capsulesArray = [[NSMutableArray alloc] init];
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
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:coffeeName
                                                       andCapsules:self.capsulesArray];
        
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
