//
//  RootViewController.m
//  MyNewTest
//
//  Created by liubaojian on 2018/6/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "ThreeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 150, 100, 30)];
    [button addTarget:self action:@selector(toCrashing) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:243/255.0 green:60/255.0 blue:118/255.0 alpha:1]];
    [button setTitle:@"直播" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button];
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 230, 100, 30)];
    [button1 addTarget:self action:@selector(toCrashing1) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor:[UIColor colorWithRed:243/255.0 green:60/255.0 blue:118/255.0 alpha:1]];
    [button1 setTitle:@"观看" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button1];
}

- (void)toCrashing
{
    ViewController *subV = [[ViewController alloc]init];
    [self.navigationController pushViewController:subV animated:YES];
}
- (void)toCrashing1
{
    ThreeViewController *subV = [[ThreeViewController alloc]init];
    [self.navigationController pushViewController:subV animated:YES];
}


@end
