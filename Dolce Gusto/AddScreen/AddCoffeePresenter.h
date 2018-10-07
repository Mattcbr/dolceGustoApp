//
//  AddCoffeePresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/7/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCoffeeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCoffeePresenter : NSObject

- (void)saveCapsuleWithName:(NSString *)name;
- (void)saveRecipe;
- (instancetype)initWithViewController:(AddCoffeeViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
