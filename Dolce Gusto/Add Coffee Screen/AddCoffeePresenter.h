//
//  AddCoffeePresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/7/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCoffeeViewController.h"

@interface AddCoffeePresenter : NSObject

- (void)didPressNextWithName:(NSString *)name;
- (instancetype)initWithViewController:(AddCoffeeViewController *)viewController;

@end
