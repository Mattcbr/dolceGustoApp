//
//  CapsulesListViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "CapsulesListViewController.h"
#import "CapsulesListPresenter.h"
#import "AddCapsuleViewController.h"
#import "AddCapsulePresenter.h"
#import "CapsulesListTableViewCell.h"
#import "RecipeModel.h"

@interface CapsulesListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *coffeeNameField;
@property (weak, nonatomic) IBOutlet UITableView *capsulesListTableView;
@property (strong, nonatomic) CapsulesListPresenter *presenter;
@property (weak, nonatomic) IBOutlet UILabel *noCapsuleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteRecipeButton;
@property CapsuleModel *selectedCapsule;
@property BOOL isEditing;

@end

@implementation CapsulesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.presenter = [[CapsulesListPresenter alloc]initWithViewController:self];
    self.isEditing = NO;
    
    if(self.capsulesArray.count > 0){
        self.presenter.capsulesArray = self.capsulesArray;
    }
    
    if(self.recipe.recipeId){
        [self populateFieldsFromSelectedRecipe];
        self.isEditing = YES;
    }
    
    self.deleteRecipeButton.hidden = !self.isEditing;
    
    NSString *titleString;
    if (self.isEditing) {
        titleString = @"Edit Recipe";
    } else {
        titleString = @"Add Recipe";
    }
    
    self.navigationItem.title = titleString;
    
    self.coffeeNameField.delegate = self;
    self.capsulesListTableView.delegate = self;
    self.capsulesListTableView.dataSource = self;
}

-(void)populateFieldsFromSelectedRecipe {
    self.coffeeNameField.text = self.recipe.recipeName;
    
    [self.capsulesListTableView reloadData];
}

- (NSUInteger)selectedCapsuleIndex {
    return [self.presenter.capsulesArray indexOfObject:self.selectedCapsule];
}

- (IBAction)didPressDeleteButton:(id)sender {
    [self showDeleteAlert];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noCapsuleLabel.hidden = (self.presenter.capsulesArray.count > 0);
    self.selectedCapsule = [[CapsuleModel alloc] init];
}

#pragma mark - Save Handling

-(IBAction)didPressSave {
    [self.presenter didPressSaveWithCoffeeName:self.coffeeNameField.text andCapsules:self.presenter.capsulesArray isEditing:self.isEditing];
}

#pragma mark - Data update

-(void)didUpdateCapsulesArray {
    [self.capsulesListTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.capsulesArray.count;
}

- (CapsulesListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CapsulesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CapsuleCell"];
    
    CapsuleModel *capsule = self.presenter.capsulesArray[indexPath.row];
    [cell setupCellForCapsule:capsule];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCapsule = [self.presenter.capsulesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showAddNewCapsule" sender:self];
}

#pragma mark - Error Handling

-(void)displayErrorWithType:(NSString *)type {
    UIAlertController *alert;
    if ([type isEqualToString:@"missingName"]){
        alert = [UIAlertController alertControllerWithTitle:@"Missing Name"
                                                    message:@"Please, add a name to your recipe."
                                             preferredStyle:UIAlertControllerStyleAlert];
    } else if ([type isEqualToString:@"missingCapsules"]){
        alert = [UIAlertController alertControllerWithTitle:@"Add Capsules"
                                                    message:@"Every recipe should have at least one capsule"
                                             preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDeleteAlert {
    UIAlertController *deleteRecipeAlert = [UIAlertController alertControllerWithTitle:@"Delete Recipe"
                                                                                message:@"Are you sure you want to delete this recipe?\n This cannot be undone"
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self deleteRecipe:self.recipe];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [deleteRecipeAlert addAction:deleteAction];
    [deleteRecipeAlert addAction:cancelAction];
    [self presentViewController:deleteRecipeAlert animated:YES completion:nil];
}

- (void)deleteRecipe:(RecipeModel*)recipe {
    [self.presenter deleteRecipe:recipe];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddNewCapsule"]) {
        AddCapsuleViewController *addCapsuleVC = segue.destinationViewController;
        addCapsuleVC.delegate = self.presenter;
        if(self.recipe.recipeId){
            addCapsuleVC.selectedCapsule = self.selectedCapsule;
        }
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
