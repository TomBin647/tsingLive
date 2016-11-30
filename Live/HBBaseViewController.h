//
//  KSFBaseViewController.h
//  KSFAuthorClient
//
//  Created by bing.hao on 16/8/30.
//  Copyright © 2016年 Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "HBPromptBoxView.h"

@interface HBBaseViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    UIGestureRecognizerDelegate,
    promptBoxDelegate,
    KSRefreshViewDelegate
>

@property (nonatomic, assign) BOOL isLeftButton;

#pragma mark - 自定义导航

/**
 * @brief 导航栏目左边按钮
 */
- (UIButton *)navigationBarLeftButton;
/**
 * @brief 导航栏目右边按钮
 */
- (UIButton *)navigationBarRightButton;
/**
 * 导航栏左侧按钮事件
 */
- (void)navigationBarLeftButtonHandler:(id)sender;
/**
 * 导航栏右侧按钮事件
 */
- (void)navigationBarRightButtonHandler:(id)sender;

#pragma mark - 通知

/**
 * @brief 注册通知,在viewDidLoad方法中启动, dealloc方法销毁
 */
- (NSArray *)registerNotifications;
/**
 * @brief 接收通知
 */
- (void)receiveNotificationHandler:(NSNotification *)notice;

#pragma mark - 开启键盘监听

- (BOOL)isKeyboardListener;

#pragma mark - 扩展

/**
 * @brief 横向滑动转换在当前导航内
 */
- (void)pushWithController:(UIViewController *)vc;
- (void)pushWithController:(UIViewController *)vc animated:(BOOL)animated;
- (void)pushWithController:(Class)c params:(NSDictionary *)params;
- (void)pushWithController:(Class)c params:(NSDictionary *)params animated:(BOOL)animated;
- (void)pushWithName:(NSString *)name;
- (void)pushWithName:(NSString *)name params:(NSDictionary *)params;

/**
 * @brief 等同于UIView中的addSubView方法
 */
- (UIView *)addChild:(UIView *)childView;
- (UIView *)addChild:(UIView *)childView atIndex:(NSInteger)index;
- (UIView *)addChildWithVC:(UIViewController *)child;
- (UIView *)addChildWithVC:(UIViewController *)child atIndex:(NSInteger)index;

#pragma mark - UITableView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

#pragma mark - MBProgressHUD

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) HBPromptBoxView * promptBoxView;

/**
 * @brief 显示HUD并在XX秒后自动隐藏,并触发回调函数,默认1.5秒
 */

- (void)showToast:(NSString *)text callback:(void(^)())cb;
- (void)showToast:(NSString *)text duration:(NSTimeInterval)duration callback:(void (^)())cb;

//提示框出现
-(void)promptMessage:(NSString *)Alertmessage promptShow:(BOOL)promptBool;
//提示框消失  目前不需要
-(void)promptMessageHide:(BOOL)promptBool;

@end
