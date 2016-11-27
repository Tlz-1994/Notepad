//
//  CustomCell.m
//  NoteRecord
//
//  Created by stefanie on 16/4/16.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.size = CGSizeMake(26, 26);
        self.imageView.centerY = 25;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    self.imageView.size = CGSizeMake(26, 26);
    self.imageView.centerY = 25;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = CGSizeMake(26, 26);
    self.imageView.centerY = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
