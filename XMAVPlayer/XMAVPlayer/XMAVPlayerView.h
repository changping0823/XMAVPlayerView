//
//  XMAVPlayerView.h
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XMControlView.h"

@protocol XMAVPlayerDelegate <NSObject>
@optional
-(void)isFullScreen:(BOOL)isFull;

@end

@interface XMAVPlayerView : UIView

@property(nonatomic,strong,readonly)UIView *playView;
@property(nonatomic,strong,readonly)AVPlayer *player;
@property(nonatomic,assign)BOOL showControl;
@property(nonatomic,strong)XMControlView *controlView;
@property(nonatomic,assign)CGRect smallRect;
@property(nonatomic,assign,readonly)BOOL isFullScreen;

@property (nonatomic, weak) id<XMAVPlayerDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame urlPath:(NSString*)urlPath;
-(void)dissmissControlView;
/**
 *  重新播放
 */
-(void)resume;

@end
