//
//  AddCoffeePresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/7/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCoffeePresenter.h"

@interface AddCoffeePresenter ()

@property (weak,nonatomic) AddCoffeeViewController *controller;
@property NSMutableArray *capsulesArray;
@property NSMutableArray *recipesArray;

@end

@implementation AddCoffeePresenter

- (instancetype)initWithViewController:(AddCoffeeViewController *)viewController {
    self = [super init];
    if (self) {
        _controller = viewController;
        _capsulesArray = [[NSMutableArray alloc] init];
        _recipesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didPressNextWithName:(NSString *)name {
    if ([name isEqualToString:@""]) {
        [self.controller showNoNameAlert];
    } else {
        [self.controller performSegueWithIdentifier:@"showCapsulesListSegue" sender:self.controller];
    }
}

@end
