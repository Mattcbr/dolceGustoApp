//
//  MainScreenCollectionViewCell.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/16/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeModel.h"

@interface MainScreenCollectionViewCell : UICollectionViewCell

-(void)setCellForRecipe:(RecipeModel *)recipe;

@end
