//
//  ViewController.m
//  MyNewTest
//
//  Created by liubaojian on 2018/5/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import<LFLiveKit/LFLiveKit.h>
#import"LFLiveKit.h"
//#import<IJKMediaFramework/IJKMediaFramework.h>

#define CJWScreenH [UIScreen mainScreen].bounds.size.height
#define CJWScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
<LFLiveSessionDelegate>
//当前区域网所在IP地址
@property (nonatomic,copy) NSString *ipAddress;
//我的房间号
@property (nonatomic,copy) NSString *myRoom;
//别人的房间号
@property (nonatomic,copy) NSString *othersRoom;
//ip后缀(如果用本地服务器,则为在nginx.conf文件中写的rtmplive)
@property (nonatomic, copy) NSString *suffix;
//大视图
@property (nonatomic,weak) UIView *bigView;
//小视图
@property (nonatomic,weak) UIView *smallView;
//播放器
//@property (nonatomic,strong)IJKFFMoviePlayerController *player;
//推流会话
@property (nonatomic,strong) LFLiveSession *session;
@property(nonatomic,strong)UIView * livingPreView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.livingPreView = [[UIView alloc]initWithFrame: [UIScreen mainScreen].bounds];
    [self.view addSubview:self.livingPreView];
    //这是一张图片,没有自己换一张
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"28258PICAJB.jpg!qt226.jpeg"]];
    [self requesetAccessForVideo];
    [self startLive];
    
    UIButton * stopbut = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-150, self.view.frame.size.width-40, 80)];
    [stopbut setTitle:@"开始直播" forState:0];
    stopbut.backgroundColor = [UIColor purpleColor]; stopbut.alpha = 0.3;
    [self.view addSubview:stopbut];
    [stopbut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)startLive{
    //RTMP要设置推流地址
    //在这里换成你自己的网址,或是本机网址,或是服务器网址,一定要换,要不然会提示IP有误
    LFLiveStreamInfo *streamInfo = [[LFLiveStreamInfo alloc]init];
    streamInfo.url = [NSString stringWithFormat:@"rtmp://192.168.1.107:1935/rtmplive/room"];
    [self.session startLive:streamInfo];
    self.session.captureDevicePosition=AVCaptureDevicePositionBack;
}

-(void)stopLive{
    [self.session stopLive];
}

- (void)buttonClick :(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self startLive];
        [sender setTitle:@"停止直播" forState:0];
    }else{
         [self stopLive];
        [sender setTitle:@"开始直播" forState:0];
    }
}

-(LFLiveSession *)session{ if (_session == nil) {
    //初始化session要传入音频配置和视频配置 //音频的默认配置为:采样率44.1 双声道 //视频默认分辨率为360 * 640
    _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Low1] ];
    //设置返回的视频显示在指定的view上
    _session.preView = self.livingPreView;
    _session.delegate = self;
    //是否输出调试信息
    _session.showDebugInfo = NO;
}
    return _session;
}

-(void)requesetAccessForVideo{
    __weak typeof(self)weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

/* 请求音频资源 */
-(void)requesetAccessForMedio{
    __weak typeof(self) weakSelf = self;
    //判断授权状态
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //运行会话
                        [weakSelf.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            //已授权则继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.session setRunning:YES];
            });
            break;
        }
        default:
            break;
    }
}

//代理
-(void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
    //弹出警告
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"连接错误,请检查IP地址后重试" preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { [self.navigationController popViewControllerAnimated:YES]; }]; [alert addAction:sure]; [self presentViewController:alert animated:YES completion:nil];
    
}
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state;
{
    if (state == LFLiveReady) {
        NSLog(@"准备");
    }else if (state == LFLivePending){
        NSLog(@"连接中");
    }else if (state == LFLiveStart){
        NSLog(@"已连接");
    }else if (state == LFLiveStop){
        NSLog(@"已断开");
    }else if (state == LFLiveError){
        NSLog(@"连接出错");
    }else if (state == LFLiveRefresh){
        NSLog(@"正在刷新");
    }
}
    
@end
