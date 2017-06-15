//
//  SecondViewController.m
//  navigationController
//
//

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SettingViewController.h"

extern NSString *mySelectedMusicName;
extern NSMutableArray *myMusicNameArray;
extern int num;//选择的歌曲编号，FirstViewController中定义，在不同文件中使用是要加extern
extern BOOL isWantBlurEffect;
NSString *numString;//歌曲名字
@interface SecondViewController ()<AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,retain) NSTimer *timerLrc;



@property (nonatomic,strong) UISlider *slider;
//button
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *pauseButton;
@property (nonatomic,strong) UIButton *stopButton;
@property (nonatomic,strong) UIButton *changeVolumeButton;
@property (nonatomic,strong) UIButton *silentButton;
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *previousButton;
@property (nonatomic,strong) UIButton *vocalButton;//静音之后恢复声音
//label
@property (nonatomic,strong) UILabel *valueLabel;//声音大小显示
@property (nonatomic,strong) UILabel *timeLabel;//已经播放的时间
//保存声音大小
@property (nonatomic,assign) float volume;


//专辑封面
@property (nonatomic,strong) UIImageView *albumCover;

//歌词
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSString *lrcContents;
@property (nonatomic,assign) NSUInteger currentLine;
@property (nonatomic,retain) NSMutableArray *lrcArray;
@property (nonatomic,retain) NSMutableArray *timeArray;
@property (nonatomic,retain) NSMutableArray *lengthArray;
@property (nonatomic,assign) BOOL isHasDisplayedNoLrc;
@property (nonatomic,retain) UILabel *noLrcLabel;
@property (nonatomic,retain) UILabel *noLrcLabel2;

@end
static NSString *tableIdentifier = @"cell";

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _isHasDisplayedNoLrc = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //顶部
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];//第二页bar颜色。
//    self.navigationItem.title = @"歌曲";//此处先注释，放入player中
    self.navigationItem.prompt =@"音乐播放器";//设置prompt属性
    //--左侧按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    self.navigationItem.leftBarButtonItem =leftBtn;
    //--右侧按钮
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //播放器部分
    //按钮
//    [self playButtonInit];

    [self nextButtonInit];
    [self previousButtonInit];
    [self silentButtonInit];
    
    //进度条和音量
    [self progressViewInit];
    [self sliderInit];
    
    //专辑封面
//    [self albumCoverInit];
    //音乐播放
    [self player];
    //歌词
    [self tableView];
    [self getLrcstring];

    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
    _timerLrc = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rollLrc) userInfo:nil repeats:YES];

    
    NSLog(@"选择的是第%d首歌曲",num);
    
    
}

