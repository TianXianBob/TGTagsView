//
//  VerticalTagsTableViewCell.m
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import "VerticalTagsTableViewCell.h"
#import "NSString+TG.h"
#import "UIButton+TG.h"
#import "TGFlashingView.h"

@interface VerticalTagsTableViewCell ()<TGTagsViewDelegate>
@property (nonatomic, strong) TGTagsViewCustomNature *customNature;
@end

@implementation VerticalTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configContents:(NSArray *)contents {
    TGTagsView *v = self.tagsView;
    v.delegate = self;
    NSDictionary *tagsInfoMap = [v configDataArrayWithArray:contents customNature:self.customNature selectHandler:^(NSInteger index, NSString *content) {
        NSLog(@"当前点击第%ld个，内容是%@",index,content);
    }];
    NSNumber *height = tagsInfoMap[K_TAGS_VIEW_H];
    NSNumber *width = tagsInfoMap[K_TAGS_VIEW_W];
    v.frame = CGRectMake(0, 0, width.floatValue, height.floatValue);
}

- (TGTagsViewCustomNature *)customNature {
    if (!_customNature) {
        TGTagsViewCustomNature *nature = [[TGTagsViewCustomNature alloc] init];
        _customNature = nature;
        nature.isHorizonLayout = NO;
        nature.contentHeight = 200;
        nature.lineSpace = 12;
    }
    return _customNature;
}

#pragma mark - TGTagsViewDelegate
- (CGFloat)itemWidthWithContent:(id)content index:(NSInteger)index {
    CGSize itemSize = [NSString getStringSizeWith:content withStringFont:12 withWidthOrHeight:23 isWidthFixed:NO];
    return itemSize.width + 31;
}

- (UIButton *)itemWithContent:(id)content index:(NSInteger)index {
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize itemSize = [NSString getStringSizeWith:content withStringFont:12 withWidthOrHeight:23 isWidthFixed:NO];
    item.titleLabel.font = [UIFont systemFontOfSize:12];
    [item setTitle:content forState:UIControlStateNormal];
    item.titleRect = CGRectMake(6, 6, itemSize.width, 12);
    
    [item setBackgroundImage:[[UIImage imageNamed:@"imageDetail_tag_image"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 20) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [item setBackgroundColor:[UIColor clearColor]];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    TGFlashingView *animateView = [[TGFlashingView alloc] initWithFrame: CGRectMake(14.5+itemSize.width, 10.5, 5, 5)];
    [item addSubview:animateView];
    
    return item;
}

@end
