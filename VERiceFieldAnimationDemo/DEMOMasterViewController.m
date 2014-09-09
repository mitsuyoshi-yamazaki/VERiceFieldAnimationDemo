//
//  DEMOMasterViewController.m
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import "DEMOMasterViewController.h"

#import "DEMODetailViewController.h"

@interface DEMOMasterViewController ()

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

#pragma mark - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	UIButton *button = sender;
	NSString *color = [self colorForTag:button.tag];
	NSLog(@"%@ color", color);
	
	UINavigationController *navigationController = segue.destinationViewController;
	DEMODetailViewController *detailViewController = (DEMODetailViewController *)navigationController.topViewController;
	detailViewController.view.backgroundColor = button.backgroundColor;
	detailViewController.title = color.uppercaseString;
}

@end
