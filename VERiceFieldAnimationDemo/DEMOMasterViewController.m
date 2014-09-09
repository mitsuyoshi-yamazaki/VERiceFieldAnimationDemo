//
//  DEMOMasterViewController.m
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import "DEMOMasterViewController.h"

#import "VERiceFieldTransition.h"

#import "DEMODetailViewController.h"

@interface DEMOMasterViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIButton *selectedButton;

- (NSString *)colorForTag:(NSInteger)tag;

@end

@implementation DEMOMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}

#pragma mark - Accessor
- (NSString *)colorForTag:(NSInteger)tag {
	return @[@"Gray", @"Green", @"Blue", @"Pink"][tag - 100];
}

#pragma mark - UIStoryboardSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	self.selectedButton = sender;
	NSString *color = [self colorForTag:self.selectedButton.tag];
	NSLog(@"%@ color", color);
	
	UINavigationController *navigationController = segue.destinationViewController;
	navigationController.transitioningDelegate = self;

	DEMODetailViewController *detailViewController = (DEMODetailViewController *)navigationController.topViewController;
	detailViewController.view.backgroundColor = self.selectedButton.backgroundColor;
	detailViewController.title = color.uppercaseString;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	
	VERiceFieldTransition *transition = [[VERiceFieldTransition alloc] initWithFromRect:self.selectedButton.frame presenting:YES];
	
	return transition;
}

@end
