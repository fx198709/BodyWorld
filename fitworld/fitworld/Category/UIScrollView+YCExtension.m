//
//  UIScrollView+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 2017/7/4.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "UIScrollView+YCExtension.h"
#import <objc/runtime.h>

@interface UIScrollView ()
/**
 下拉回弹视图的背景色
 */
@property (nonatomic, strong) UIColor *scrollOffsetViewColor;
@property (nonatomic, strong) UIView *scrollOffsetView;
@property (nonatomic, assign) BOOL hasObserver;

/**
 用于判断UIScrollView是上滑还是下拉
 */
@property (nonatomic, strong) NSNumber *lastContentOffsetY;
/**
 记录UIScrollView是上滑还是下拉类型
 */
@property (nonatomic, strong) NSNumber *contentOffsetYTypeNumber;

/**
 无需执行DidScrollBlock
 */
@property (nonatomic, assign) BOOL whithoutDidScrollBlock;
@end

@implementation UIScrollView (YCExtension)

- (void)changeScrollOffsetViewBackColor:(UIColor *)color {
    self.scrollOffsetViewColor = color;
}

- (void)removeOffsetViewObserver {
    id Obser = self.observationInfo;
    if (Obser) {
        @try {
            [self KVORemoveObserver];
        } @catch (NSException *exception) {
            CRMLog(@"scrollOffsetViewColor 移除监听失败 %@",NSStringFromClass([self class]));
        } @finally {
            
        }
    }
}

