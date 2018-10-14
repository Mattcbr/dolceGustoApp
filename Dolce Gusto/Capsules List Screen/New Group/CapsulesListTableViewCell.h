//
//  CapsulesListTableViewCell.h
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapsuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapsulesListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *capsuleNameLabel;
-(void)setupCellForCapsule:(CapsuleModel *)capsule;

@end

NS_ASSUME_NONNULL_END
