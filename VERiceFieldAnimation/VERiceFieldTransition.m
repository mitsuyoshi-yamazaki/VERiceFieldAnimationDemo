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
	VERiceFieldTransitionDirectionCount,
}VERiceFieldTransitionDirection;

#define isVERiceFieldTransitionVerticalDirection(a)		((a == VERiceFieldTransitionDirectionTop) || (a == VERiceFieldTransitionDirectionBottom))
#define isVERiceFieldTransitionHorizontalDirection(a)	((a == VERiceFieldTransitionDirectionLeft) || (a == VERiceFieldTransitionDirectionRight))

@interface VERiceFieldTransition ()

@property (nonatomic, readonly) CGRect fromRect;
@property (nonatomic, readonly, getter = isPresenting) BOOL presenting;

- (UIView *)viewForDirection:(VERiceFieldTransitionDirection)direction snapshot:(UIView *)snapshot;
- (CGRect)viewFromFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size;
- (CGRect)viewToFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size;
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

//   UIView *snapshotView = self.presenting ? [fromViewController.view snapshotViewAfterScreenUpdates:NO] : [toViewController.view snapshotViewAfterScreenUpdates:YES];
	UIView *snapshotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
	
	NSMutableDictionary *snapshots = [NSMutableDictionary dictionaryWithCapacity:VERiceFieldTransitionDirectionCount];
	
	for (NSInteger i = 0; i < VERiceFieldTransitionDirectionCount; i++) {

		UIView *view = [self viewForDirection:i snapshot:snapshotView];
		
		[containerView addSubview:view];
		snapshots[@(i)] = view;
	}

	NSTimeInterval duration = [self transitionDuration:transitionContext];
	CGSize rootViewSize = snapshotView.frame.size;
	
	void (^handleView)(BOOL isVertical, BOOL isAnimation) = ^(BOOL isVertical, BOOL isAnimation) {
		
		for (NSInteger i = 0; i < VERiceFieldTransitionDirectionCount; i++) {
			
			if (isVertical) {
				if (isVERiceFieldTransitionHorizontalDirection(i)) {
					continue;
				}
			}
			else {
				if (isVERiceFieldTransitionVerticalDirection(i)) {
					continue;
				}
			}
			
			UIView *view = snapshots[@(i)];

			if (isAnimation) {
				view.frame = [self viewToFrameForDirection:i rootViewSize:rootViewSize];
			}
			else {
				[view removeFromSuperview];
			}
		}
	};
	
	if (self.isPresenting) {
				
		[containerView insertSubview:toViewController.view belowSubview:snapshots[@(0)]];
		
		[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			
			handleView(NO, YES);
			
		} completion:^(BOOL finished) {
			
			handleView(NO, NO);
			
			[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				
				handleView(YES, YES);
				
			} completion:^(BOOL finished) {
				
				handleView(YES, NO);
				
				BOOL completed = ![transitionContext transitionWasCancelled];
				[transitionContext completeTransition:completed];
				
			}];
		}];
	}
	else {
		
		[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			
			handleView(NO, YES);
			
		} completion:^(BOOL finished) {
			
			handleView(NO, NO);
			
			[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				
				handleView(YES, YES);
				
			} completion:^(BOOL finished) {
				
				handleView(YES, NO);
				
				[containerView addSubview:toViewController.view];
				
				BOOL completed = ![transitionContext transitionWasCancelled];
				[transitionContext completeTransition:completed];
				
			}];
		}];
	}
}

- (void)animationEnded:(BOOL) transitionCompleted {
	NSLog(@"%@, transitionCompleted: %d", NSStringFromSelector(_cmd), transitionCompleted);
}

#pragma mark - Accessor
- (UIView *)viewForDirection:(VERiceFieldTransitionDirection)direction snapshot:(UIView *)snapshot {

	CGRect frame = [self viewFromFrameForDirection:direction rootViewSize:snapshot.frame.size];
	UIView *view = [snapshot resizableSnapshotViewFromRect:frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	
	view.frame = frame;	// -resizableSnapshotViewFromRect:afterScreenUpdates:withCapInsets に渡しているframeはどうやらboundsとして処理されている（originが0,0になっている）ようなので
	
	return view;
}

- (CGRect)viewFromFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size {
	
	if (self.isPresenting) {
		return [self viewFrameForDirection:direction rootViewSize:size];
	}
	else {
		return [self viewOutFrameForDirection:direction rootViewSize:size];
	}
}

- (CGRect)viewToFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size {
	
	if (self.isPresenting) {
		return [self viewOutFrameForDirection:direction rootViewSize:size];
	}
	else {
		return [self viewFrameForDirection:direction rootViewSize:size];
	}
}

- (CGRect)viewFrameForDirection:(VERiceFieldTransitionDirection)direction rootViewSize:(CGSize)size {

	CGRect frame = CGRectZero;
	
	switch (direction) {
		case VERiceFieldTransitionDirectionTop:
			frame.size.width = size.width;
			frame.size.height = self.fromRect.origin.y;
			break;
			
		case VERiceFieldTransitionDirectionBottom:
			frame.origin.y = self.fromRect.origin.y + self.fromRect.size.height;
			frame.size.width = size.width;
			frame.size.height = size.height - frame.origin.y;
			break;
			
		case VERiceFieldTransitionDirectionLeft:
			frame = self.fromRect;
			frame.origin.x = 0.0f;
			frame.size.width = self.fromRect.origin.x;
			break;
			
		case VERiceFieldTransitionDirectionRight:
			frame = self.fromRect;
			frame.origin.x = self.fromRect.origin.x + self.fromRect.size.width;
			frame.size.width = size.width - frame.origin.x;
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
			frame.size.height = 0.0f;
			break;
			
		case VERiceFieldTransitionDirectionBottom:
			frame.size.height = 0.0f;
			frame.origin.y = size.height;
			break;
			
		case VERiceFieldTransitionDirectionLeft:
			frame.size.width = 0.0f;
			break;
			
		case VERiceFieldTransitionDirectionRight:
			frame.size.width = 0.0f;
			frame.origin.x = size.width;
			break;
			
		default:
			break;
	}

// screen外への移動frame
//	switch (direction) {
//		case VERiceFieldTransitionDirectionTop:
//			frame.origin.y = - frame.size.height;
//			break;
//			
//		case VERiceFieldTransitionDirectionBottom:
//			frame.origin.y = size.height;
//			break;
//			
//		case VERiceFieldTransitionDirectionLeft:
//			frame.origin.x = - frame.size.width;
//			break;
//			
//		case VERiceFieldTransitionDirectionRight:
//			frame.origin.x = size.width;
//			break;
//			
//		default:
//			break;
//	}
	
	return frame;
}

@end

