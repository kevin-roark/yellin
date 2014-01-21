//
//  YellinMakeYellView.m
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMakeYellView.h"

@implementation YellinMakeYellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.recordButton = [[UIButton alloc]
                             initWithFrame:CGRectMake(self.frame.size.width - 300, self.frame.size.height - 220, 150, 150)];
        self.recordButton.backgroundColor = [UIColor redColor];
        self.recordButton.layer.cornerRadius = 75;
        [self addSubview:self.recordButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
