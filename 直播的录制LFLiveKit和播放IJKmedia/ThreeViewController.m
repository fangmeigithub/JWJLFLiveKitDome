//
//  ThreeViewController.m
//  MyNewTest
//
//  Created by liubaojian on 2018/6/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ThreeViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface ThreeViewController ()
@property(nonatomic, retain)id<IJKMediaPlayback>Play;
@property (nonatomic, weak)  UIView *MadieView;\
@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
      //地址URL
      NSURL *starUrl = [NSURL URLWithString:@"rtmp://192.168.1.107:1935/rtmplive/room"];
      //创建一个播放器对象
      _Play = [[IJKFFMoviePlayerController alloc] initWithContentURL:starUrl withOptions:nil];
      //通过代理对象返回一个播放视频的View
      [self setupMadieView];
      //准备播放
      [_Play prepareToPlay];
      //开始播放
      [_Play play];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

//通过代理对象返回一个播放视频的view
- (void)setupMadieView {
    //通过代理对象view返回一个MadieView
    UIView *MadieView = [_Play view];
    _MadieView = MadieView;
    
    //横竖屏适配
    MadieView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    MadieView.frame = self.view.frame;
    [self.view addSubview:MadieView];
    
}


@end
