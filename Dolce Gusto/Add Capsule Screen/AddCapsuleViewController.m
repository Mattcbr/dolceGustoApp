//
//  AddCapsuleViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCapsuleViewController.h"
#import "AddCapsulePresenter.h"

@interface AddCapsuleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *capsuleNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (strong, nonatomic) AddCapsulePresenter *presenter;
@property NSInteger quantity;
@end

@implementation AddCapsuleViewController

@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_capsuleNameTextField setDelegate:self];
    self.quantity = 1;
    self.quantityLabel.text = [NSString stringWithFormat: @"Quantidade de traços: %d", self.quantity];
}
- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    self.quantity = (int) value;
    self.quantityLabel.text = [NSString stringWithFormat:@"Quantidade de traços: %d", self.quantity];
}

- (IBAction)didPressSave {
    [self.presenter didPressSaveWithName: self.capsuleNameTextField.text andQuantity: self.quantity];
}

- (void)showNoNameAlert {
    UIAlertController *noNameAlert = [UIAlertController alertControllerWithTitle:@"Name not found"
                                                                         message:@"Your capsule should have a name"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [noNameAlert addAction:defaultAction];
    [self presentViewController:noNameAlert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (AddCapsulePresenter *)presenter {
    if (_presenter == nil) {
        _presenter = [[AddCapsulePresenter alloc] initWithController:self];
    }
    return _presenter;
}

- (id<AddCapsuleDelegate>)delegate {
    return self.presenter.delegate;
}

- (void)setDelegate:(id<AddCapsuleDelegate>)delegate {
    self.presenter.delegate = delegate;
}

@end
