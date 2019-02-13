//
//  DefaultTagsTableViewCell.m
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import "DefaultTagsTableViewCell.h"

@interface DefaultTagsTableViewCell ()
@property (nonatomic, strong) TGTagsViewCustomNature *customNature;
@end

@implementation DefaultTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configContents:(NSArray *)contents {
    TGTagsView *v = self.tagsView;
    NSDictionary *tagsInfoMap = [v configDataArrayWithArray:contents customNature:self.customNature selectHandler:^(NSInteger index, NSString *content) {
        NSLog(@"当前点击第%ld个，内容是%@",index,content);
    }];
    CGFloat height = ((NSString *)tagsInfoMap[K_TAGS_VIEW_H]).floatValue;
    v.frame = CGRectMake(0, 0, 375, height);
}

- (TGTagsViewCustomNature *)customNature {
    if (!_customNature) {
        TGTagsViewCustomNature *nature = [[TGTagsViewCustomNature alloc] init];
        _customNature = nature;
        nature.fontSize = 12;
        nature.textColor = [UIColor orangeColor];
        nature.borderColor = [UIColor orangeColor];
        nature.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        nature.itemSpace = 10;
        nature.lineSpace = 12;
        nature.itemHorizonInset = 12;
        nature.itemCornerRaduis = 11;
    }
    return _customNature;
}

@end
