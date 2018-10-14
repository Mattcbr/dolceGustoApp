//
//  CapsuleModel.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CapsuleModel : NSObject

@property NSString *capsuleName;
@property NSInteger *capsuleQuantity;
- (instancetype)initWithName:(NSString *)name andQuantity:(NSInteger *)quantity;

@end

NS_ASSUME_NONNULL_END
