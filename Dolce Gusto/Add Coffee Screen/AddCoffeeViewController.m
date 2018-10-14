//
//  addCoffeeViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/2/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCoffeeViewController.h"
#import "AddCoffeePresenter.h"
#import "CapsulesListViewController.h"

@interface AddCoffeeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *coffeeNameField;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (strong, nonatomic) AddCoffeePresenter *presenter;

@end

@implementation AddCoffeeViewController

- (void)viewDidLoad {
    self.presenter = [[AddCoffeePresenter alloc] initWithViewController:self];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Coffee",self.screenType];
}

- (IBAction)didPressNext {
    [self.presenter didPressNextWithName: self.coffeeNameField.text];
}

- (IBAction)dismissScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showNoNameAlert {
    UIAlertController *noNameAlert = [UIAlertController alertControllerWithTitle:@"Name not found"
                                                                         message:@"Your coffee should have a name"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [noNameAlert addAction:defaultAction];
    [self presentViewController:noNameAlert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CapsulesListViewController *capsulesListVC = segue.destinationViewController;
    capsulesListVC.recipeName = self.coffeeNameField.text;
}


@end
