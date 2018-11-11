//
//  CapsulesListTableViewCell.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/13/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListTableViewCell.h"

@interface CapsulesListTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *capsuleNameLabel;

@end

@implementation CapsulesListTableViewCell

-(void)setupCellForCapsule:(CapsuleModel *)capsule {
    self.capsuleNameLabel.text = capsule.capsuleName;
}

@end
