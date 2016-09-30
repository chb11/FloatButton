//
//  ViewController.m
//  MyFloatButton
//
//  Created by Mike on 2016/9/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ViewController.h"
#import "FloatingViewController.h"

#define screenwidth [[UIScreen mainScreen] bounds].size.width
#define screenheight [[UIScreen mainScreen] bounds].size.height


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 64)];
    headerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:headerView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenheight-50, screenwidth, 50)];
    footerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:footerView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    FloatingViewController *floatingView = [[FloatingViewController alloc] init];
    [self addChildViewController:floatingView];
    [self.view addSubview:floatingView.view];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
