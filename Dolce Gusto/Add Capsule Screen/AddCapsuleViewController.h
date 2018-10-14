//
//  AddCapsuleViewController.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCapsuleDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCapsuleViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<AddCapsuleDelegate> delegate;

- (void)showNoNameAlert;

@end

NS_ASSUME_NONNULL_END
