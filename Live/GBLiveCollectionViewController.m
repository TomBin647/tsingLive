//
//  GBLiveCollectionViewController.m
//  Live
//
//  Created by 高彬 on 16/11/30.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import "GBLiveCollectionViewController.h"
#import "ALinUserView.h"
#import "ALinLiveViewCell.h"
#import "ALinLiveFlowLayout.h"
@interface GBLiveCollectionViewController ()

@property (nonatomic,weak) ALinUserView * userView;

@end

static NSString * const reuseIdentifier = @"ALinLiveViewCell";

@implementation GBLiveCollectionViewController

- (instancetype)init
{
    return [super initWithCollectionViewLayout:[[ALinLiveFlowLayout alloc] init]];
}

-(ALinUserView *) userView {
    if (!_userView) {
        ALinUserView * userView = [ALinUserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(KS_SCREEN_WIDTH));
            make.height.equalTo(@(KS_SCREEN_HEIGHT));
        }];
        
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [userView setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            } ];
        }];
    }
    return _userView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ALinLiveViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [KS_NOTIFY addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
}

- (void)clickUser:(NSNotification *)notify
{
    if (notify.userInfo[@"user"] != nil) {
        ALinUser *user = notify.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALinLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.parentVc = self;
    cell.live = self.lives[self.currentIndex];
    NSUInteger relateIndex = self.currentIndex;
    if (self.currentIndex + 1 == self.lives.count) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }
    cell.relateLive = self.lives[relateIndex];
    [cell setClickRelatedLive:^{
        self.currentIndex += 1;
        [self.collectionView reloadData];
    }];
    return cell;
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
