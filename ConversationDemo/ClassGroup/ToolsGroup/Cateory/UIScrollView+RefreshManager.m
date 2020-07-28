//
//  UIScrollView+RefreshManager.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/5/30.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "UIScrollView+RefreshManager.h"
#import "NSObject+Swizzling.h"

@implementation UICollectionView (RefreshManager)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(l_reloadData)];
    });
}

- (void)l_reloadData {
    [self l_reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.autoHiddenFooter) {
            [self setFooterShow];
        }
    });
}

- (void)setAutoHiddenFooter:(BOOL)autoHiddenFooter {
    if (autoHiddenFooter) {
        self.mj_footer.hidden = YES;
    }
    objc_setAssociatedObject(self, @selector(autoHiddenFooter), @(autoHiddenFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)autoHiddenFooter{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

/**
 数据不满一页的话就自动隐藏下面的“上拉加载更多”或是"没有更多数据" 。
 */
- (void)setFooterShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat heightOfContentSize = self.contentSize.height;
        // 计算tableView实际显示范围
        // 先拿到tableView实际的contentInset (因为下拉刷新时mj会重设contentInset)
        UIEdgeInsets originContentInset = self.mj_header.scrollViewOriginalInset;
        CGFloat actualHeight = self.frame.size.height - originContentInset.top - originContentInset.bottom;
        // 修正footer对contenInset的影响
        if (!self.mj_footer.hidden) { // 没有隐藏
            actualHeight = actualHeight + self.mj_footer.frame.size.height + 10; // 默认的mj_footer高度为44  默认实际偏移了54
        }
        if (actualHeight >= heightOfContentSize) { // 实际显示高度大于内容高度 代表第一页都没有占满
            self.mj_footer.hidden = YES;
        } else {
            self.mj_footer.hidden = NO;
        }
    });
    
}

@end



@implementation UITableView (RefreshManager)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(l_reloadData)];
    });
}

- (void)l_reloadData {
    [self l_reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.autoHiddenFooter) {
            [self setFooterShow];
        }
    });
}

- (void)setAutoHiddenFooter:(BOOL)autoHiddenFooter {
    if (autoHiddenFooter) {
        self.mj_footer.hidden = YES;
    }
    objc_setAssociatedObject(self, @selector(autoHiddenFooter), @(autoHiddenFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)autoHiddenFooter{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

/**
 数据不满一页的话就自动隐藏下面的“上拉加载更多”或是"没有更多数据" 。
 */
- (void)setFooterShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat heightOfContentSize = self.contentSize.height;
        // 计算tableView实际显示范围
        // 先拿到tableView实际的contentInset (因为下拉刷新时mj会重设contentInset)
        UIEdgeInsets originContentInset = self.mj_header.scrollViewOriginalInset;
        CGFloat actualHeight = self.frame.size.height - originContentInset.top - originContentInset.bottom;
        // 修正footer对contenInset的影响
        if (!self.mj_footer.hidden) { // 没有隐藏
            actualHeight = actualHeight + self.mj_footer.frame.size.height + 10; // 默认的mj_footer高度为44  默认实际偏移了54
        }
        if (actualHeight >= heightOfContentSize) { // 实际显示高度大于内容高度 代表第一页都没有占满
            self.mj_footer.hidden = YES;
        } else {
            self.mj_footer.hidden = NO;
        }
    });
    
}

@end

