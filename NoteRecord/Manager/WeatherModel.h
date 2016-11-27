//
//  WeatherModel.h
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic, copy) NSString *WD;
@property (nonatomic, copy) NSString *WS;
@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *citycode;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *h_tmp;
@property (nonatomic, copy) NSString *l_tmp;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *sunrise;
@property (nonatomic, copy) NSString *sunset;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *weather;


@end
