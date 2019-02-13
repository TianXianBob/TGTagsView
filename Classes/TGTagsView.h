//
//  TGTagsView.h
//  ToGoDecoration
//
//  Created by Bob on 2018/8/9.
//  Copyright © 2018年 tugou.com. All rights reserved.
//  一个会自己计算高度的标签View

#import <UIKit/UIKit.h>

extern NSString * const K_TAGS_VIEW;
extern NSString * const K_TAGS_VIEW_H;
extern NSString * const K_TAGS_VIEW_W;
extern NSString * const K_TAGS_CUREENT_X;
@protocol TGTagsViewDelegate<NSObject>
@required
- (CGFloat)itemWidthWithContent:(id)content index:(NSInteger)index;
- (UIButton *)itemWithContent:(id)content index:(NSInteger)index;
@end

/**
 标签的容器按钮
 */
@interface TGTagButton : UIButton
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *selectBorderColor;
@property (nonatomic, strong) UIColor *borderColor;
@end

/**
 该对象是tagsView的配置对象。里面包含了对tagsView的一些配置以及对tagsView中标签的一些设置。
 */
@interface TGTagsViewCustomNature: NSObject
/// 该字段表示是否横向布局还是纵向布局 YES->横向布局，NO->纵向布局，默认为YES
@property (nonatomic, assign) BOOL isHorizonLayout;
/// 标签字体大小
@property (nonatomic, assign) CGFloat fontSize;
/// tagView的内间距
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 标签文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 标签边框宽度
@property (nonatomic, assign) CGFloat borderWidth;
/// 标签边框颜色
@property (nonatomic, strong) UIColor *borderColor;
/// 标签文字横向的内间距
@property (nonatomic, assign) CGFloat itemHorizonInset;
/// 标签的行间距
@property (nonatomic, assign) CGFloat lineSpace;
/// 标签左右间距
@property (nonatomic, assign) CGFloat itemSpace;
/// 标签高度
@property (nonatomic, assign) CGFloat itemHeight;
/// tagView的宽度
@property (nonatomic, assign) CGFloat contentWidth;
/// tagView的高度
@property (nonatomic, assign) CGFloat contentHeight;
/// 标签颜色
@property (nonatomic, strong) UIColor *itemBgColor;
/// 标签圆角值
@property (nonatomic, assign) CGFloat itemCornerRaduis;
/// 标签在正常状态下展示的图片
@property (nonatomic, strong) UIImage *normalImage;
/// 标签选中展示的图片
@property (nonatomic, strong) UIImage *selectImage;
/// 标签未选中的时候的背景图片
@property (nonatomic, strong) UIImage *normalBgImage;
/// 标签选中的时候的背景图片
@property (nonatomic, strong) UIImage *selectBgImage;
/// 标签选中时候的
@property (nonatomic, strong) UIColor *selectBorderColor;
/// 选中时候的背景颜色
@property (nonatomic, strong) UIColor *selectBgColor;
/// 选中的时候标签的文字颜色
@property (nonatomic, strong) UIColor *selectTitleColor;
/// item禁止点击后的颜色
@property (nonatomic, strong) UIColor *enableTextColor;
/// 若该字段为YES，则当前数据源的tag只有一个可选中
@property (nonatomic, assign) BOOL isOption;
/// 该数组中的标签名对应的标签默认会置为select状态
@property (nonatomic, copy) NSArray<NSString *> *defaultSelectedArray;
/// 该数组的标签会变成userenable = NO的状态
@property (nonatomic, copy) NSArray<NSString *> *defaultEnableArray;

@end

typedef void (^TGTagsViewSelectHandler)(NSInteger index, NSString *content);

@interface TGTagsView : UIView
@property (nonatomic, weak) id<TGTagsViewDelegate> delegate;
/**
 创建高度根据标签个数及标签大小计算出来的view

 @param tagArray 标签内容数组
 @param customNature 配置对象
 @param selectHandler item的选择回调
 @return 
 */
+ (NSDictionary *)tagsViewWithTagsArray:(NSArray *)tagArray
                            customNature:(TGTagsViewCustomNature *)cusomNature
                           selectHandler:(TGTagsViewSelectHandler)selectHandler;

/**
 根据数据源填充tag
 数据源为字符串
 @param dataArray 数据源数组
 @param cusomNature 配置对象
 @param selectHandler 选择回调
 */
- (NSDictionary *)configDataArrayWithArray:(NSArray<NSString *> *)dataArray
                    customNature:(TGTagsViewCustomNature *)cusomNature
                   selectHandler:(TGTagsViewSelectHandler)selectHandler;

/**
 根据数据源填充tag
 数据源为图片
 @param dataArray 数据源数组
 @param cusomNature 配置对象
 @param selectHandler 选择回调
 */
- (NSDictionary *)configDataArrayWithImageArray:(NSArray<UIImage *> *)dataArray
                    customNature:(TGTagsViewCustomNature *)cusomNature
                        selectHandler:(TGTagsViewSelectHandler)selectHandler;
@end
