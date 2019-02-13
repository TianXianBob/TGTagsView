//
//  NSString+TG.h
//  TGTagsView
//
//  Created by Bob on 2017/5/8.
//  Copyright © 2017年 tugou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (TG)
+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isNotEmpty:(NSString *)str;
/**
 *  根据文字（宽度/高度一定,字号一定的情况下）  算出高度/宽度
 *  @brief  根据一定高度/宽度返回宽度/高度
 *  @category
 *    @param     goalString            目标字符串
 *    @param     font;                 字号
 *    @param     fixedSize;            固定的宽/高
 *    @param     isWidth;              是否是宽固定(用于区别宽/高)
 **/

+ (CGSize)getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth;
@end
