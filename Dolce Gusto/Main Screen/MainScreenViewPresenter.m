//
//  MainScreenViewPresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewPresenter.h"

@implementation MainScreenViewPresenter

-(void)initWithViewController: (MainScreenCollectionViewController *)viewController {
    self.controller = viewController;
}

-(void)didPressAddCoffee{
    [self.controller presentAddAlert];
}

@end
