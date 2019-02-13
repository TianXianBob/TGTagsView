//
//  TagsTableViewCell.h
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGTagsView/TGTagsView.h"

#define TGRGBColorAlpha(r,g,b,f) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:f]

@interface TagsTableViewCell : UITableViewCell
@property (nonatomic, strong) TGTagsView *tagsView;

- (void)configContents:(NSArray *)contents;
@end
