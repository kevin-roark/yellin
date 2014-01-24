//
//  YellinUtility.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YellinConstants.h"

@interface YellinUtility : NSObject

+ (NSSet *) theChosenFew;

+ (UILabel *)getTitleLabel:(NSString *)title;

+ (UIColor *)coolYellinColor;
+ (UIColor *)warmYellinColor;

+ (UIColor *)lighterRecordColor;

+ (UIColor *)yellinGreen;
+ (UIColor *)lighterYellinGreen;

+ (UIColor *)sendColor;
+ (UIColor *)lighterSendColor;

@end
