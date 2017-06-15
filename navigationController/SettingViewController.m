//
//  SettingViewController.m
//  navigationController
//
//  Created by 曹修远 on 15/06/2017.
//  Copyright © 2017 mac. All rights reserved.
//

#import "SettingViewController.h"
#import "FirstViewController.h"
BOOL isWantBlurEffect = NO;
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *blurEffect;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (isWantBlurEffect == NO) {
        
        _blurEffect.on = NO;
    }else{
        
        _blurEffect.on = YES;
    }
    [_blurEffect addTarget:self action:@selector(changeBlurEffect:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_blurEffect];
    
    
    UIButton *myutton = [[UIButton alloc]init];
        //2.设置按钮上显示的文字
        [myutton setTitle:@"点我吧" forState:UIControlStateNormal];
        [myutton setTitle:@"摸我干啥" forState:UIControlStateHighlighted];
        //设置文字颜色
        [myutton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [myutton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    //3.加载图片
//    UIImage *playImgNormal = [UIImage imageNamed:@"播放"];
//    UIImage *playImgHighlighted = [UIImage imageNamed:@"播放"];
//    //4.设置背景图片
//    [myutton setBackgroundImage:playImgNormal forState:UIControlStateNormal];
//    [myutton setBackgroundImage:playImgHighlighted forState:UIControlStateHighlighted];
    //5.设置frame属性（位置和大小）
    myutton.frame = CGRectMake(self.view.bounds.size.width*0.5-40,self.view.bounds.size.height*0.87, 80, 80);
    //6.通过代码为控件注册一个单机事件
    [myutton addTarget:self action:@selector(changeBlurEffect:) forControlEvents:UIControlEventTouchUpInside];
    
    //7.把动态创建的控件添加到控制器的view中
    [self.view addSubview:myutton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeBlurEffect:(id)sender{
    if (isWantBlurEffect == NO) {
        isWantBlurEffect = YES;
        NSLog(@"isWantBlurEffect = YES");
        _blurEffect.on = YES;
    }else{
        isWantBlurEffect = NO;
        NSLog(@"isWantBlurEffect = NO");
        _blurEffect.on = NO;
    }
}
@end
