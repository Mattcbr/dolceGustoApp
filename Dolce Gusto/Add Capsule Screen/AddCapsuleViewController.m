//
//  AddCapsuleViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCapsuleViewController.h"

@interface AddCapsuleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *capsuleNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;

@end

@implementation AddCapsuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quantityLabel.text = @"Quantidade de traços: 1";
}
- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    self.quantityLabel.text = [NSString stringWithFormat:@"Quantidade de traços: %d", (int)value];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
