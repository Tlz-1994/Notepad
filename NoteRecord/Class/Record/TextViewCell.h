//
//  TextViewCell.h
//  NoteRecord
//
//  Created by stefanie on 16/4/14.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordModel;

@interface TextViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, copy) RecordModel *recordModel;

@end
