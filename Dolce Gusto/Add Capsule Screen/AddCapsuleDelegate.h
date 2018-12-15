//
//  AddCapsuleDelegate.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/11/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsuleModel.h"
#import <Foundation/Foundation.h>

@protocol AddCapsuleDelegate <NSObject>

- (void)addNewCapsule:(CapsuleModel *)capsule;
- (void)editCapsule:(CapsuleModel *)capsule;
- (void)deleteCapsule:(CapsuleModel *)capsule;

@end
