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

#pragma mark CapsuleDelegate

- (void)addNewCapsule:(nonnull CapsuleModel *)capsule {
    [self.capsulesArray addObject:capsule];
    [self.controller updateCapsulesArray:self.capsulesArray];
}

@end
