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

@interface CapsulesListViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *coffeeNameField;
@property (weak, nonatomic) IBOutlet UITableView *capsulesListTableView;
@property (strong, nonatomic) CapsulesListPresenter *presenter;
@property NSMutableArray *capsulesArray;
@property (weak, nonatomic) IBOutlet UILabel *noCapsuleLabel;

@end

@implementation CapsulesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.presenter = [[CapsulesListPresenter alloc]initWithViewController:self];
    self.capsulesArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ recipe", self.screenType];
    
    self.coffeeNameField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.capsulesArray.count == 0){
        self.noCapsuleLabel.hidden = NO;
    } else {
        self.noCapsuleLabel.hidden = YES;
    }
}

#pragma mark - Save Handling

-(IBAction)didPressSave {
    if ([self.coffeeNameField.text isEqualToString:@""]){
        [self displayErrorWithType:@"missingName"];
    } else if (self.capsulesArray.count < 1){
        [self displayErrorWithType:@"missingCapsules"];
    } else {
        RecipeModel *newRecipe = [[RecipeModel alloc] initWithName:self.coffeeNameField.text
                                                   andCapsules:self.capsulesArray];
    
        [self.delegate addNewRecipe:newRecipe];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Data update

-(void)updateCapsulesArray:(NSMutableArray *)array {
    self.capsulesArray = array;
    self.capsulesListTableView.dataSource = self;
    self.capsulesListTableView.hidden = NO;
    [self.capsulesListTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.capsulesArray.count;
}

- (CapsulesListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CapsulesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CapsuleCell"];
    
    CapsuleModel *capsule = self.capsulesArray[indexPath.row];
    [cell setupCellForCapsule:capsule];
    
    return cell;
}

#pragma mark - Error Handling

- (void)displayErrorWithType:(NSString *)type {
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddNewCapsule"]) {
        AddCapsuleViewController *addCapsuleVC = segue.destinationViewController;
        addCapsuleVC.delegate = self.presenter;
        
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
