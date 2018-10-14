//
//  CapsulesListTableViewCell.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListTableViewCell.h"

@implementation CapsulesListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellForCapsule:(CapsuleModel *)capsule {
    self.capsuleNameLabel.text = capsule.capsuleName;
}

@end
