//
//  UIButton+TG.m
//  TGTagsView
//
//  Created by tugou on 2019/2/13.
//  Copyright © 2019年 陈星辰. All rights reserved.
//

#import "UIButton+TG.h"
#import <objc/runtime.h>

@implementation UIButton (TG)
#pragma mark 扩充按钮类属性
// 定义关联的key值
static const char *key = "bob_imageRectKey";

- (CGRect)imageRect
{
    return [objc_getAssociatedObject(self, key) CGRectValue];
}

- (void)setImageRect:(CGRect)imageRect
{
    objc_setAssociatedObject(self, key,[NSValue valueWithCGRect:imageRect],OBJC_ASSOCIATION_RETAIN);
}

//定义关联的Key
static const char * titleRectKey = "bob_titleRectKey";

- (CGRect)titleRect {
    
    return [objc_getAssociatedObject(self, titleRectKey) CGRectValue];
}

- (void)setTitleRect:(CGRect)rect {
    
    objc_setAssociatedObject(self, titleRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark *********动态替换方法*************

+ (void)load{
    Method_Swizzle(self , @selector(titleRectForContentRect:), @selector(override_titleRect:));
    Method_Swizzle(self, @selector(imageRectForContentRect:), @selector(override_imageRectForContentRect:));
}

void Method_Swizzle(Class c,SEL originalSEL,SEL overrideSEL){
    Method originalMethod = class_getInstanceMethod(c, originalSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    
    //运行时函数class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用: 若父类没有实现，则先实现父类方法，再交换，若父类实现，直接交换
    if (class_addMethod(c, originalSEL , method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))){
        class_replaceMethod(c, overrideSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        //addMethod会让目标类的方法指向新的实现，使用replaceMethod再将新的方法指向原先的实现，这样就完成了交换操作。
        method_exchangeImplementations(originalMethod,overrideMethod);
        
    }
    
}

// 添加替换方法
- (CGRect)override_titleRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    
    return [self override_titleRect:contentRect];
}


- (CGRect)override_imageRectForContentRect:(CGRect)contentRect {
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [self override_imageRectForContentRect:contentRect];
    
}@end
