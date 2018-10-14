//
//  RecipeModel.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "RecipeModel.h"

@implementation RecipeModel

- (instancetype)initWithName:(NSString *)name andCapsules:(NSMutableArray <CapsuleModel *> *)capsules {
    self = [super init];
    if (self) {
        _recipeName = name;
        _capsulesArray = capsules;
    }
    return self;
}

@end
