//
//  CapsuleModel.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsuleModel.h"

@implementation CapsuleModel

- (instancetype)initWithName:(NSString *)name andQuantity:(NSInteger *)quantity {
    self = [super init];
    if (self) {
        _capsuleName = name;
        _capsuleQuantity = quantity;
    }
    return self;
}

@end
