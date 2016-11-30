//
//  ALinLiveViewCell.h
//  Live
//
//  Created by 高彬 on 16/11/30.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALinLive,ALinUser;

@interface ALinLiveViewCell : UICollectionViewCell

/** 直播 */
@property (nonatomic, strong) ALinLive *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) ALinLive *relateLive;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property (nonatomic, copy) void (^clickRelatedLive)();

@end
