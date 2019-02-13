//
//  NSString+TG.m
//  TGTagsView
//
//  Created by Bob on 2017/5/8.
//  Copyright © 2017年 tugou.com. All rights reserved.
//

#import "NSString+TG.h"

@implementation NSString (TG)

+ (BOOL)isEmpty:(NSString *)str {
    return str == nil || str.length == 0;
}

+ (BOOL)isNotEmpty:(NSString *)str {
    return ![self isEmpty:str];
}


+ (CGSize)getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth{
    
    CGSize  sizeC ;
    
    if (isWidth) {
        sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    }else{
        sizeC = CGSizeMake(MAXFLOAT ,fixedSize);
    }
    
    CGSize sizeFileName = [goalString boundingRectWithSize:sizeC
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                                     context:nil].size;
    return sizeFileName;
}
@end