#pragma mark --按钮
- (void)playButtonInit{
    //playButton
    //1.创建按钮
    _playButton = [[UIButton alloc]init];
    //    //2.设置按钮上显示的文字
    //    [_playButton setTitle:@"点我吧" forState:UIControlStateNormal];
    //    [_playButton setTitle:@"摸我干啥" forState:UIControlStateHighlighted];
    //    //设置文字颜色
    //    [_playButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    //    [_playButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    //3.加载图片
    UIImage *playImgNormal = [UIImage imageNamed:@"播放"];
    UIImage *playImgHighlighted = [UIImage imageNamed:@"播放"];
    //4.设置背景图片
    [_playButton setBackgroundImage:playImgNormal forState:UIControlStateNormal];
    [_playButton setBackgroundImage:playImgHighlighted forState:UIControlStateHighlighted];
    //5.设置frame属性（位置和大小）
    _playButton.frame = CGRectMake(self.view.bounds.size.width*0.5-40,self.view.bounds.size.height*0.87, 80, 80);
    //6.通过代码为控件注册一个单机事件
    [_playButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
    
    //7.把动态创建的控件添加到控制器的view中
    [self.view addSubview:_playButton];
}
- (void)pauseButtonInit{
    //pauseButton
    //1.创建按钮
    _pauseButton = [[UIButton alloc]init];
    //3.加载图片
    UIImage *pauseImgNormal = [UIImage imageNamed:@"暂停"];
    UIImage *pauseImgHighlighted = [UIImage imageNamed:@"暂停"];
    //4.设置背景图片
    [_pauseButton setBackgroundImage:pauseImgNormal forState:UIControlStateNormal];
    [_pauseButton setBackgroundImage:pauseImgHighlighted forState:UIControlStateHighlighted];
    //5.设置frame属性（位置和大小）
    _pauseButton.frame = CGRectMake(self.view.bounds.size.width*0.5-40,self.view.bounds.size.height*0.87, 80, 80);
    //6.通过代码为控件注册一个单机事件
    [_pauseButton addTarget:self action:@selector(pauseButton) forControlEvents:UIControlEventTouchUpInside];
    //7.把动态创建的控件添加到控制器的view中
    [self.view addSubview:_pauseButton];

}
- (void)nextButtonInit{
    _nextButton = [[UIButton alloc]init];
    UIImage *nextImgNormal = [UIImage imageNamed:@"下一首"];
    UIImage *nextImgHighlighted = [UIImage imageNamed:@"下一首"];
    [_nextButton setBackgroundImage:nextImgNormal forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:nextImgHighlighted forState:UIControlStateHighlighted];
    _nextButton.frame = CGRectMake(self.view.bounds.size.width*0.5+60,self.view.bounds.size.height*0.89, 50, 50);
    [_nextButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}
- (void)previousButtonInit{
    _previousButton = [[UIButton alloc]init];
    UIImage *previousImgNormal = [UIImage imageNamed:@"上一首"];
    UIImage *previousImgHighlighted = [UIImage imageNamed:@"上一首"];
    [_previousButton setBackgroundImage:previousImgNormal forState:UIControlStateNormal];
    [_previousButton setBackgroundImage:previousImgHighlighted forState:UIControlStateHighlighted];
    _previousButton.frame = CGRectMake(self.view.bounds.size.width*0.5-110,self.view.bounds.size.height*0.89, 50, 50);
    [_previousButton addTarget:self action:@selector(previousButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_previousButton];
}
- (void)stopButtonInit{
    _stopButton = [[UIButton alloc]init];
    UIImage *stopImgNormal = [UIImage imageNamed:@"停止"];
    UIImage *stopImgHighlighted = [UIImage imageNamed:@"停止"];
    [_stopButton setBackgroundImage:stopImgNormal forState:UIControlStateNormal];
    [_stopButton setBackgroundImage:stopImgHighlighted forState:UIControlStateHighlighted];
    _stopButton.frame = CGRectMake(self.view.bounds.size.width*0.5-50,self.view.bounds.size.height*0.9+15, 30, 30);
    [_stopButton addTarget:self action:@selector(stopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopButton];
}
- (void)silentButtonInit{
    _silentButton = [[UIButton alloc]init];
    UIImage *silentImgNormal = [UIImage imageNamed:@"静音"];
    UIImage *silentImgHighlighted = [UIImage imageNamed:@"静音"];
    [_silentButton setBackgroundImage:silentImgNormal forState:UIControlStateNormal];
    [_silentButton setBackgroundImage:silentImgHighlighted forState:UIControlStateHighlighted];
//    _silentButton.frame = CGRectMake(self.view.bounds.size.width*0.5+30,self.view.bounds.size.height*0.9+15, 30, 30);
    _silentButton.frame = CGRectMake(self.view.bounds.size.width*0.15,self.view.bounds.size.height*0.15, 30, 30);
    [_silentButton addTarget:self action:@selector(silentButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_silentButton];
}- (void)vocalButtonInit{
    _vocalButton = [[UIButton alloc]init];
    UIImage *vocalImgNormal = [UIImage imageNamed:@"恢复声音"];
    UIImage *vocalImgHighlighted = [UIImage imageNamed:@"恢复声音"];
    [_vocalButton setBackgroundImage:vocalImgNormal forState:UIControlStateNormal];
    [_vocalButton setBackgroundImage:vocalImgHighlighted forState:UIControlStateHighlighted];
//    _vocalButton.frame = CGRectMake(self.view.bounds.size.width*0.5+30,self.view.bounds.size.height*0.9+15, 30, 30);
    _vocalButton.frame = CGRectMake(self.view.bounds.size.width*0.15,self.view.bounds.size.height*0.15, 30, 30);
    [_vocalButton addTarget:self action:@selector(vocalButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vocalButton];
}
#pragma mark --进度
- (void)progressViewInit{
    _progressView = [[UIProgressView alloc]init];
    _progressView.frame = CGRectMake(self.view.bounds.size.width*0.20,self.view.bounds.size.height*0.85, self.view.bounds.size.width*0.6, 20);
//    _progressView.trackTintColor = [UIColor redColor];
    _progressView.progressTintColor = [UIColor redColor];
    [self songTime];
    //显示总时间label
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.frame.origin.x + _progressView.frame.size.width + 5, _progressView.frame.origin.y, 50, 20)];
    
    totalLabel.textAlignment = NSTextAlignmentCenter;
    
    NSLog(@"歌曲总时间:%.0f",_player.duration);
    NSString *temp = [self myFormatTime:_player.duration];
   
    totalLabel.text = [NSString stringWithFormat:@"%@", temp];
    
    [self.view addSubview:totalLabel];
    
    [self.view addSubview:_progressView];

}
- (void)songTime{//进度条旁边显示已经播放时间
    [self player];
    //显示已经播放时间label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.frame.origin.x - 50, _progressView.frame.origin.y, 50, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    NSString *temp = [self myFormatTime:_player.currentTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", temp];
    [self.view addSubview:self.timeLabel];
    
//    NSLog(@"%f",_player.currentTime);
}
//播放时间格式化
- (NSString *)myFormatTime:(NSInteger)myUnFormatTime{
    NSInteger m = myUnFormatTime / 60;
    NSInteger s = myUnFormatTime % 60;
    NSString *formatTime = [[NSString alloc] init];
    formatTime = [NSString stringWithFormat:@"%ld:%ld",m,s];
    if (m<10 && s<10) {
        formatTime = [NSString stringWithFormat:@"0%ld:0%ld",m,s];
    }
    else if (m<10){
        formatTime = [NSString stringWithFormat:@"0%ld:%ld",m,s];
    }else if (s<10){
        formatTime = [NSString stringWithFormat:@"%ld:0%ld",m,s];
    }
    else
        formatTime = [NSString stringWithFormat:@"%ld:%ld",m,s];
    
    return formatTime;
}
- (void)sliderInit{
    _slider = [[UISlider alloc]init];
    _slider.frame = CGRectMake(self.view.bounds.size.width*0.25, self.view.bounds.size.height*0.15, self.view.bounds.size.width*0.6, 30);
    _slider.tintColor = [UIColor redColor];
    _slider.minimumValue = 0;//设置最小值
    _slider.maximumValue = 5;//设置最大值
    _slider.value = 2.5;
    
    _slider.continuous = YES;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    [_slider addTarget:self action:@selector(slider) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}
#pragma mark --封面
- (void)albumCoverInit{
    _albumCover = [[UIImageView alloc]init];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"documentPaths: %@",documentPaths);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentDir: %@",documentDir);
    NSString *temp = [@"/" stringByAppendingString:numString];
    NSString *urlString = [documentDir stringByAppendingString:temp];
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSLog(@"urlString: %@",urlString);
    
    NSData *data = nil;
    AVURLAsset *avURLAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    for (NSString *item  in [avURLAsset availableMetadataFormats]){
        
        for (AVMetadataItem *metadataItem in [avURLAsset metadataForFormat:item]){
            if([metadataItem.commonKey isEqualToString:@"artwork"]){
//                data = [(NSDictionary*)metadataItem.value objectForKey:@"data"];
                data = metadataItem.value;
                break;
            }
        }
    }
    
    UIImage *image = [UIImage imageWithData:data];//提取图片
    //    UIImage *image = [UIImage imageNamed:numString];
    
    _albumCover.image = image;
    _albumCover.contentMode = UIViewContentModeScaleAspectFit;
    //    (2)设置圆角
    _albumCover.layer.masksToBounds = YES;
    _albumCover.layer.cornerRadius = 10;
    //    (3)设置边框颜色和大小
    _albumCover.layer.borderColor = [UIColor redColor].CGColor;
    _albumCover.layer.borderWidth = 2;
    _albumCover.frame = CGRectMake(self.view.bounds.size.width*0.1,self.view.bounds.size.height*0.23,self.view.bounds.size.width*0.8, self.view.bounds.size.width*0.8);
    //    _albumCover.frame = CGRectMake(10,66, 500, 500);
    
    [self.view addSubview:_albumCover];
    if (isWantBlurEffect == YES) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.image= image;
        [self.view insertSubview:imageView atIndex:0];
        
        UIImage *backGroundImage = [UIImage alloc];
        self.view.contentMode=UIViewContentModeScaleAspectFill;
        self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
        
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        visualEfView.frame =self.view.bounds;
        [imageView addSubview:visualEfView];
    }
    
}
- (UISlider *)slider{
    self.player.volume = _slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", _slider.value];
    return _slider;
}
- (UIButton *)playButton{
    NSLog(@"playButton");
    [_playButton removeFromSuperview];
    [self pauseButtonInit];
    
    [self.player play];
    return _playButton;
}
- (UIButton *)pauseButton{
    NSLog(@"pauseButton");
    [_pauseButton removeFromSuperview];
    [self playButtonInit];
  
    [self.player pause];
    
    return _pauseButton;
}
- (UIButton *)nextButton{
    NSLog(@"nextButton");
    if (num < [myMusicNameArray count] - 1) {
        num = num + 1;
    } else {
        num = 0;
    }
    NSLog(@"%d",num);
    
    [self judge];
    return _nextButton;
}
- (UIButton *)previousButton{
    NSLog(@"previousButton");
    if (num > 0 ) {
        num = num - 1;
    } else {
        num = (int)[myMusicNameArray count] - 1;
    }
    NSLog(@"%d",num);
    
    [self judge];
    return _previousButton;
}
- (UIButton *)stopButton{
    NSLog(@"stopButton");
    _player.currentTime = 0;
    [self.player stop];
    return _stopButton;
}

- (UIButton *)silentButton{//静音
    NSLog(@"silentButton");
    [_silentButton removeFromSuperview];
//    NSLog(@"%f",_slider.value);
    self.volume = _slider.value;//保存音量
    
    self.player.volume = 0;
    [self vocalButtonInit];
    return _silentButton;
}
- (UIButton *)vocalButton{//恢复声音
    NSLog(@"vocalButton");
    [_vocalButton removeFromSuperview];
    self.player.volume = self.volume;
    [self silentButtonInit];
    return _vocalButton;
}

- (void)playProgress{
    //通过百分比的方式，给progressview进行赋值
    _progressView.progress = _player.currentTime/_player.duration;
    [_timeLabel removeFromSuperview];
    [self songTime];
    
}

#pragma mark --判断歌曲编号并播放相应歌曲
- (void)judge{
    _currentLine = 0;
    [_albumCover removeFromSuperview];
    
    [_tableView removeFromSuperview];
    [_pauseButton removeFromSuperview];
    [_playButton removeFromSuperview];
    [_noLrcLabel2 removeFromSuperview];
    
    mySelectedMusicName = myMusicNameArray[num];
    numString = mySelectedMusicName;
    self.navigationItem.title = numString;
    //获取音乐文件
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"documentPaths: %@",documentPaths);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentDir: %@",documentDir);
    NSString *temp = [@"/" stringByAppendingString:numString];
    NSString *urlString = [documentDir stringByAppendingString:temp];
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSError *error = nil;
    
    //歌词
    numString = myMusicNameArray[num];
    NSArray *tempArray = [urlString componentsSeparatedByString:@"."];
    //    NSLog(@"[tempArray firstObject]:%@",[tempArray firstObject]);
    urlString = [tempArray firstObject];
    urlString = [urlString stringByAppendingString:@".lrc"];
    NSLog(@"##urlString:%@",urlString);
    url = [NSURL fileURLWithPath:urlString];
    NSLog(@"##test url:%@",url);
    
    NSLog(@"##myMusicLrcURL: %@",url);
    
    _lrcContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (_lrcContents != nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.05,self.view.bounds.size.height*0.7,self.view.bounds.size.width*0.9, 100) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        [self decodeTheLrc:_lrcContents];
    }else{
        [_tableView removeFromSuperview];
        _noLrcLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width*0.5, _tableView.frame.origin.y, _tableView.frame.size.width/2, _tableView.frame.size.height/2)];
        _noLrcLabel2.text = @"无歌词";
        _noLrcLabel2.textColor = [UIColor grayColor];
        [self.view addSubview:_noLrcLabel2];
        _isHasDisplayedNoLrc = YES;
        
    }

    //播放器
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"%@",error);
    }

    //准备播放
    [_player prepareToPlay];
    
    [self.player play];
    
    
    //设置代理
    _player.delegate = self;
    
    
    
}
#pragma mark --顶部
- (void)clickLeftBtn{
    [self stopButton];
//    num = 0;
    [self.navigationController popViewControllerAnimated:YES];//出栈
}
- (void)clickRightBtn{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark --播放器
- (AVAudioPlayer *)player{
    if (_player == nil) {
        
        NSLog(@"准备播放%@",mySelectedMusicName);
        
        numString = mySelectedMusicName;
        self.navigationItem.title = numString;
        //获取音乐文件
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSLog(@"documentPaths: %@",documentPaths);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        NSLog(@"documentDir: %@",documentDir);
        
        
//        NSString *urlString = [[NSBundle mainBundle] pathForResource:numString ofType:@"mp3"];
        
        NSString *temp = [@"/" stringByAppendingString:numString];
        NSString *urlString = [documentDir stringByAppendingString:temp];
        
        NSURL *url = [NSURL fileURLWithPath:urlString];
        
        
        
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        
        [self albumCoverInit];
        //准备播放
        [_player prepareToPlay];
        
        
        [self playButton];
        
        //设置代理
        _player.delegate = self;
        
    }
    
    
    return _player;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"一般这个方法中会暂停音频");
    [player stop];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    [player play];
    NSLog(@"继续播放");
}
#pragma mark --歌词
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.05,self.view.bounds.size.height*0.7,self.view.bounds.size.width*0.9, 100) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
//获取lrc歌词文件
- (void)getLrcstring{
    
    numString = myMusicNameArray[num];
    //获取音乐文件
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"documentPaths: %@",documentPaths);
    NSString *documentDir = [documentPaths objectAtIndex:0];
