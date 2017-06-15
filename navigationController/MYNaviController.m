//
//  MYNaviViewController.m
//  navigationController
//
//

#import "MYNaviController.h"

@interface MYNaviController ()

@end

@implementation MYNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor clearColor];//bar背景颜色
    
    self.navigationBar.tintColor = [UIColor whiteColor];//bar文字颜色
    
    self.navigationBar.barStyle = UIBarStyleBlack;//屏幕顶部状态栏 运营商标志、时间等图标的颜色。

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
