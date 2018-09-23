//
//  MainScreenViewModel.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 9/23/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "MainScreenViewModel.h"

@implementation MainScreenViewModel

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(UIAlertController *)CoffeeNotAvailableAlert {
    UIAlertController *notAvailableAlert = [UIAlertController alertControllerWithTitle:@"Not Available"
                                                                               message:@"Sorry, but the function to add new coffee types is not available yet."
                                                                        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [notAvailableAlert addAction:defaultAction];
    return notAvailableAlert;
}

@end
