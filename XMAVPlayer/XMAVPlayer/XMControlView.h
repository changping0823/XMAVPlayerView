//
//  XMControlView.h
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMProgressSlider.h"

@interface XMControlView : UIView
@property(nonatomic,assign)BOOL onControl;

@property(nonatomic,strong,readonly)UIView *topView;
@property(nonatomic,strong,readonly)UIButton *backButton;
@property(nonatomic,strong,readonly)UILabel *titleLabel;


@property(nonatomic,strong,readonly)UIView *bottomView;
@property(nonatomic,strong,readonly)XMProgressSlider *progressSlider;

@property(nonatomic,strong,readonly)UIButton *playButton;

@property(nonatomic,strong,readonly)UILabel *timeLabel;

@property(nonatomic,strong,readonly)UIButton *scaleButton;
/** 重新播放按钮 */
@property (nonatomic, strong) UIButton * resume;

-(void)setPlayButtonSelected:(BOOL)selected;
@end
