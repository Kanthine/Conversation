//
//  UINavigationController+TransitionAnimation.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/15.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UINavigationController+TransitionAnimation.h"
#import <objc/runtime.h>


@interface TransitionAnimationScale : NSObject
<UIViewControllerAnimatedTransitioning>
@end
@implementation TransitionAnimationScale
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    NSLog(@"startAnimation! fromView = %@", fromView);
    NSLog(@"startAnimation! toView = %@", toView);
    for(UIView * view in containerView.subviews){
        NSLog(@"startAnimation! list container subviews: %@", view);
    }
    
    [containerView addSubview:toView];
    
    [[transitionContext containerView] bringSubviewToFront:fromView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
        fromView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformMakeScale(1, 1);
        [transitionContext completeTransition:YES];
        for(UIView * view in containerView.subviews){
            NSLog(@"endAnimation! list container subviews: %@", view);
        }
    }];
}

@end



@interface TransitionAnimationFlip : NSObject
<UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL sequence;
@end

@interface TransitionAnimationFlip ()
{
    int totalCount;
    int finishedCounter;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation TransitionAnimationFlip

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    mtransitionContext = transitionContext;
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    finishedCounter = 0;
    totalCount = 0;
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 4.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    NSInteger numPerRow = 0;
    NSInteger totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
        numPerRow ++;
        for (CGFloat x = size.width; x >=0; x -=size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            totalCount ++;
        }
    }
    
    [containerView sendSubviewToBack:fromView];
    
    if(self.sequence){
        for(int i = 0 ; i < numPerRow ; i ++){
            NSTimeInterval delay = i * 0.1f;
            for(int j = 0 ; j < totalNum/numPerRow ; j ++){
                [self performSelector:@selector(triggerFlip:) withObject:[snapshots objectAtIndex:(j + i * totalNum/numPerRow)] afterDelay:delay];
                delay += 0.1f;
            }
        }
        
    }else{
        for(UIView * view in snapshots){
            [self performSelector:@selector(triggerFlip:) withObject:view afterDelay:rand()/(double)RAND_MAX/2];
        }
    }
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = 1;
    view.layer.anchorPoint = CGPointMake(0, 0.5f);
    CGRect frame = view.layer.frame;
    view.layer.frame = CGRectMake(frame.origin.x - frame.size.width/2 + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0 options:0 animations:^{
        view.layer.transform = [self getTransForm3DWithAngle:-M_PI_2];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        finishedCounter ++;
        if(finishedCounter == totalCount){
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}

-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002f;
    transform = CATransform3DRotate(transform,angle,0,1,0);
    return transform;
    
}

@end






@interface TransitionAnimationDrawer : NSObject<UIViewControllerAnimatedTransitioning>

@end
@interface TransitionAnimationDrawer ()
{
    int totalCount;
    int flippedCount;
    NSInteger numPerRow;
    NSInteger totalNum;
    NSInteger randomPick;
    CGPoint pickedCenter;
    NSMutableArray *snapshots;
    NSMutableArray * flippedViews;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation TransitionAnimationDrawer
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    mtransitionContext = transitionContext;
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    totalCount = 0;
    flippedCount = 0;
    CGSize size = toView.frame.size;
    
    snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 8.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    int rowNum = 0;
    totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y = 0; y < size.height; y += size.height / yFactor) {
        rowNum ++;
        for(CGFloat x = 0; x < size.width; x += size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            snapshot.tag = (totalNum - 1);
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            totalCount ++;
        }
    }
    numPerRow = totalNum/rowNum;
    [containerView sendSubviewToBack:fromView];
    flippedViews = [NSMutableArray new];
    randomPick = rand() % totalNum;
    UIView * pickedView = [snapshots objectAtIndex:randomPick];
    pickedCenter = pickedView.center;
    [pickedView removeFromSuperview];
    [flippedViews addObject:[NSNumber numberWithInteger:randomPick]];
    flippedCount = 1;
    [self triggerFlips];
}

