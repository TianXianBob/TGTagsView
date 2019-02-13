//
//  TGTagsView.m
//  ToGoDecoration
//
//  Created by Bob on 2018/8/9.
//  Copyright © 2018年 tugou.com. All rights reserved.
//

#import "TGTagsView.h"
#import "NSString+TG.h"

#define kCommonBorderWidth 1
#define kCommonLineSpace 5
#define kCommonItemSpace 5
#define kCommonItemHeigt 24
#define KitemHorizonInset 14

#define Font(FONT)  [UIFont systemFontOfSize:FONT]
#define kCommenFont 14

#define KColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kMainTextGrayColor       KColorFromRGB(0x5d5d5d)
#define kMainColor KColorFromRGB(0xff6d00)

#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)

NSString * const K_TAGS_VIEW = @"K_TAGS_VIEW";
NSString * const K_TAGS_VIEW_H = @"K_TAGS_VIEW_H";
NSString * const K_TAGS_VIEW_W = @"K_TAGS_VIEW_W";
NSString * const K_TAGS_CUREENT_X = @"K_TAGS_CUREENT_X";

@implementation TGTagButton : UIButton
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = self.selectColor;
        self.layer.borderColor = self.selectBorderColor.CGColor;
    } else {
        self.backgroundColor = self.normalColor;
        self.layer.borderColor = self.borderColor.CGColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {}
@end


@implementation TGTagsViewCustomNature
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fontSize = kCommenFont;
        self.contentInset = UIEdgeInsetsZero;
        self.textColor = kMainTextGrayColor;
        self.borderColor = kMainColor;
        self.borderWidth = kCommonBorderWidth;
        self.lineSpace = kCommonLineSpace;
        self.itemSpace = kCommonItemSpace;
        self.itemHeight = kCommonItemHeigt;
        self.contentWidth = KScreenWidth;
        self.itemHorizonInset = KitemHorizonInset;
        self.itemBgColor = [UIColor whiteColor];
        self.defaultSelectedArray = @[];
        self.defaultEnableArray = @[];
        self.isHorizonLayout = YES;
    }
    return self;
}
@end


@interface TGTagsView()
@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) NSInteger lineNum;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) TGTagsViewCustomNature *customNature;
@property (nonatomic, copy) TGTagsViewSelectHandler selectHandler;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
/// 最大宽度 在isHorizonLayout=NO的情况下使用
@property (nonatomic, assign) CGFloat maxWidth;
@end

@implementation TGTagsView

+ (NSDictionary *)tagsViewWithTagsArray:(NSArray *)tagArray
                            customNature:(TGTagsViewCustomNature *)customNature
                           selectHandler:(TGTagsViewSelectHandler)selectHandler{
    TGTagsView *tagsView = [[TGTagsView alloc] init];
    [tagsView configDataArrayWithArray:tagArray customNature:customNature selectHandler:selectHandler];
    return @{
             K_TAGS_VIEW:tagsView,
             K_TAGS_VIEW_H:@(tagsView.height),
             K_TAGS_VIEW_W:@(tagsView.width),
             K_TAGS_CUREENT_X:@(tagsView.currentX)
             };
}

- (NSDictionary *)configDataArrayWithArray:(NSArray<NSString *> *)tagArray
                    customNature:(TGTagsViewCustomNature *)customNature
                   selectHandler:(TGTagsViewSelectHandler)selectHandler {
    [self layoutTagButtonWithArray:tagArray customNature:customNature selectHandler:selectHandler];
    
    return @{
             K_TAGS_VIEW:self,
             K_TAGS_VIEW_H:@(self.height),
             K_TAGS_VIEW_W:@(self.width),
             K_TAGS_CUREENT_X:@(self.currentX)
             };
}

- (NSDictionary *)configDataArrayWithImageArray:(NSArray<UIImage *> *)dataArray
                         customNature:(TGTagsViewCustomNature *)cusomNature
                        selectHandler:(TGTagsViewSelectHandler)selectHandler {
    [self layoutTagButtonWithArray:dataArray customNature:cusomNature selectHandler:selectHandler];
    
    return @{
             K_TAGS_VIEW:self,
             K_TAGS_VIEW_H:@(self.height),
             K_TAGS_VIEW_W:@(self.width),
             K_TAGS_CUREENT_X:@(self.currentX)
             };
}




