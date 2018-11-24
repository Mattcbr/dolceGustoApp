//
//  DetailsScreenViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/20/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "DetailsScreenViewController.h"
#import "DetailsScreenPresenter.h"

@interface DetailsScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *coffeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coffeDetailLabel;
@property (strong, nonatomic) DetailsScreenPresenter *presenter;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property NSMutableString *coffeeDetailsString;
@end

@implementation DetailsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.loadingIndicator startAnimating];
    // Do any additional setup after loading the view.
    self.presenter = [[DetailsScreenPresenter alloc] initWithViewController:self];
//    NSLog(@"Selected Recipe: %@", self.selectedRecipe.recipeName);
    self.coffeNameLabel.text = self.selectedRecipe.recipeName;
    self.coffeeDetailsString = [[NSMutableString alloc] init];
    [self.coffeeDetailsString appendString:[NSString stringWithFormat:@"To make this coffe you're going to need:\n"]];
    self.coffeDetailLabel.text = self.coffeeDetailsString;
    self.navigationItem.title = self.selectedRecipe.recipeName;
    
    [self.presenter getCapsulesForRecipe: self.selectedRecipe];
}

- (void)didReceiveCapsules {
    for (CapsuleModel *capsule in self.presenter.capsulesArray) {
        //get the name and add it to the string
        [self.coffeeDetailsString appendString:[NSString stringWithFormat:@"%@ (Level %i)\n",capsule.capsuleName, capsule.capsuleQuantity]];
    }
    self.coffeDetailLabel.text = self.coffeeDetailsString;
    [self.loadingIndicator stopAnimating];
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
