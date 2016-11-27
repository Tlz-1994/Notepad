//
//  TextViewCell.m
//  NoteRecord
//
//  Created by stefanie on 16/4/14.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "TextViewCell.h"

#import "RecordModel.h"

@implementation TextViewCell 
{
    UITextView *_textView;        // 文本编辑框
    UIImageView *_sendImageView;  // 要保存的图片
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
        // 接收发送的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithNotifaction) name:NOTIFACTION_SEND object:nil];
    }
    return self;
}

- (void)loadUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kWidth-20, 90)];
    _textView.delegate = self;
    _textView.font = [UIFont fontWithName:@"Arial" size:16.0];
    _textView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_textView];
    [_textView becomeFirstResponder];
}

- (void)setRecordModel:(RecordModel *)recordModel {
    // 如果包含照片
    if (recordModel.photoUrl) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[FILE_PATH stringByAppendingPathComponent:recordModel.photoUrl]]];
        _sendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 100, 80, 80)];
        _sendImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_sendImageView];
        _sendImageView.image = image;
        NSLog(@"photourl %@", recordModel.photoUrl);
    }
}

- (void)dealWithNotifaction {
    if (_textView.text.length > 0) {
        [LZNSUserDefaults setValue:_textView.text forKey:MESSAGE_SEND];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