- (void)layoutTagButtonWithArray:(NSArray *)contentArray
                    customNature:(TGTagsViewCustomNature *)customNature
                   selectHandler:(TGTagsViewSelectHandler)selectHandler{
    if (!contentArray || contentArray.count == 0) {
        NSLog(@"TGTagsView:169 You give an empty dataSource cause the bad result");
        return;
    }
    
    // 获得配置对象
    if (!customNature) {
        self.customNature = [[TGTagsViewCustomNature alloc] init];
    } else {
        self.customNature = customNature;
    }
    
    // 缓存数据源
    self.dataArray = contentArray;
    
    // 缓存block
    if (selectHandler) {
        self.selectHandler = selectHandler;
    }
    
    // 初始化tagView的基本数据
    [self initialize];
    
    // 遍历创建View
    for (id content in contentArray) {
        CGSize itemSize = CGSizeZero;
        if ([content isKindOfClass:[NSString class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(itemWidthWithContent:index:)]) {
                itemSize = CGSizeMake([self.delegate itemWidthWithContent:content index:self.index], self.customNature.itemHeight);
            } else {
                itemSize = [self calculateSigleSizeWithContent:content];
            }
            self.maxWidth = MAX(itemSize.width, self.maxWidth);// 记录最大标签宽度
        } else if ([content isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)content;
            CGFloat width = image.size.width/image.size.height * self.customNature.itemHeight;
            itemSize = CGSizeMake(width, self.customNature.itemHeight);
        }
        NSLog(@"TGTagsView:192 %@",NSStringFromCGSize(itemSize));
        [self addItemsWithContent:content size:itemSize];
        self.index ++;
    }
}

- (void)initialize {
    self.currentX = self.beginX;
    self.currentY = self.beginY;
    self.lineNum = 0;
    self.index = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)addItemsWithContent:(id)content
                       size:(CGSize)itemSize {
    // 初始化按钮样式
    UIButton *item = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemWithContent:index:)]) {
        item = [self.delegate itemWithContent:content index:self.index];
        item.tag = self.index;
    } else {
        item = [self getItemWithContent:content];
    }
    
    // 按钮点击
    item.tag = self.index;
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    // 计算item的frame
    item.frame = CGRectMake([self getItemXWithSize:itemSize],[self getItemYWithSize:itemSize], itemSize.width, self.customNature.itemHeight);
//    DLog(@"227 :: itemSize.width ==  %f",item.width)
    [self addSubview:item];
    
    // 更新当前的x，y
    if (self.customNature.isHorizonLayout) {
        self.currentY = (CGRectGetMinY(item.frame) > self.currentY) ? self.nextY:self.currentY;
        self.currentX = CGRectGetMaxX(item.frame) + self.customNature.itemSpace;
        
        // 更新高度
        self.height = MAX(self.currentY + itemSize.height + self.customNature.contentInset.bottom, self.height);
        NSLog(@"self.height = %f",self.height);
        self.width = MAX(self.customNature.contentWidth + self.customNature.contentInset.left + self.customNature.contentInset.right, self.width);
    } else {
        self.currentY = CGRectGetMaxY(item.frame) + self.customNature.lineSpace;
        if ((NSInteger)CGRectGetMinX(item.frame) > (NSInteger)self.currentX) {
            self.currentX = [self nextXWithItemWidth:self.maxWidth];
        }
        
        // 更新高度
        self.height = MAX(self.currentY + self.customNature.contentInset.bottom, self.height);
        self.width = MAX(self.currentX+self.maxWidth, self.width);
//        DLog(@"227 :: CGRectGetMinX(item.frame) ==  %f",CGRectGetMinX(item.frame))
//        DLog(@"227 :: currentY:%f == currentX:%f",self.currentY,self.currentX)
    }
    
 
}


