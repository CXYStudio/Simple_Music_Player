//
//  FirstViewController.m
//  navigationController
//
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"

int num = 0;//选择的歌曲编号

NSString *mySelectedMusicName;
NSMutableArray *myMusicNameArray;
@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *musicTableView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self myMusicInit];
    [self myTopBarInit];

    
    self.musicTableView.dataSource = self;
    self.musicTableView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self myMusicInit];

}
#pragma mark --music init
- (void)myMusicInit{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"documentPaths: %@",documentPaths);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentDir: %@",documentDir);
    
    NSError *error = nil;
    NSArray *fileList = [[NSMutableArray alloc]init];
    
    //fileList 所有文件的文件名数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    NSLog(@"fileList: %@",fileList);
    
    myMusicNameArray = [[NSMutableArray alloc]init];
    for (int i = 0,j = 0; i < [fileList count]; i++) {
        //是否为MP3文件
        NSString *temp1 = fileList[i];
        NSString *temp2 = [temp1 substringFromIndex:([temp1 length]-3)];
        NSLog(@"temp:%@,fileList[%d]:%@",temp2,i,fileList[i]);
        
        if ([temp2  isEqual: @"mp3"]) {
            myMusicNameArray[j] = fileList[i];
            j++;
            
        }
    }
//    self.myMusicNameArray = [[NSMutableArray alloc] initWithArray:fileList];
    
    NSLog(@"_myMusicNameArray: %@",myMusicNameArray);
    //刷新列表, 显示数据
    [_musicTableView reloadData];

}

- (void)myTopBarInit{
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    //左侧按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //中间的view
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    UIImage *imageTop=[UIImage imageNamed:@"icon.png"];
    
    //    titleView.backgroundColor = [UIColor greenColor];
    [titleView setImage:imageTop];
    
    [titleView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.navigationItem.titleView=titleView;
}



-(void) clickLeftBtn {
    NSLog(@"%s",__func__);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *SettingVC = [storyBoard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:SettingVC animated:YES];

    
}
-(void) clickRightBtn {
    NSLog(@"%s",__func__);
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *AddVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController pushViewController:AddVC animated:YES];
    
    

}


//- (IBAction)changeVC:(id)sender {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SecondViewController *secondVC = [storyBoard instantiateViewControllerWithIdentifier:@"SecondViewController"];
//    
////    SecondViewController *secondVC = [[SecondViewController alloc]init];
////    
////    每个viewcontroller里面有一个navigationcontroller控制器
//    [self.navigationController pushViewController:secondVC animated:YES];
//}

#pragma mark --选中歌曲
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *secondVC = [storyBoard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    //    SecondViewController *secondVC = [[SecondViewController alloc]init];
    //
    //    每个viewcontroller里面有一个navigationcontroller控制器
    [self.navigationController pushViewController:secondVC animated:YES];
    
    //选中歌曲名
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    mySelectedMusicName = [selectCell valueForKey:@"text"];
    NSLog(@"_mySelectedMusicName:%@",mySelectedMusicName);
    
//    for (int i = 0; i < [myMusicNameArray count]; i++) {
//        if (mySelectedMusicName == myMusicNameArray[i]) {
//            num = i;
//        }
//    }
    num = (int)indexPath.row;
    
}




#pragma mark - Table view data source


//返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [myMusicNameArray count];
    
}

//返回每行单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [myMusicNameArray objectAtIndex:row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 跳转指示图标
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f]; //设置cell背景透明
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    
    
    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
//
//
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"documentPaths: %@",documentPaths);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentDir: %@",documentDir);
   
    mySelectedMusicName =[[NSString alloc] initWithString:myMusicNameArray[indexPath.row]];
    
    NSString *temp = [@"/" stringByAppendingString:mySelectedMusicName];
    
    NSString *urlString = [documentDir stringByAppendingString:temp];
//    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSLog(@"urlString:%@",urlString);
    [fileManager removeItemAtPath:urlString error:nil];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [myMusicNameArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

}





@end
