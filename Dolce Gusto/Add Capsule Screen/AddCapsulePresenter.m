//
//  AddCapsulePresenter.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCapsulePresenter.h"
#import "notificationsConstants.h"
#import "NSString+Validation.h"

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

- (void)didPressSaveWithName:(NSString *)name andQuantity:(NSInteger)quantity isEditing:(BOOL)isEditing {
    if (!name.isValidString){
        [self.controller showNoNameAlert];
    } else {
        if(isEditing){
            CapsuleModel *newCapsule = [[CapsuleModel alloc] initWithId:self.controller.selectedCapsule.capsuleId
                                                                   name:name
                                                               quantity:quantity
                                                            andRecipeId:self.controller.selectedCapsule.recipeId];
            [self.delegate editCapsule:newCapsule];
        } else {
            CapsuleModel *newCapsule = [[CapsuleModel alloc] initWithName:name andQuantity:quantity];
            [self.delegate addNewCapsule:newCapsule];
        }
        [self.controller.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteCapsule:(CapsuleModel *)capsule{    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDidDeleteCapsule
                                                       object:capsule];
    
    [self.delegate deleteCapsule: capsule];
    [self.controller.navigationController popViewControllerAnimated:YES];
}

@end
