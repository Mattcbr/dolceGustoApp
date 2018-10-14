//
//  MainScreenCollectionViewCell.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/16/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenCollectionViewCell.h"

@interface MainScreenCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *coffeeImageView;
@property (strong, nonatomic) IBOutlet UILabel *coffeeNameLabel;

@end


@implementation MainScreenCollectionViewCell

-(void)setCellForRecipe:(RecipeModel *)recipe{
    self.coffeeNameLabel.text = recipe.recipeName;
}

@end