// 创建标签
- (UIButton *)getItemWithContent:(id)content {
    TGTagButton *item = [TGTagButton buttonWithType:UIButtonTypeCustom];
    if ([content isMemberOfClass:[NSAttributedString class]]) {
        [item setAttributedTitle:content forState:UIControlStateNormal];
    } else if ([content isKindOfClass:[NSString class]]) {
        [item setTitle:content forState:UIControlStateNormal];
    } else if ([content isKindOfClass:[UIImage class]]) {
        [item setImage:content forState:UIControlStateNormal];
        item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    item.layer.borderColor = self.customNature.borderColor.CGColor;
    item.layer.borderWidth = self.customNature.borderWidth;
    [item setTitleColor:self.customNature.textColor forState:UIControlStateNormal];
    item.titleLabel.font = Font(self.customNature.fontSize);
    [item setBackgroundColor:self.customNature.itemBgColor];
    [item setBackgroundImage:self.customNature.normalBgImage forState:UIControlStateNormal];
    [item setBackgroundImage:self.customNature.selectBgImage forState:UIControlStateSelected];
    [item setImage:self.customNature.selectImage forState:UIControlStateSelected];
    [item setImage:self.customNature.normalImage forState:UIControlStateNormal];
    [item setTitleColor:self.customNature.selectTitleColor forState:UIControlStateSelected];
    item.selectColor = self.customNature.selectBgColor;
    item.normalColor = self.customNature.itemBgColor;
    item.borderColor = self.customNature.borderColor;
    item.selectBorderColor = self.customNature.selectBorderColor ?:item.borderColor;

    item.layer.cornerRadius = self.customNature.itemCornerRaduis;
    
    if ([self.customNature.defaultEnableArray containsObject:content]) {
        UIColor *textColor = (self.customNature.enableTextColor) ?:self.customNature.textColor;
        [item setTitleColor:textColor forState:UIControlStateNormal];
        item.enabled = NO;
    } else {
        [item setTitleColor:self.customNature.textColor forState:UIControlStateNormal];
        item.enabled = YES;
    }
    
    if ([self.customNature.defaultSelectedArray containsObject:content]) {
        item.selected = YES;
    } else {
        item.selected = NO;
    }
    
    return item;
}

// 判断是否在该行放的下，计算X
- (CGFloat)getItemXWithSize:(CGSize)itemSize {
    CGFloat itemX;
    if (self.customNature.isHorizonLayout) {
        itemX = [self containItemSize:itemSize] ? self.currentX:self.beginX;
    } else {
        itemX = [self containItemSize:itemSize] ? self.currentX:[self nextXWithItemWidth:self.maxWidth];
    }
//    DLog(@"227 ::itemX:%f",itemX);
    return itemX;
}

// 判断是否在改行放的下，计算Y
- (CGFloat)getItemYWithSize:(CGSize)itemSize {
    CGFloat itemY;
    if (self.customNature.isHorizonLayout) {
        itemY = [self containItemSize:itemSize] ? self.currentY:self.nextY;
    } else {
        itemY = [self containItemSize:itemSize] ? self.currentY:self.beginY;
    }
//    NSLog(@"itemY:%f",itemY);
    return itemY;
}

// 该行/列 是否包含的下该标签
- (BOOL)containItemSize:(CGSize)itemSize {
    BOOL contain = NO;
    if (self.customNature.isHorizonLayout) {
        contain = [self canContainTheItemWithItemWidth:itemSize.width];
    } else {
        contain = [self canContainTheItemWithItemHeight:itemSize.height];
//        DLog(@"contain :: %d",contain)
    }
    return contain;
}

// 每行的初始X
- (CGFloat)beginX {
    return self.customNature.contentInset.left;
}

// 标签的初始Y
- (CGFloat)beginY {
    return self.customNature.contentInset.top;
}

// 下一行标签的Y
- (CGFloat)nextY {
    return self.currentY + self.customNature.lineSpace + self.customNature.itemHeight;
}

// 下一列标签的X
- (CGFloat)nextXWithItemWidth:(CGFloat)itemWidth {
//    DLog(@"nextXXXX = %f",self.currentX + self.customNature.itemSpace + itemWidth)
    return self.currentX + self.customNature.itemSpace + itemWidth;
}

// 判断标签是否在当前行放的下
- (BOOL)canContainTheItemWithItemWidth:(CGFloat)itemWidth {
//    CGFloat nextX = self.currentX + itemWidth + self.customNature.itemSpace;
    CGFloat nextX = floor(self.currentX) + floor(itemWidth);
    return  nextX > self.realContentWidth ? NO:YES;
}

- (BOOL)canContainTheItemWithItemHeight:(CGFloat)itemHeight {
    CGFloat nextY = self.currentY + itemHeight + self.customNature.lineSpace;
    BOOL result = nextY > self.realContentHeight ? NO:YES;
    return result;
}

// 实际能放置标签的宽度
- (CGFloat)realContentWidth {
    return self.customNature.contentWidth - self.customNature.contentInset.left - self.customNature.contentInset.right;
}

// 实际能放置标签的宽度
- (CGFloat)realContentHeight {
    return self.customNature.contentHeight - self.customNature.contentInset.bottom - self.customNature.contentInset.top;
}


// 计算单个item的size
- (CGSize)calculateSigleSizeWithContent:(NSString *)tagContent {
    CGSize itemSize = [NSString getStringSizeWith:tagContent withStringFont:self.customNature.fontSize withWidthOrHeight:self.customNature.itemHeight isWidthFixed:NO];
    itemSize.width += 2*self.customNature.itemHorizonInset;
    self.maxWidth = MAX(itemSize.width, self.maxWidth);// 记录最大标签宽度
//    DLog(@"itemSize.width == %f",itemSize.width)
    itemSize.height = self.customNature.itemHeight;
    return itemSize;
}

#pragma mark - Action
- (void)itemClick:(UIButton *)item {
    if (self.customNature.isOption) {
        for (UIButton *btn in self.subviews) {
            btn.selected = NO;
        }
    }
    item.selected = YES;
    
    if (self.selectHandler) {
        self.selectHandler(item.tag, self.dataArray[item.tag]);
    }
}

@end
