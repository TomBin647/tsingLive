//
//  GBHotViewController.m
//  Live
//
//  Created by 高彬 on 16/11/29.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "GBHotViewController.h"
#import "ALinHomeADCell.h"
#import "ALinHotLiveCell.h"
#import <UIScrollView+KS.h>
#import "ALinTopAD.h"
#import "GBWebViewController.h"
#import "ALinLive.h"
#import "GBLiveCollectionViewController.h"

@interface GBHotViewController ()

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray * lives;

@property (nonatomic,strong) NSArray * topADS;

@end

static NSString * reuseIdentifier = @"ALinHotLiveCell";
static NSString * ADReuseIdentifier = @"GbHomeADCell";


@implementation GBHotViewController

-(NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

-(void)setup{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ALinHotLiveCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    
    self.currentPage = 1;
    self.tableView.header = [[KSHeadRefreshView alloc]initWithDelegate:self];
    self.tableView.footer = [[KSFootRefreshView alloc] initWithDelegate:self];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lives = [NSMutableArray array];
    self.currentPage = 1;
    // 获取顶部的广告
    [self getTopAD];
    [self getHotLiveList];
}

- (void)refreshViewDidLoading:(id)view {
    if ([view isKindOfClass:[KSAutoFootRefreshView class]]) {
        self.currentPage++;
        [self getHotLiveList];
    }
    if ([view isKindOfClass:[KSHeadRefreshView class]]) {
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self getTopAD];
        [self getHotLiveList];
    }
}

-(void)getTopAD{
    [[ALinNetworkTool shareTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *result = responseObject[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADS = [ALinTopAD mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"网络异常"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"网络异常"];
    }];
}

-(void)getHotLiveList {
    [[ALinNetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.header setState:KSRefreshViewStateDefault];
        [self.tableView.footer setState:KSRefreshViewStateDefault];
        NSArray *result = [ALinLive mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.header setState:KSRefreshViewStateDefault];
        [self.tableView.footer setState:KSRefreshViewStateDefault];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lives.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 465;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ALinHomeADCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            [cell setImageClickBlock:^(ALinTopAD *topAD) {
                if (topAD.link.length) {
                    GBWebViewController *web = [[GBWebViewController alloc] initWithUrlStr:topAD.link];
                    web.navigationItem.title = topAD.title;
                    [self.navigationController pushViewController:web animated:YES];
                }
            }];
        }
        return cell;
    } else {
        ALinHotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (self.lives.count) {
            ALinLive *live = self.lives[indexPath.row-1];
            cell.live = live;
        }
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBLiveCollectionViewController *liveVc = [[GBLiveCollectionViewController alloc] init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row-1;
    [self presentViewController:liveVc animated:YES completion:nil];
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
