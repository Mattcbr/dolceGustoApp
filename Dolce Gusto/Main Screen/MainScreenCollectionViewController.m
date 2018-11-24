//
//  MainScreenCollectionViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenCollectionViewController.h"
#import "MainScreenViewPresenter.h"
#import "CapsulesListViewController.h"
#import "DetailsScreenViewController.h"

@interface MainScreenCollectionViewController ()

@property (strong, nonatomic) MainScreenViewPresenter *presenter;
@property (weak, nonatomic) IBOutlet UILabel *noCoffeeLabel;

@end

@implementation MainScreenCollectionViewController

static NSString * const reuseIdentifier = @"CoffeeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[MainScreenViewPresenter alloc] initWithViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    //Adicionar o metodo pra chamar o DB no presenter
}

#pragma mark - Add Button Handler
-(IBAction)didPressAdd {
    [self.presenter didPressAdd];
}

#pragma mark - Navigation
-(void)showAddScreen {
    [self performSegueWithIdentifier:@"showAddScreenSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showAddScreenSegue"]) {
         CapsulesListViewController *destinationVC = segue.destinationViewController;
         destinationVC.delegate = [self.presenter createSaveRecipeDelegate];
         destinationVC.screenType = @"Add";
     } else if ([segue.identifier isEqualToString:@"showDetailsScreenSegue"]) {
         DetailsScreenViewController *destinationVC = segue.destinationViewController;
//         destinationVC.selectedRecipe =
//         MainScreenCollectionViewCell *selectedCell = sender;
         NSArray *arrayOfPaths = self.collectionView.indexPathsForSelectedItems;
         NSIndexPath *selectedIndexPath = arrayOfPaths.firstObject;
         RecipeModel *selectedRecipe = [self.presenter.recipesArray objectAtIndex:selectedIndexPath.row];
//         destinationVC =
         [destinationVC setSelectedRecipe:selectedRecipe];
         
         UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
         button.title = @"";
         self.navigationItem.backBarButtonItem = button;
     }
}

#pragma mark - Delegate Called Method
-(void)reloadRecipes {
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.noCoffeeLabel.hidden = (self.presenter.recipesArray.count > 0);
    
    return self.presenter.recipesArray.count;
}

- (MainScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    RecipeModel *recipe = self.presenter.recipesArray[indexPath.row];
    
    [cell setCellForRecipe:recipe];
    
    return cell;
}

@end
