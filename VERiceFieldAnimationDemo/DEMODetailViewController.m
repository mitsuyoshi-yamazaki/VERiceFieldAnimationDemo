//
//  DEMODetailViewController.m
//  VERiceFieldAnimationDemo
//
//  Created by Yamazaki Mitsuyoshi on 9/8/14.
//  Copyright (c) 2014 Mitsuyoshi. All rights reserved.
//

#import "DEMODetailViewController.h"

@interface DEMODetailViewController ()

- (IBAction)dismiss:(id)sender;

@end

@implementation DEMODetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	self.navigationController.navigationBar.barTintColor = self.view.backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - Behavior
- (IBAction)dismiss:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
