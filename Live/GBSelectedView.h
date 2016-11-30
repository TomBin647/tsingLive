//
//  GBSelectedView.h
//  Live
//
//  Created by 高彬 on 16/11/29.
//  Copyright © 2016年 tsingLive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,HomeType){
    HomeTypeHot,//热门
    HomeTypeNew,//最新
    HomeTypeCare//关注
};

@interface GBSelectedView : UIView

@property (nonatomic,copy)void (^selectedBlock)(HomeType type);

@property (nonatomic,strong) UIView * underLine;

@property (nonatomic,assign) HomeType selectedType;

@end
