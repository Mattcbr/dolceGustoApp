//
//  addCoffeeViewController.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 10/2/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "addCoffeeViewController.h"

@interface AddCoffeeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *coffeeNameField;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation AddCoffeeViewController

- (void)viewDidLoad{
    self.navigationItem.title = [NSString stringWithFormat:@"Add %@",self.screenType];
}

- (IBAction)didPressSave {
    
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
