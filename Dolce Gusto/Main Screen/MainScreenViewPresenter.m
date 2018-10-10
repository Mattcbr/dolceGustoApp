//
//  MainScreenViewPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewPresenter.h"

@implementation MainScreenViewPresenter

- (instancetype)initWithViewController:(MainScreenCollectionViewController *)viewController
{
    self = [super init];
    if (self) {
        self.controller = viewController;
    }
    return self;
}

@end
