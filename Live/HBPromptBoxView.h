//
//  HBPromptBoxView.h
//  HaoBan
//
//  Created by 高彬 on 16/11/22.
//  Copyright © 2016年 tsingda. All rights reserved.
//  弹出框

#import <UIKit/UIKit.h>

@protocol promptBoxDelegate <NSObject>

-(void)removePromptBox;

@end

@interface HBPromptBoxView : UIView

@property (nonatomic,strong) NSString * promptMessage;

@property (nonatomic,assign) id<promptBoxDelegate> delegate;

@end
