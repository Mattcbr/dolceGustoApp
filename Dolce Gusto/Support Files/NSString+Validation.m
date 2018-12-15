//
//  NSString+Validation.m
//  Dolce Gusto
//
//  Created by Matheus Queiroz on 12/10/18.
//  Copyright © 2018 mattcbr. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString(Validation)

- (BOOL)isValidString {
    NSString *stringToValidate = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([stringToValidate isEqualToString:@""]){
        return NO;
    }
    return YES;
}

@end
