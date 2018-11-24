//
//  DetailsScreenViewController.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/20/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsScreenViewController : UIViewController

@property (weak, nonatomic )RecipeModel *selectedRecipe;

- (void)didReceiveCapsules;

@end

NS_ASSUME_NONNULL_END
