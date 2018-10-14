//
//  AddCapsulePresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCapsulePresenter.h"
@interface AddCapsulePresenter ()

@property (weak,nonatomic) AddCapsuleViewController *controller;

@end

@implementation AddCapsulePresenter

- (instancetype)initWithController: (AddCapsuleViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)didPressSaveWithName:(NSString *)name andQuantity:(int *)quantity {
    if ([name isEqualToString:@""]){
        [self.controller showNoNameAlert];
    } else {
        CapsuleModel *newCapsule = [[CapsuleModel alloc] initWithName:name andQuantity:quantity];
        [self.delegate addNewCapsule:newCapsule];
        [self.controller.navigationController popViewControllerAnimated:YES];
    }
}

@end
