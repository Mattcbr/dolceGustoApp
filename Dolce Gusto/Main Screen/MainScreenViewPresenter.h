//
//  MainScreenViewPresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenCollectionViewController.h"

@interface MainScreenViewPresenter : NSObject

-(instancetype)initWithViewController: (MainScreenCollectionViewController *)viewController;
@property (weak,nonatomic) MainScreenCollectionViewController *controller;

@end
