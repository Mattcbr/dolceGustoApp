//
//  MainScreenCollectionViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/9/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenCollectionViewController.h"

@interface MainScreenCollectionViewController ()

@end

@implementation MainScreenCollectionViewController

static NSString * const reuseIdentifier = @"CoffeeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NavBar Stuff
    UIBarButtonItem *addCoffeeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Add"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addCoffee)];
    
    self.navigationItem.rightBarButtonItem = addCoffeeButton;
    self.navigationItem.title = @"Dolce Gusto";
}

-(void)addCoffee {
    UIAlertController *notAvailableAlert = [UIAlertController alertControllerWithTitle:@"Not Available"
                                                                               message:@"Sorry, but the function to add new coffee types is not available yet."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [notAvailableAlert addAction:defaultAction];
    [self presentViewController:notAvailableAlert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
