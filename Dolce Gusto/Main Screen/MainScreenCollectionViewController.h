//
//  MainScreenCollectionViewController.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenCollectionViewCell.h"

@interface MainScreenCollectionViewController : UICollectionViewController

-(void)reloadWithArray:(NSMutableArray *)recipesArray;

@end