static char hasObserverKey;
- (void)setHasObserver:(BOOL)hasObserver {
    objc_setAssociatedObject(self, &hasObserverKey, @(hasObserver), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)hasObserver {
    return [objc_getAssociatedObject(self, &hasObserverKey) boolValue];
}

static char scrollOffsetViewColorKey;
- (void)setScrollOffsetViewColor:(UIColor *)scrollOffsetViewColor {
    objc_setAssociatedObject(self, &scrollOffsetViewColorKey, scrollOffsetViewColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self KVOAddObserver];
}
- (UIColor *)scrollOffsetViewColor {
    return objc_getAssociatedObject(self, &scrollOffsetViewColorKey);
}

static char scrollOffsetViewKey;
- (void)setScrollOffsetView:(UIView *)scrollOffsetView {
    objc_setAssociatedObject(self, &scrollOffsetViewKey, scrollOffsetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)scrollOffsetView {
    return objc_getAssociatedObject(self, &scrollOffsetViewKey);
}

static char shouldRecognizeSimultaneouslyWithGestureRecognizerKey;
/**
 设置是否允许多个手势同时执行
 
 @param shouldRecognizeSimultaneouslyWithGestureRecognizer <#shouldRecognizeSimultaneouslyWithGestureRecognizer description#>
 */
- (void)setShouldRecognizeSimultaneouslyWithGestureRecognizer:(BOOL (^)(UIScrollView *scrollView))shouldRecognizeSimultaneouslyWithGestureRecognizer {
    objc_setAssociatedObject(self, &shouldRecognizeSimultaneouslyWithGestureRecognizerKey, shouldRecognizeSimultaneouslyWithGestureRecognizer, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
/**
 是否允许多个手势同时执行
 
 @return <#return value description#>
 */
- (BOOL (^)(UIScrollView *scrollView))shouldRecognizeSimultaneouslyWithGestureRecognizer {
    return objc_getAssociatedObject(self, &shouldRecognizeSimultaneouslyWithGestureRecognizerKey);
}

static char setScrollViewDidScrollBlockKey;
- (void)setScrollViewDidScrollBlock:(void (^)(UIScrollView *, YCContentOffsetYType))scrollViewDidScrollBlock {
    objc_setAssociatedObject(self, &setScrollViewDidScrollBlockKey, scrollViewDidScrollBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(UIScrollView *, YCContentOffsetYType))scrollViewDidScrollBlock {
    return objc_getAssociatedObject(self, &setScrollViewDidScrollBlockKey);
}

- (YCContentOffsetYType)contentOffsetYType {
    YCContentOffsetYType type = [[self contentOffsetYTypeNumber] integerValue];
    return type;
}
static char lastContentOffsetYKey;
- (void)setLastContentOffsetY:(NSNumber *)lastContentOffsetY {
    objc_setAssociatedObject(self, &lastContentOffsetYKey, lastContentOffsetY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)lastContentOffsetY {
    return objc_getAssociatedObject(self, &lastContentOffsetYKey);
}

static char contentOffsetYTypeKVOKey;
- (void)setEnableContentOffsetYTypeKVO:(BOOL)enableContentOffsetYTypeKVO {
    objc_setAssociatedObject(self, &contentOffsetYTypeKVOKey, @(enableContentOffsetYTypeKVO), OBJC_ASSOCIATION_ASSIGN);
    if (enableContentOffsetYTypeKVO) {
        [self KVOAddObserver];
    }else{
        [self removeOffsetViewObserver];
    }
}
- (BOOL)enableContentOffsetYTypeKVO {
    return [objc_getAssociatedObject(self, &contentOffsetYTypeKVOKey) boolValue];
}

static char contentOffsetYTypeNumberKey;
- (void)setContentOffsetYTypeNumber:(NSNumber *)contentOffsetYTypeNumber {
    objc_setAssociatedObject(self, &contentOffsetYTypeNumberKey, contentOffsetYTypeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)contentOffsetYTypeNumber {
    return objc_getAssociatedObject(self, &contentOffsetYTypeNumberKey);
}

static char whithoutDidScrollBlockKey;
- (void)setWhithoutDidScrollBlock:(BOOL)whithoutDidScrollBlock {
    objc_setAssociatedObject(self, &whithoutDidScrollBlockKey, @(whithoutDidScrollBlock), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)whithoutDidScrollBlock {
    return [objc_getAssociatedObject(self, &whithoutDidScrollBlockKey) boolValue];
}


static void *contentOffsetObservationContext = &contentOffsetObservationContext;
- (void)KVOAddObserver {
    if (!self.hasObserver) {
        [self addObserver:self
               forKeyPath:@"contentOffset"
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:contentOffsetObservationContext];
        self.hasObserver = YES;
    }
}

- (void)KVORemoveObserver {
    if (self.hasObserver) {
        [self removeObserver:self forKeyPath:@"contentOffset" context:contentOffsetObservationContext];
        self.hasObserver = NO;
    }
}

- (void)observeValueForKeyPath:(NSString*)path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    NSString *newStr = [[change objectForKey:@"new"] description];
    NSString *oldStr = [[change objectForKey:@"old"] description];
    if (context == contentOffsetObservationContext && [path isEqual:@"contentOffset"]){
        
        CGFloat hight = self.frame.size.height;
        CGFloat contentOffsetY = self.contentOffset.y;
        CGFloat distanceFromBottom = self.contentSize.height - contentOffsetY;
        CGFloat offsetY = contentOffsetY - [self.lastContentOffsetY floatValue];
        
//        NSLog(@"self.lastContentOffsetY = %@",self.lastContentOffsetY);
//        NSLog(@"hight = %@, contentOffsetY = %@",@(hight),@(contentOffsetY));
//        NSLog(@"distanceFromBottom = %@, offsetY = %@",@(distanceFromBottom),@(offsetY));
        
        self.lastContentOffsetY = [NSNumber numberWithFloat:contentOffsetY];
        
        if (offsetY > 0 && contentOffsetY > 0) {
            self.contentOffsetYTypeNumber = [NSNumber numberWithInteger:OffsetTypeToUp];
//            NSLog(@"向上滑");
        }
        if (offsetY < 0 && distanceFromBottom > hight) {
            self.contentOffsetYTypeNumber = [NSNumber numberWithInteger:OffsetTypeToDown];
//            NSLog(@"向下滑");
        }
        if (contentOffsetY <= 0) {
            self.contentOffsetYTypeNumber = [NSNumber numberWithInteger:OffsetTypeMin];
//            NSLog(@"顶部");
        }
        if (contentOffsetY >= 0 && distanceFromBottom < hight) {
            self.contentOffsetYTypeNumber = [NSNumber numberWithInteger:OffsetTypeMax];
//            NSLog(@"底部");
        }
//        NSLog(@"\n");
        
        if (self.scrollViewDidScrollBlock) {
            if (!self.whithoutDidScrollBlock) {
                __weak typeof(self)wSelf = self;
                self.scrollViewDidScrollBlock(wSelf, [wSelf contentOffsetYType]);
            }
        }
        
        if (self.scrollOffsetViewColor) {
            if (!self.scrollOffsetView) {
                self.scrollOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
                self.scrollOffsetView.autoresizingMask = UIViewAutoresizingNone;
                [self addSubview:self.scrollOffsetView];
            }
            
            if (![newStr isEqualToString:oldStr]) {
                CGPoint contentOffset = CGPointFromString(newStr);
                if (contentOffset.y < 0) {
                    self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentOffset.y);
                }else{
                    self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
                }
                self.scrollOffsetView.backgroundColor = self.scrollOffsetViewColor;
                [self sendSubviewToBack:self.scrollOffsetView];
            }
            
        }
    }else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

- (void)changeContentOffset:(CGPoint)contentOffset animated:(BOOL)animated withoutDidScrollBlockMessage:(BOOL)withoutMessage {
    [self setWhithoutDidScrollBlock:withoutMessage];
    if (animated) {
        [UIView animateWithDuration:0.30 animations:^{
            [self setContentOffset:contentOffset];
        } completion:^(BOOL finished) {
            [self setWhithoutDidScrollBlock:NO];
        }];
    }else{
        [self setContentOffset:contentOffset];
        [self setWhithoutDidScrollBlock:NO];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.shouldRecognizeSimultaneouslyWithGestureRecognizer) {
        __weak typeof(self)wSelf = self;
        return self.shouldRecognizeSimultaneouslyWithGestureRecognizer(wSelf);
    }else{
        return NO;
    }
}

@end
