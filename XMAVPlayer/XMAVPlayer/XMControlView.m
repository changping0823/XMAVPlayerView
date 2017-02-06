//
//  XMControlView.m
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import "XMControlView.h"
#import "XMAVPlayerView.h"
#import "Masonry.h"

#define ToolBarHeight 44

@implementation XMControlView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _onControl = NO;
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, ToolBarHeight)];
        [_topView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
//        [self addSubview:_topView];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(0.0f, 22.0f, 40.0f, 40.0f)];
        [_backButton setImage:[UIImage imageNamed:@"navigation_back_icon"] forState:UIControlStateNormal];
//        [_topView addSubview:_backButton];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(48.0f, 20.0f, _topView.bounds.size.width-48.0f, 44.0f)];
        [_titleLabel setTextColor:[UIColor lightGrayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
//        [_topView addSubview:_titleLabel];
        
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.bounds.size.height-64.0f, self.bounds.size.width, ToolBarHeight)];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
        [self addSubview:_bottomView];
        
        _progressSlider = [[XMProgressSlider alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 35.0f)];
        [_bottomView addSubview:_progressSlider];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setFrame:CGRectMake(10.0f, 22.0f, 40.0f, 40.0f)];
        [self setPlayButtonSelected:NO];
        [_bottomView addSubview:_playButton];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(68.0f, 22.0f, _bottomView.bounds.size.width-118.0f, 40.0f)];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[UIColor lightGrayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_bottomView addSubview:_timeLabel];
        
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleButton setFrame:CGRectMake(_bottomView.bounds.size.width-50.0f, 22.0f, 40.0f, 40.0f)];
        [_scaleButton setImage:[UIImage imageNamed:@"enterFullNormal"] forState:UIControlStateNormal];
        [_scaleButton setImage:[UIImage imageNamed:@"video-player-shrinkscreen"] forState:UIControlStateSelected];
        [_bottomView addSubview:_scaleButton];
        
        [self makeConstraints];
        
        
    }
    return self;
}

-(void)makeConstraints{
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(self);
//        make.height.mas_equalTo(ToolBarHeight);
//    }];
//    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.mas_equalTo(_topView);
//        make.width.mas_equalTo(_backButton.mas_height);
//    }];
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_backButton.mas_right);
//        make.top.bottom.right.mas_equalTo(_topView);
//    }];
    
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_bottomView);
        make.height.mas_equalTo(10);
    }];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView).offset(10);
        make.top.mas_equalTo(_progressSlider.mas_bottom);
        make.bottom.mas_equalTo(_bottomView.mas_bottom);
        make.width.mas_equalTo(_playButton.mas_height);
    }];
   
    [_scaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomView).offset(-10);
        make.top.mas_equalTo(_progressSlider.mas_bottom);
        make.bottom.mas_equalTo(_bottomView.mas_bottom);
        make.width.mas_equalTo(_scaleButton.mas_height);
    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_playButton.mas_right).offset(20);
        make.top.mas_equalTo(_progressSlider.mas_bottom);
        make.bottom.mas_equalTo(_bottomView);
        make.right.mas_equalTo(_scaleButton.mas_left);
    }];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _onControl = YES;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    _onControl = YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    _onControl = NO;
    if ([self.superview isKindOfClass:[XMAVPlayerView class]])
    {
        [(XMAVPlayerView*)self.superview performSelector:@selector(dissmissControlView) withObject:nil afterDelay:2.0f];
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    _onControl = NO;
    if ([self.superview isKindOfClass:[XMAVPlayerView class]])
    {
        [(XMAVPlayerView*)self.superview performSelector:@selector(dissmissControlView) withObject:nil afterDelay:2.0f];
    }
}

-(void)setPlayButtonSelected:(BOOL)selected
{
    _playButton.selected = selected;
    if (_playButton.selected)
    {
        [_playButton setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }
    else
    {
        [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
}

- (UIButton *)resume{
    if (!_resume) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"icon_repeat_video"] forState:UIControlStateNormal];
        _resume = button;
    }
    return _resume;
}



@end
