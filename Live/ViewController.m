//
//  ViewController.m
//  Live
//
//  Created by 高彬 on 16/11/28.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "ViewController.h"
#import "SliderViewController.h"
#import "UIViewController+SliderViewController.h"
#import "LeftViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.dataSource =[NSMutableArray arrayWithObjects:@"弹出框",@"侧边栏",@"视频直播",@"开始直播", nil];
    [self.tableView reloadData];
    
    LeftViewController * leftVC = [LeftViewController new];
    
    
    //可自定义
    
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:self];
    
    
    
    SliderViewController *sliderVC = [[SliderViewController alloc] initWithMainViewController:mainNav leftViewController:leftVC rightViewController:nil];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = sliderVC;
    
}

-(UIButton *)navigationBarLeftButton {
    UIButton * leftBtn = [UIButton new];
    [leftBtn setTitle:@"侧边栏" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = KS_FONT(16);
    leftBtn.frame = CGRectMake(0, 0, 50, 30);
    return leftBtn;
}

-(void)navigationBarLeftButtonHandler:(id)sender {
//    self.view.x = KS_SCREEN_WIDTH/3;
    //显示出左边栏
    [[self sliderViewController]showLeft];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self promptMessage:@"我是弹出框" promptShow:YES];
    } else if (indexPath.row == 2) {
      //视频直播
        HomeViewController * homeVC = [HomeViewController new];
        [self pushWithController:homeVC];
    } else {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
