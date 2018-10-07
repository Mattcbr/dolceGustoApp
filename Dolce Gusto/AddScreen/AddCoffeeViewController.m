//
//  addCoffeeViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/2/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "AddCoffeeViewController.h"

@interface AddCoffeeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *coffeeNameField;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UITextView *cofeeDescriptionTextView;
@property (strong, nonatomic) AddCoffeePresenter *presenter;

@end

@implementation AddCoffeeViewController

- (void)viewDidLoad{
    
    self.presenter = [[AddCoffeePresenter alloc] initWithViewController:self];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",self.screenType, self.coffeeType];
    if ([self.coffeeType isEqualToString: @"recipe"]){
        self.cofeeDescriptionTextView.hidden = false;
    } else {
        self.cofeeDescriptionTextView.hidden = true;
    }
}

- (IBAction)didPressSave {
    if([self.coffeeType isEqualToString: @"recipe"]){
        [self.presenter saveRecipe];
    } else if ([self.coffeeType isEqualToString: @"capsule"]){
        [self.presenter saveCapsuleWithName: self.coffeeNameField.text];
    }
}

- (IBAction)dismissScreen {
    [self.navigationController popViewControllerAnimated:YES];
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
