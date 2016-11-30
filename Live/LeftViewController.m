//
//  LeftViewController.m
//  Live
//
//  Created by 高彬 on 16/11/28.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.image = [UIImage imageNamed:@"left_slider_back@2x.png"];
    backImgView.frame = self.view.bounds;
    backImgView.userInteractionEnabled = YES;
    [self.view addSubview:backImgView];

    
    self.tableView.frame = CGRectMake(10, 260, 120, 200);
    [self.view addSubview: self.tableView];
    self.dataSource = [NSMutableArray arrayWithObjects:@"个人中心",@"设置",@"关于", nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[self sliderViewController] hideLeft];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ZYTempViewController *controller = [[ZYTempViewController alloc] init];
//    //    [[self sliderNavigationController] pushViewController:controller animated:YES];
//    [[self sliderViewController].sliderNavigationController pushViewController:controller animated:YES];
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
