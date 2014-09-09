//
//  VERiceFieldTransition.h
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VERiceFieldTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithFromRect:(CGRect)fromRect presenting:(BOOL)presenting;

@end
