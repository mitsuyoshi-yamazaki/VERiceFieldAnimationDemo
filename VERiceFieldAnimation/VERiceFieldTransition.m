//
//  VERiceFieldTransition.m
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import "VERiceFieldTransition.h"

typedef enum {
	VERiceFieldTransitionDirectionTop,
	VERiceFieldTransitionDirectionBottom,
	VERiceFieldTransitionDirectionLeft,
	VERiceFieldTransitionDirectionRight,
}VERiceFieldTransitionDirection;

@interface VERiceFieldTransition ()

@property (nonatomic, readonly) CGRect fromRect;
@property (nonatomic, readonly, getter = isPresenting) BOOL presenting;

- (UIView *)viewForDirection:(VERiceFieldTransitionDirection)direction snapshot:(UIView *)snapshot;
- (CGRect)viewFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size;
- (CGRect)viewOutFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size;

@end

@implementation VERiceFieldTransition

@synthesize fromRect = _fromRect;
@synthesize presenting = _presenting;

- (id)initWithFromRect:(CGRect)fromRect presenting:(BOOL)presenting {

	self = [super init];
	if (self) {
		_fromRect = fromRect;
		_presenting = presenting;
	}
	return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
	return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];

    UIView *snapshotView = self.presenting ? [fromViewController.view snapshotViewAfterScreenUpdates:NO] : [toViewController.view snapshotViewAfterScreenUpdates:YES];

	UIView *leftView = [self viewForDirection:VERiceFieldTransitionDirectionLeft snapshot:snapshotView];
	CGRect leftOutFrame = [self viewOutFrameForDirection:VERiceFieldTransitionDirectionLeft rootViewSize:snapshotView.frame.size];
	
	UIView *topView = [self viewForDirection:VERiceFieldTransitionDirectionTop snapshot:snapshotView];
	CGRect topOutFrame = [self viewOutFrameForDirection:VERiceFieldTransitionDirectionTop rootViewSize:snapshotView.frame.size];
	
	[containerView addSubview:toViewController.view];
	
	[containerView addSubview:leftView];
	[containerView addSubview:topView];

	NSTimeInterval duration = [self transitionDuration:transitionContext];

	[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		
		leftView.frame = leftOutFrame;
		
	} completion:^(BOOL finished) {
		
		[leftView removeFromSuperview];
		
		[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			
			topView.frame = topOutFrame;
			
		} completion:^(BOOL finished) {
			
			[topView removeFromSuperview];
			
			BOOL completed = ![transitionContext transitionWasCancelled];
			[transitionContext completeTransition:completed];
			
		}];
	}];
}

- (void)animationEnded:(BOOL) transitionCompleted {
	NSLog(@"%@, transitionCompleted: %d", NSStringFromSelector(_cmd), transitionCompleted);
}

#pragma mark - Accessor
- (UIView *)viewForDirection:(VERiceFieldTransitionDirection)direction snapshot:(UIView *)snapshot {

	CGRect frame = [self viewFrameForDirection:direction rootViewSize:snapshot.frame.size];
	UIView *view = [snapshot resizableSnapshotViewFromRect:frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	
	view.frame = frame;	// -resizableSnapshotViewFromRect:afterScreenUpdates:withCapInsets に渡しているframeはどうやらboundsとして処理されている（originが0,0になっている）ようなので
	
	return view;
}

- (CGRect)viewFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size {

	CGRect frame = CGRectZero;
	
	switch (direction) {
		case VERiceFieldTransitionDirectionTop:
			frame.size.width = size.width;
			frame.size.height = self.fromRect.origin.y;
			break;
			
		case VERiceFieldTransitionDirectionBottom:
			
			break;
			
		case VERiceFieldTransitionDirectionLeft:
			frame = self.fromRect;
			frame.origin.x = 0.0f;
			frame.size.width = size.width - self.fromRect.origin.x;
			break;
			
		case VERiceFieldTransitionDirectionRight:
			
			break;
			
		default:
			break;
	}
	
	return frame;
}

- (CGRect)viewOutFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size {
	
	CGRect frame = [self viewFrameForDirection:direction rootViewSize:size];
	
	switch (direction) {
		case VERiceFieldTransitionDirectionTop:
			frame.origin.y = - frame.size.height;
			break;
			
		case VERiceFieldTransitionDirectionBottom:
			
			break;
			
		case VERiceFieldTransitionDirectionLeft:
			frame.origin.x = - frame.size.width;
			break;
			
		case VERiceFieldTransitionDirectionRight:
			
			break;
			
		default:
			break;
	}
	
	return frame;
}

@end

