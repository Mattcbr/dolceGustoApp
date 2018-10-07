//
//  MainScreenCollectionViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenCollectionViewController.h"
#import "MainScreenViewModel.h"
#import "MainScreenViewPresenter.h"
#import "AddCoffeeViewController.h"

@interface MainScreenCollectionViewController ()

@property (strong, nonatomic) MainScreenViewPresenter *presenter;
@property NSString *addAlertScreenType;
@property NSString *addAlertCoffeeType;

@end

@implementation MainScreenCollectionViewController

static NSString * const reuseIdentifier = @"CoffeeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[MainScreenViewPresenter alloc] initWithViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Add Button Handler
-(IBAction)didPressAdd {
    [self.presenter didPressAdd];
}

#pragma mark - Alerts
-(void)presentAddAlert {
    UIAlertController *typeSelectAlert = [UIAlertController alertControllerWithTitle:@"Add new"
                                                                             message:@"What do you want to add?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* recipeAction = [UIAlertAction actionWithTitle:@"Recipe"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self didPressRecipe];
                                                          }];
    UIAlertAction* capsuleAction = [UIAlertAction actionWithTitle:@"Capsule"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self didPressCapsule];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    [typeSelectAlert addAction:recipeAction];
    [typeSelectAlert addAction:capsuleAction];
    [typeSelectAlert addAction:cancelAction];
    [self presentViewController:typeSelectAlert animated:TRUE completion:nil];
}

#pragma mark - Add Coffe Alert Handlers
-(void)didPressRecipe {
    self.addAlertScreenType = @"Add";
    self.addAlertCoffeeType = @"recipe";
    [self performSegueWithIdentifier:@"showAddScreenSegue" sender:self];
}

-(void)didPressCapsule {
    self.addAlertScreenType = @"Add";
    self.addAlertCoffeeType = @"capsule";
    [self performSegueWithIdentifier:@"showAddScreenSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"showAddScreenSegue"]){
         AddCoffeeViewController *destinationVC = segue.destinationViewController;
         destinationVC.screenType = self.addAlertScreenType;
         destinationVC.coffeeType = self.addAlertCoffeeType;
     }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (MainScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
