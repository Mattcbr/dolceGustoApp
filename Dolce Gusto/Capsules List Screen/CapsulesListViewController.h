//
//  CapsulesListViewController.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapsuleModel.h"
#import "SaveRecipeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapsulesListViewController : UIViewController

@property (nonatomic, weak) id<SaveRecipeDelegate> delegate;
@property NSMutableArray<CapsuleModel *> *capsulesList;
@property NSString *screenType;

-(void)updateCapsulesArray:(NSMutableArray *)array;
-(void)displayErrorWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
