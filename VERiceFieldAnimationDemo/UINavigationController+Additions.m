//
//  UINavigationController+Additions.m
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import "UINavigationController+Additions.h"

@implementation UINavigationController (Additions)

- (UIStatusBarStyle)preferredStatusBarStyle {
	return self.topViewController.preferredStatusBarStyle;
}

@end
