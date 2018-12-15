//
//  DetailsScreenViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 11/20/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "DetailsScreenViewController.h"
#import "DetailsScreenPresenter.h"
#import "CapsulesListViewController.h"

@interface DetailsScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *coffeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coffeDetailLabel;
@property (strong, nonatomic) DetailsScreenPresenter *presenter;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation DetailsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.loadingIndicator startAnimating];
    self.presenter = [[DetailsScreenPresenter alloc] initWithViewController:self];
    self.coffeNameLabel.text = self.selectedRecipe.recipeName;
   //Criar o método refresh, tirar de property
    self.coffeDetailLabel.text = @"Loading...";
    self.navigationItem.title = self.selectedRecipe.recipeName;
    
    [self.presenter getCapsulesForRecipe: self.selectedRecipe];
}

- (void)didReceiveCapsules {
    NSMutableString *capsulesDetailsString = [@"To make this coffe you're going to need:\n" mutableCopy];
    for (CapsuleModel *capsule in self.presenter.capsulesArray) {
        [capsulesDetailsString appendString:[NSString stringWithFormat:@"%@ (Level %li)\n",capsule.capsuleName, capsule.capsuleQuantity]];
    }
    self.coffeDetailLabel.text = capsulesDetailsString;
    [self.loadingIndicator stopAnimating];
}

- (IBAction)didPressEditButton:(id)sender {
    [self performSegueWithIdentifier:@"editRecipeSegue" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editRecipeSegue"]){
        CapsulesListViewController *destination = segue.destinationViewController;
        destination.recipe = self.selectedRecipe;
        destination.capsulesArray = self.presenter.capsulesArray;
    }
}

@end