- (void) triggerFlips
{
    NSMutableArray * addFlip = [NSMutableArray new];
    NSMutableSet * addedSet = [NSMutableSet new];
    for(NSNumber * flipped in flippedViews){
        NSInteger index = [flipped integerValue];
        if(index % numPerRow > 0){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index-1)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index-1)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index-1)]];
                    [addFlip addObject:[snapshots objectAtIndex:index-1]];
                }
            }
        }
        if(index % numPerRow < (numPerRow - 1)){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index+1)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index+1)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index+1)]];
                    [addFlip addObject:[snapshots objectAtIndex:index+1]];
                }
            }
        }
        if(index / numPerRow >= 1){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index-numPerRow)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index-numPerRow)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index-numPerRow)]];
                    [addFlip addObject:[snapshots objectAtIndex:index-numPerRow]];
                }
            }
        }
        if(index < totalNum - numPerRow){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index+numPerRow)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index+numPerRow)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index+numPerRow)]];
                    [addFlip addObject:[snapshots objectAtIndex:index+numPerRow]];
                }
            }
        }
    }
    for(UIView * added in addFlip){
        [self triggerFlip:added];
        [flippedViews addObject:[NSNumber numberWithInteger:added.tag]];
    }
    [self performSelector:@selector(triggerFlips) withObject:nil afterDelay:0.05f];
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = 1;
    CGRect frame = view.frame;
    view.frame = CGRectMake(frame.origin.x + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0  usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        view.transform = CGAffineTransformMakeTranslation(pickedCenter.x - view.center.x, pickedCenter.y - view.center.y);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        flippedCount ++;
        if(flippedCount == totalCount){
            [(UIView*)[snapshots objectAtIndex:randomPick] removeFromSuperview];
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}
@end



@interface TransitionAnimationWind : NSObject<UIViewControllerAnimatedTransitioning>

@end
@interface TransitionAnimationWind ()
{
    CGFloat width;
    int totalCount;
    int finishedCounter;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation TransitionAnimationWind

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    mtransitionContext = transitionContext;
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    finishedCounter = 0;
    totalCount = 0;
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 4.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    width = size.width / xFactor;
    NSInteger numPerRow = 0;
    NSInteger totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
        numPerRow ++;
        for (CGFloat x = size.width - size.width / xFactor; x >=0; x -=size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            snapshot.tag = totalCount;
            totalCount ++;
        }
    }
    
    [containerView sendSubviewToBack:fromView];
    
    for(int i = 0 ; i < numPerRow ; i ++){
        NSTimeInterval delay = i * 0.1f;
        for(int j = 0 ; j < totalNum/numPerRow ; j ++){
            [self performSelector:@selector(triggerFlip:) withObject:[snapshots objectAtIndex:(j + i * totalNum/numPerRow)] afterDelay:delay];
            delay += 0.1f;
        }
    }
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = width/10;
    CGRect frame = view.layer.frame;
    view.layer.frame = CGRectMake(frame.origin.x + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0 options:0 animations:^{
        view.layer.transform = [self getTransForm3DWithAngle:-M_PI_2 offset : frame.origin.x];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        finishedCounter ++;
        if(finishedCounter == totalCount){
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}

-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle offset : (CGFloat) offset{
    CATransform3D move = CATransform3DMakeTranslation(0, 0, offset + width - [UIScreen mainScreen].bounds.size.width);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, width);
    CATransform3D rotate = CATransform3DMakeRotation(angle, 0, 1, 0);
    CATransform3D mat = CATransform3DConcat(CATransform3DConcat(move, rotate), back);
    return CATransform3DPerspect(mat, CGPointZero, 500);
    
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

@end






@implementation UINavigationController (TransitionAnimation)


- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(self.transitionType == TransitionAnimationTypeFlip)
    {
        return [[TransitionAnimationFlip alloc] init];
    }
    else if(self.transitionType == TransitionAnimationTypeWind)
    {
        return [[TransitionAnimationWind alloc] init];
    }
    else if(self.transitionType == TransitionAnimationTypeScale)
    {
        return [[TransitionAnimationScale alloc] init];
    }
    else if(self.transitionType == TransitionAnimationTypeDrawer)
    {
        return [[TransitionAnimationDrawer alloc] init];
    }
    
    return nil;
}


- (void)setTransitionType:(TransitionAnimationType)transitionType
{
    objc_setAssociatedObject(self, @selector(transitionType), @(transitionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TransitionAnimationType)transitionType
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}


@end
