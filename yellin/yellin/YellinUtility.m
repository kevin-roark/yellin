//
//  YellinUtility.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinUtility.h"

@implementation YellinUtility

+ (NSSet *)theChosenFew {
    NSSet *theFew = [NSSet setWithArray:@[KEVIN_USER_ID, DYLAN_USER_ID, HENRY_USER_ID]];
    return theFew;
}

+ (UILabel *)getTitleLabel:(NSString *)title {
    UILabel *returnLabel = [[UILabel alloc] init];
    returnLabel.text = title;
    returnLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    returnLabel.backgroundColor = [UIColor clearColor];
    returnLabel.textColor = [UIColor blackColor];
    return returnLabel;
}

+ (UIColor *)coolYellinColor {
    return [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1];
}

+ (UIColor *)warmYellinColor {
    return [UIColor colorWithRed:0.3 green:0.3 blue:0.8 alpha:1];
}

@end
