//
//  KSFBaseViewController.m
//  KSFAuthorClient
//
//  Created by bing.hao on 16/8/30.
//  Copyright © 2016年 Bingo. All rights reserved.
//

#import "HBBaseViewController.h"

@implementation HBBaseViewController

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)dealloc {
    for (NSString *entry in self.registerNotifications) {
        [KS_NOTIFY removeObserver:self name:entry object:nil];
    }
    if (_hud)        _hud        = nil;
    if (_tableView)  _tableView  = nil;
    if (_dataSource) _dataSource = nil;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    if (self.navigationController) {
        
        self.navigationController.navigationBar.barTintColor = G_NAV_BG_COLOR;
        self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : G_NAV_FONT_COLOR };
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
        UIButton *left  = [self navigationBarLeftButton];
        UIButton *right = [self navigationBarRightButton];
        
        if (left) {
            [left addTarget:self action:@selector(navigationBarLeftButtonHandler:)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        }
        if (right) {
            [right addTarget:self action:@selector(navigationBarRightButtonHandler:)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
        }
        
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barStyle    = UIBarStyleDefault;
        self.navigationController.navigationBar.opaque      = YES;
    }
    //注册通知
    for (NSString *entry in self.registerNotifications) {
        [KS_NOTIFY addObserver:self selector:@selector(receiveNotificationHandler:) name:entry object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isKeyboardListener]) {
        [KS_NOTIFY addObserver:self selector:@selector(receiveNotificationHandler:) name:UIKeyboardWillShowNotification object:nil];
        [KS_NOTIFY addObserver:self selector:@selector(receiveNotificationHandler:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self isKeyboardListener]) {
        [KS_NOTIFY removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [KS_NOTIFY removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - 自定义导航

/**
 * @brief 导航栏目左边按钮
 */
- (UIButton *)navigationBarLeftButton {
    if (self.isLeftButton || self.navigationController.viewControllers.count > 1 ) { // 排除persent模式
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 23, 44)];
        [backButton setImage:[UIImage imageNamed:@"kswv_back.png"] forState:UIControlStateNormal];
        return backButton;
    }else{
        return nil;
    }
}
/**
 * @brief 导航栏目右边按钮
 */
- (UIButton *)navigationBarRightButton {
    return nil;
}
/**
 * 导航栏左侧按钮事件
 */
- (void)navigationBarLeftButtonHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 导航栏右侧按钮事件
 */
- (void)navigationBarRightButtonHandler:(id)sender {
    
}

#pragma mark - 通知

/**
 * @brief 注册通知,在viewDidLoad方法中启动, dealloc方法销毁
 */
- (NSArray *)registerNotifications {
    return nil;
}
/**
 * @brief 接收通知
 */
- (void)receiveNotificationHandler:(NSNotification *)notice {
    
}

#pragma mark - 开启键盘监听

- (BOOL)isKeyboardListener{
    return NO;
}

#pragma mark - 扩展

- (void)pushWithController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWithController:(UIViewController *)vc animated:(BOOL)animated {
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)pushWithController:(Class)c params:(NSDictionary *)params {
    [self pushWithController:c params:params animated:YES];
}

- (void)pushWithController:(Class)c params:(NSDictionary *)params animated:(BOOL)animated {
    UIViewController * vc = [c new];
    if (params) {
        for (NSString * key in params.allKeys) {
            [vc setValue:[params objectForKey:key] forKeyPath:key];
        }
    }
    [self pushWithController:vc animated:animated];
}

- (void)pushWithName:(NSString *)name {
    [self pushWithName:name params:nil];
}

- (void)pushWithName:(NSString *)name params:(NSDictionary *)params {
    UIViewController * vc = [NSClassFromString(name) new];
    if (params) {
        for (NSString * key in params.allKeys) {
            
            [vc setValue:[params objectForKey:key] forKeyPath:key];
        }
    }
    [self pushWithController:vc];
}


- (UIView *)addChild:(UIView *)childView {
    [self.view addSubview:childView];
    return childView;
}

- (UIView *)addChild:(UIView *)childView atIndex:(NSInteger)index {
    [self.view insertSubview:childView atIndex:index];
    return childView;
}

- (UIView *)addChildWithVC:(UIViewController *)child {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    return child.view;
}


- (UIView *)addChildWithVC:(UIViewController *)child atIndex:(NSInteger)index {
    [self addChildViewController:child];
    [self.view insertSubview:child.view atIndex:index];
    return child.view;
}


- (UIView *)addChildWithClassType:(Class)classType {
    return [self addChildWithClassType:classType params:nil];
}

- (UIView *)addChildWithClassType:(Class)classType params:(NSDictionary *)params {
    id obj = [classType new];
    if (params) {
        for (NSString *key in params.allKeys) {
            [obj setValue:[params objectForKey:key] forKeyPath:key];
        }
    }
    [self addChild:obj];
    return obj;
}

- (UIView *)addChildWithClassName:(NSString *)className {
    return [self addChildWithClassType:NSClassFromString(className) params:nil];
}

- (UIView *)addChildWithClassName:(NSString *)className params:(NSDictionary *)params
{
    return [self addChildWithClassType:NSClassFromString(className) params:params];
}


#pragma mark - UITableView

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark - MBProgressHUD
- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    if ([_hud superview] == nil) {
        [self.view addSubview:_hud];
    }
    return _hud;
}

-(HBPromptBoxView *)promptBoxView {
    if (_promptBoxView == nil) {
        _promptBoxView = [HBPromptBoxView new];
        _promptBoxView.alpha = 0;
        _promptBoxView.backgroundColor = [UIColor clearColor];
        _promptBoxView.promptMessage = [NSString new];
        _promptBoxView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_promptBoxView];
        [_promptBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([UIApplication sharedApplication].keyWindow).insets(UIEdgeInsetsZero);
        }];
    }
    return _promptBoxView;
}
//提示框出现
-(void)promptMessage:(NSString *)Alertmessage promptShow:(BOOL)promptBool {
    self.promptBoxView.promptMessage = Alertmessage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    self.promptBoxView.alpha = 1;
    [UIView commitAnimations];
}
-(void)promptMessageHide:(BOOL)promptBool {
    [self removePromptBox];
}
//提示框消失代理
-(void)removePromptBox {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    self.promptBoxView.alpha = 0;
    [UIView commitAnimations];
}


- (void)showToast:(NSString *)text callback:(void (^)())cb {
    [self showToast:text duration:1.5f callback:cb];
}

- (void)showToast:(NSString *)text duration:(NSTimeInterval)duration callback:(void (^)())cb {
    
    KS_DISPATCH_MAIN_QUEUE(^{
        [self.hud setMode:MBProgressHUDModeText];
        [self.hud.detailsLabel setText:text];
        [self.hud setCustomView:nil];
        [self.hud showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            KS_DISPATCH_MAIN_QUEUE(^{
                [self.hud hideAnimated:NO];
                [self.hud.detailsLabel setText:nil];
                [self.hud setMode:MBProgressHUDModeIndeterminate];
                if (cb) {
                    cb();
                }
            });
        });
    });
}

#pragma mark  - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

@end
