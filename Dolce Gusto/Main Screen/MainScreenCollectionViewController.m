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

@interface MainScreenCollectionViewController ()

@property (strong, nonatomic) MainScreenViewPresenter *presenter;
@property NSMutableArray *recipesArray;
@property (weak, nonatomic) IBOutlet UILabel *noCoffeeLabel;

@end

@implementation MainScreenCollectionViewController

static NSString * const reuseIdentifier = @"CoffeeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipesArray = [[NSMutableArray alloc] init];
    self.presenter = [[MainScreenViewPresenter alloc] initWithViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Add Button Handler
-(IBAction)didPressAdd {
    [self performSegueWithIdentifier:@"showAddScreenSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"showAddScreenSegue"]) {
         CapsulesListViewController *destinationVC = segue.destinationViewController;
         destinationVC.delegate = self.presenter;
         destinationVC.screenType = @"Add";
     }
}

#pragma mark - Delegate Called Method
-(void)reloadWithArray:(NSMutableArray *)recipesArray {
    self.recipesArray = recipesArray;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.recipesArray.count == 0){
        self.noCoffeeLabel.hidden = NO;
    } else {
        self.noCoffeeLabel.hidden = YES;
    }
    return self.recipesArray.count;
}

- (MainScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    RecipeModel *Recipe = self.recipesArray[indexPath.row];
    
    [cell setCellForRecipe:Recipe];
    
    return cell;
}

@end
