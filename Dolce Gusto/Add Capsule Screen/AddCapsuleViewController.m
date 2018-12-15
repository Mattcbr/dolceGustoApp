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
@property (assign, nonatomic) NSInteger quantity;
@property (weak, nonatomic) IBOutlet UIButton *deleteCapsuleButton;
@property BOOL isEditing;
@end

@implementation AddCapsuleViewController

@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quantity = 1;
    self.deleteCapsuleButton.hidden = YES;
    self.isEditing = NO;
    if(self.selectedCapsule.recipeId){
        self.deleteCapsuleButton.hidden = NO;
        self.isEditing = YES;
        self.capsuleNameTextField.text = self.selectedCapsule.capsuleName;
        self.quantity = self.selectedCapsule.capsuleQuantity;
        [self.quantityStepper setValue:(double)self.selectedCapsule.capsuleQuantity];
    }
    
    [_capsuleNameTextField setDelegate:self];
}

- (void)setQuantity:(NSInteger)quantity {
    _quantity = quantity;
    self.quantityLabel.text = [NSString stringWithFormat:@"Quantidade de traços: %ld", (long)self.quantity];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    self.quantity = (int) value;
}

- (IBAction)didPressSave {
    [self.presenter didPressSaveWithName: self.capsuleNameTextField.text andQuantity: self.quantity isEditing:self.isEditing];
}

- (IBAction)didPressDelete:(id)sender {
    [self showDeleteAlert];
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

- (void)showDeleteAlert {
    UIAlertController *deleteCapsuleAlert = [UIAlertController alertControllerWithTitle:@"Delete Capsule"
                                                                         message:[NSString stringWithFormat:@"Are you sure you want to delete %@ from your recipe?\nThis can't be undone", self.selectedCapsule.capsuleName]
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                            style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self deleteCapsule:self.selectedCapsule];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    [deleteCapsuleAlert addAction:deleteAction];
    [deleteCapsuleAlert addAction:cancelAction];
    [self presentViewController:deleteCapsuleAlert animated:YES completion:nil];
}

- (void)deleteCapsule:(CapsuleModel *)capsule {
    [self.presenter deleteCapsule: capsule];
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
