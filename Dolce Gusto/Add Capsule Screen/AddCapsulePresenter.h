//
//  AddCapsulePresenter.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCapsuleViewController.h"
#import "AddCapsuleDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCapsulePresenter : NSObject

@property (nonatomic, weak) id<AddCapsuleDelegate> delegate;

- (instancetype)initWithController: (AddCapsuleViewController *)controller;
- (void)didPressSaveWithName:(NSString *)name andQuantity:(int *)quantity;

@end

NS_ASSUME_NONNULL_END
