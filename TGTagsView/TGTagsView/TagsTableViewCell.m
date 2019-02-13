//
//  TagsTableViewCell.m
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import "TagsTableViewCell.h"

@implementation TagsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setSubviews];
    [self configContents:nil];
    return self;
}

- (void)setSubviews {
    TGTagsView *view = [[TGTagsView alloc] init];
    self.tagsView = view;
    [self addSubview:view];
}

- (void)configContents:(NSArray *)contents {
    @throw [NSException exceptionWithName:NSStringFromSelector(_cmd)
                                   reason:@"你一定要重写我哦～！"
                                 userInfo:nil];
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
