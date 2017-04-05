//
//  RecordCell.m
//  NoteRecord
//
//  Created by stefanie on 16/4/18.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "RecordCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "RecordModel.h"

@implementation RecordCell
{
    UILabel *_messageLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_positionLabel;
    UILabel *_placeLabel;
    UILabel *_weatherLabel;
    UILabel *_timelabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    _messageLabel.textColor = LZColor(0, 0, 0);
    _messageLabel.numberOfLines = 0;
    
    _picContainerView = [[SDWeiXinPhotoContainerView alloc] init];
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.font = [UIFont systemFontOfSize:12.0];
    _positionLabel.textColor = LZColor(54, 71, 121);
    
    _placeLabel = [[UILabel alloc] init];
    _placeLabel.font = [UIFont systemFontOfSize:12.0];
    _placeLabel.textColor = LZColor(54, 71, 121);
    
    _weatherLabel = [[UILabel alloc] init];
    _weatherLabel.font = [UIFont systemFontOfSize:12.0];
    _weatherLabel.textColor = LZColor(54, 71, 121);
    
    _timelabel = [[UILabel alloc] init];
    _timelabel.font = [UIFont systemFontOfSize:12.0];
    _timelabel.textColor = LZColor(54, 71, 121);
    _timelabel.textAlignment = NSTextAlignmentRight;
    
    NSArray *views = @[_messageLabel, _picContainerView, _positionLabel, _placeLabel, _weatherLabel, _timelabel];
    [self.contentView sd_addSubviews:views];
    
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    _messageLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(_messageLabel);
    
    _positionLabel.sd_layout
    .leftEqualToView(_messageLabel)
    .topSpaceToView(_picContainerView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(14);
    
    _weatherLabel.sd_layout
    .leftEqualToView(_messageLabel)
    .topSpaceToView(_positionLabel, 3)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _placeLabel.sd_layout
    .leftEqualToView(_messageLabel)
    .topSpaceToView(_weatherLabel, 3)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _timelabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_placeLabel, 3)
    .heightIs(13);
    
    [self setupAutoHeightWithBottomView:_timelabel bottomMargin:5];
}

- (void)setModel:(RecordModel *)model {
    _model = model;
    if (model.message) {
        _messageLabel.text = model.message;
    }
    else {
        _messageLabel.text = nil;
    }
    CGFloat picContainerTopMargin = 0;
    if (model.photoUrl) {
        _picContainerView.picPathStringsArray = @[model.photoUrl];
        picContainerTopMargin = 5;
    }
    else {
        _picContainerView.picPathStringsArray = nil;
        picContainerTopMargin = 0;
    }
    _picContainerView.sd_layout.topSpaceToView(_messageLabel, picContainerTopMargin);
    _positionLabel.text = model.position;
    _placeLabel.text = model.place;
    _timelabel.text = model.time;
    _weatherLabel.text = model.weather;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
