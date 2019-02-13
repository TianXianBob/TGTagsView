//
//  OptionalTagsViewTableViewCell.m
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import "OptionalTagsViewTableViewCell.h"

@interface OptionalTagsViewTableViewCell ()
@property (nonatomic, strong) TGTagsViewCustomNature *customNature;
@end

@implementation OptionalTagsViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configContents:(NSArray *)contents {
    if (!contents) return;
    
    TGTagsView *v = self.tagsView;
    
    self.customNature.defaultSelectedArray = @[contents.firstObject];
    self.customNature.defaultEnableArray = @[contents.lastObject];
    NSDictionary *tagsInfoMap = [v configDataArrayWithArray:contents customNature:self.customNature selectHandler:^(NSInteger index, NSString *content) {
        NSLog(@"当前点击第%ld个，内容是%@",index,content);
    }];
    CGFloat height = ((NSString *)tagsInfoMap[K_TAGS_VIEW_H]).floatValue;
    v.frame = CGRectMake(0, 0, 375, height);
}


- (TGTagsViewCustomNature *)customNature {
    if (!_customNature) {
        _customNature = [[TGTagsViewCustomNature alloc] init];
        _customNature.itemHorizonInset = 8;
        _customNature.textColor = TGRGBColorAlpha(68,68,68,1);
        _customNature.itemBgColor = TGRGBColorAlpha(246,246,246,1);
        _customNature.itemHeight = 32;
        _customNature.lineSpace = 12;
        _customNature.fontSize = 12;
        _customNature.itemSpace = 16;
        _customNature.contentInset = UIEdgeInsetsMake(12, 0, 16, 0);
        _customNature.selectBgImage = [UIImage imageNamed:@"selectedBorder"];
        _customNature.selectBgColor = [UIColor whiteColor];
        _customNature.selectTitleColor = TGRGBColorAlpha(255, 75, 0, 1);
        _customNature.isOption = YES;
        _customNature.itemCornerRaduis = 1.0f;
        _customNature.enableTextColor = TGRGBColorAlpha(204,204,204,1);
    }
    return _customNature;
}
@end
