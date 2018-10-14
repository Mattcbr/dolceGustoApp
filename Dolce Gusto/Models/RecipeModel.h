//
//  RecipeModel.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapsuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeModel : NSObject

@property NSString *recipeName;
@property NSMutableArray <CapsuleModel *> *capsulesArray;

- (instancetype)initWithName:(NSString *)name andCapsules:(NSMutableArray <CapsuleModel *> *)capsules;

@end

NS_ASSUME_NONNULL_END
