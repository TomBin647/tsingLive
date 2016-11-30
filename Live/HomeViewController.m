//
//  HomeViewController.m
//  Live
//
//  Created by 高彬 on 16/11/29.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "HomeViewController.h"
#import "GBWebViewController.h"
#import "GBSelectedView.h"
#import "GBHotViewController.h"
#import "GBCareViewController.h"
#import "GBNewStartViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) GBSelectedView * selectedView;

@property(nonatomic, weak) UIScrollView *scrollView;

/** 热播 */
@property(nonatomic, weak) GBHotViewController *hotVc;
/** 最新主播 */
@property(nonatomic, weak) GBNewStartViewController *starVc;
/** 关注主播 */
@property(nonatomic, weak) GBCareViewController *careVc;

@end

@implementation HomeViewController

-(void)loadView {
    UIScrollView * view = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.contentSize = CGSizeMake(KS_SCREEN_WIDTH * 3, 0);
    view.backgroundColor = [UIColor whiteColor];
    view.showsVerticalScrollIndicator = NO;
    view.showsHorizontalScrollIndicator = NO;
    
    view.pagingEnabled = YES;
    
    view.delegate = self;
    view.bounces = NO;

    CGFloat height = KS_SCREEN_HEIGHT - 49;
    
    GBHotViewController *hot = [[GBHotViewController alloc] init];
    hot.view.frame = [UIScreen mainScreen].bounds;
    hot.view.height = height;
    [self addChildViewController:hot];
    [view addSubview:hot.view];
    _hotVc = hot;
    
    
    GBNewStartViewController *newStar = [[GBNewStartViewController alloc] init];
    newStar.view.frame = [UIScreen mainScreen].bounds;
    newStar.view.x = KS_SCREEN_WIDTH;
    newStar.view.height = height;
    [self addChildViewController:newStar];
    [view addSubview:newStar.view];
    _starVc = newStar;
    
    GBCareViewController *care = [GBCareViewController new];
    care.view.frame = [UIScreen mainScreen].bounds;
    care.view.x = KS_SCREEN_WIDTH * 2;
    care.view.height = height;
    [self addChildViewController:care];
    [view addSubview:care.view];
    _careVc = care;
    
    self.scrollView = view;
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //基本设置
    [self setup];
}

-(void)setup {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
    [self setupTopMenu];
}

-(void)rankCrown {
    //排行榜
    GBWebViewController * web = [[GBWebViewController alloc]initWithUrlStr:@"http://live.9158.com/Rank/WeekRank?Random=10"];
    [_selectedView removeFromSuperview];
    _selectedView = nil;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)navigationBarLeftButtonHandler:(id)sender {
    //搜索按钮
    [_selectedView removeFromSuperview];
    _selectedView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupTopMenu {
    GBSelectedView * selectedView = [[GBSelectedView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
    selectedView.x = 45;
    selectedView.width = KS_SCREEN_WIDTH - 45*2;
    [selectedView setSelectedBlock:^(HomeType type) {
        [self.scrollView setContentOffset:CGPointMake(type * KS_SCREEN_WIDTH, 0) animated:NO];
    }];
    [self.navigationController.navigationBar addSubview:selectedView];
    _selectedView = selectedView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / KS_SCREEN_WIDTH;
    CGFloat offsetX = scrollView.contentOffset.x / KS_SCREEN_WIDTH * (self.selectedView.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15);
    self.selectedView.underLine.x = 15 + offsetX;
    if (page == 1) {
        self.selectedView.underLine.x = offsetX + 10;
    } else if (page > 1) {
        self.selectedView.underLine.x = offsetX + 5;
    }
    self.selectedView.selectedType = (int)page + 0.5;
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
