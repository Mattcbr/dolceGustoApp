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

@interface CapsulesListViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<SaveRecipeDelegate> delegate;
@property NSMutableArray <CapsuleModel *> *capsulesList;
-(void)updateCapsulesArray:(NSMutableArray *)array;
@property NSString *screenType;

@end

NS_ASSUME_NONNULL_END
