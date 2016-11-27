//
//  LZLabel.m
//  NoteRecord
//
//  Created by stefanie on 16/4/14.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "LZLabel.h"

@implementation LZLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = LZColor(173, 216, 230);
    }
    return self;
}

@end
