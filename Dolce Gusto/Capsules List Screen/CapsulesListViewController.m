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

@interface CapsulesListViewController () <UITableViewDataSource, UITextViewDelegate>

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
    self.capsulesArray = [[NSMutableArray alloc] init]; //Tentar remover
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ recipe", self.screenType];
    
    self.coffeeNameField.delegate = self;
    self.capsulesListTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.noCapsuleLabel.hidden = (self.capsulesArray.count > 0);
}

#pragma mark - Save Handling

-(IBAction)didPressSave {
    [self.presenter didPressSaveWithCoffeeName:self.coffeeNameField.text andCapsules:self.capsulesArray];
}

#pragma mark - Data update

-(void)updateCapsulesArray:(NSMutableArray *)array {
    self.capsulesArray = array;
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

#pragma mark - Navigation
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