//    NSLog(@"documentDir: %@",documentDir);
    NSString *temp = [@"/" stringByAppendingString:numString];
//    NSLog(@"numString:%@",numString);
//    NSLog(@"temp:%@",temp);

    NSString *urlString = [documentDir stringByAppendingString:temp];
    NSArray *tempArray = [urlString componentsSeparatedByString:@"."];
//    NSLog(@"[tempArray firstObject]:%@",[tempArray firstObject]);
    urlString = [tempArray firstObject];
    urlString = [urlString stringByAppendingString:@".lrc"];
    NSLog(@"##urlString:%@",urlString);
    
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSLog(@"##test url:%@",url);
    NSError *error = nil;
    
    NSLog(@"##myMusicLrcURL: %@",url);
    _lrcContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (_lrcContents != nil) {
        [self decodeTheLrc:_lrcContents];
    
    }
    
}
//解析lrc歌词文件
- (void)decodeTheLrc:(NSString *)lrc{
    _lrcArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    _lengthArray = [NSMutableArray array];

    NSArray *tmpArray1 = [lrc componentsSeparatedByString:@"\n"];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:tmpArray1];
    [tmpArray removeObject:@""];
    
    [tmpArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        NSRange starRange = [obj rangeOfString:@"["];
        NSRange stopRange = [obj rangeOfString:@"]"];
        NSString *timeString = [obj substringWithRange:NSMakeRange(starRange.location + 1, stopRange.location - starRange.location - 1)];
        [_timeArray addObject:timeString];//截选出时间并加入数组
        
        NSString *minString = [timeString substringWithRange:NSMakeRange(0, 2)];
        NSString *secString = [timeString substringWithRange:NSMakeRange(3,5)];
        
        float timeLength = [minString floatValue] * 60 + [secString floatValue];
        [_lengthArray addObject:[NSString stringWithFormat:@"%.3f",timeLength]];
        
        NSString *lyricString = [obj substringFromIndex:10];
        
        [_lrcArray addObject:lyricString];
    }];
    
    [_tableView reloadData];
    
}
#pragma mark tableView DataSource&delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_lrcArray.count:%ld",_lrcArray.count);
    return _lrcArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_lrcArray != nil &&_lrcArray.count > 0) {
        NSInteger row = [indexPath row];
        cell.textLabel.text = [_lrcArray objectAtIndex:row];
    }

    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
- (void)rollLrc{
//    [self getLrcstring];
    CGFloat currentTime = _player.currentTime;
    CGFloat lrcTime = [[_lengthArray objectAtIndex:_currentLine + 1]floatValue];
    //    NSLog(@"%f --- %f",currentTime,lrcTime);
    if (currentTime >= lrcTime) {
        _currentLine += 1;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentLine inSection:0];
//    NSLog(@"%ld",indexPath.item);
    if (_lrcArray != nil) {
        if (_isHasDisplayedNoLrc == YES) {
            [_noLrcLabel removeFromSuperview];
            _isHasDisplayedNoLrc = NO;
        }
        
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
    }else if (_lrcArray == nil) {
        
        if (_isHasDisplayedNoLrc != YES) {
            [_tableView removeFromSuperview];
            _noLrcLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width*0.5, _tableView.frame.origin.y, _tableView.frame.size.width/2, _tableView.frame.size.height/2)];
            _noLrcLabel.text = @"无歌词";
            _noLrcLabel.textColor = [UIColor grayColor];
            [self.view addSubview:_noLrcLabel];
            _isHasDisplayedNoLrc = YES;
            
            
        }
        
    }
   
}


@end
