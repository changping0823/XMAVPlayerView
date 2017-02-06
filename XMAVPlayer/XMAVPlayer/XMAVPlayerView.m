//
//  XMAVPlayerView.m
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import "XMAVPlayerView.h"

#import "VideoResourceSupport.h"

@interface XMAVPlayerView ()

@property(nonatomic,strong,readonly)AVPlayerLayer *playLayer;
@property(nonatomic,strong)AVPlayerItem *playItem;
@property(nonatomic,strong,readonly)VideoResourceSupport * resourceDelegate;



@end

@implementation XMAVPlayerView
-(instancetype)initWithFrame:(CGRect)frame urlPath:(NSString *)urlPath
{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setBackgroundColor:[UIColor blackColor]];
        _playView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_playView];
        
        _controlView = [[XMControlView alloc]initWithFrame:self.bounds];
        [_controlView setAlpha:0.0f];
        
        [_controlView.playButton addTarget:self action:@selector(changePlayState:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView.resume addTarget:self action:@selector(resumeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_controlView.scaleButton addTarget:self action:@selector(changeToFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_controlView.backButton addTarget:self action:@selector(changeToSmallScreen) forControlEvents:UIControlEventTouchUpInside];
        
        typeof(self) __weak weakself = self;
        
        [_controlView.progressSlider setChangeBlock:^(float progress){
            typeof(weakself) __strong strongself = weakself;
            [strongself changeProgress:progress];
        }];
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:urlPath] resolvingAgainstBaseURL:NO];
        components.scheme = @"streaming";
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[components URL] options:nil];
        _resourceDelegate = [[VideoResourceSupport alloc]initWithURL:[components URL]];
        [asset.resourceLoader setDelegate:self.resourceDelegate queue:dispatch_get_main_queue()];
        _playItem = [AVPlayerItem playerItemWithAsset:asset];
        _player = [AVPlayer playerWithPlayerItem:_playItem];
        [_player setVolume:0.5f];
        
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time)
         {
             
             __strong __typeof(weakself) strongSelf = weakself;
             if (!strongSelf.controlView.progressSlider.onControl)
             {
                 if (strongSelf.playItem.currentTime.timescale != 0.0f && strongSelf.playItem.duration.timescale != 0.0f)
                 {
                     float time = strongSelf.playItem.currentTime.value/strongSelf.playItem.currentTime.timescale;
                     float totalTime = strongSelf.playItem.duration.value / strongSelf.playItem.duration.timescale;
                     
                     if (totalTime > 0.0f)
                     {
                         float current = time/totalTime;
                         [strongSelf.controlView.progressSlider setValue:current];
                     }
                 }
             }
             
             [strongSelf setCurrentDate];
         }];
        
        [_resourceDelegate setDataBlock:^(NSArray<__kindof LocationFileInfo*>* dataRanges,VideoResourceSupport *sp)
         {
             __strong __typeof(weakself) strongSelf = weakself;
             [strongSelf drawCacheRanges:dataRanges];
         }];
        
        
        [self.controlView.titleLabel setText:@"视频标题"];
        
        _playLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [_playLayer setFrame:_playView.bounds];
        [_playView.layer addSublayer:_playLayer];
        
        _isFullScreen = NO;
        
        _smallRect = frame;
        
        _showControl = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showControlView:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
-(void)drawCacheRanges:(NSArray<__kindof LocationFileInfo*>*)dataRanges
{
    NSMutableArray *ranges = [NSMutableArray array];
    for (LocationFileInfo *info in dataRanges)
    {
        float startX = (1.0f*info.startLocation/_resourceDelegate.videoLength);
        float lineWidth = (1.0f*info.dataLength/_resourceDelegate.videoLength);
        
        [ranges addObject:[[CacheRange alloc] initWithStartLocation:startX cacheLength:lineWidth]];
    }
    
    [_controlView.progressSlider setRanges:ranges];
}
-(void)changePlayState:(UIButton*)sender
{
    [_controlView setPlayButtonSelected:!sender.selected];
    if (_controlView.playButton.selected)
    {
        [_player play];
    }
    else
    {
        [_player pause];
    }
}
-(void)resumeButtonClick:(UIButton *)sender{
    
}

-(void)resume{
    if (!_playItem) {
        return;
    }
    [self.player play];
}


-(void)setCurrentDate
{
    float time = self.playItem.currentTime.value/self.playItem.currentTime.timescale;
    float totalTime = self.playItem.duration.value / self.playItem.duration.timescale;
    
    [self.controlView.timeLabel setText:[NSString stringWithFormat:@"%@ / %@",[self stringFromTime:time],[self stringFromTime:totalTime]]];
}
-(NSString*)stringFromTime:(float)time
{
    long videocurrent = ceil(time);
    
    NSString *str = @"";
    
    if (videocurrent < 3600)
    {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    }
    else
    {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    
    return str;
}
- (void)changeProgress:(float)progress
{
    float seconds = _playItem.duration.value / _playItem.duration.timescale*progress;
    [_player pause];
    typeof(_player) __weak weakplayer = _player;
    [_player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished)
     {
         typeof(weakplayer) __strong strongplayer = weakplayer;
         [strongplayer play];
         
     }];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    [_playView setFrame:self.bounds];
    [_playLayer setFrame:_playView.bounds];
    [_controlView setFrame:self.bounds];
}

-(void)showControlView:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dissmissControlView) object:nil];
        
        if (!_showControl)
        {
            [self setShowControl:YES];
        }
    }
}
-(void)dissmissControlView
{
    if (!_controlView.onControl)
    {
        [self setShowControl:NO];
    }
}
-(void)setShowControl:(BOOL)showControl
{
    _showControl = showControl;
    if (_showControl)
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_controlView setAlpha:1.0f];
            [self addSubview:_controlView];
        } completion:^(BOOL finished) {
            _showControl = YES;
            
            [self performSelector:@selector(dissmissControlView) withObject:nil afterDelay:2.0f];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_controlView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [_controlView removeFromSuperview];
            _showControl = NO;
        }];
    }
}

-(void)setSmallRect:(CGRect)smallRect
{
    _smallRect = smallRect;
    if (!_isFullScreen){
        [self setTransform:CGAffineTransformIdentity];
        [self setFrame:_smallRect];
        
        [[self getPlayerViewVC] setNeedsStatusBarAppearanceUpdate];
        
    }
}

-(void)changeToSmallScreen{
    _isFullScreen = NO;
    _controlView.scaleButton.selected = NO;
    [self setTransform:CGAffineTransformIdentity];
    [self setFrame:_smallRect];
    
    [[self getPlayerViewVC] setNeedsStatusBarAppearanceUpdate];
    
}

-(void)changeToFullScreen:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _controlView.scaleButton.selected = YES;
        if (_isFullScreen){
            _isFullScreen = NO;
            [self setTransform:CGAffineTransformIdentity];
            [self setFrame:_smallRect];
            
        }else{
            _isFullScreen = YES;
            if (_playItem.presentationSize.width > _playItem.presentationSize.height){
                [self setFrame:[self frameFrom:self.superview.bounds]];
                [self setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2)];
            } else{
                [self setTransform:CGAffineTransformIdentity];
                [self setFrame:self.superview.bounds];
            }
        }
        
    }else{
        [self changeToSmallScreen];
    }
    
    if ([self.delegate respondsToSelector:@selector(isFullScreen:)]) {
        [self.delegate isFullScreen:_isFullScreen];
    }
    [[self getPlayerViewVC] setNeedsStatusBarAppearanceUpdate];
}

-(CGRect)frameFrom:(CGRect)f
{
    CGRect rect = CGRectMake(f.origin.x+(f.size.width-f.size.height)/2.0f, f.origin.y-(f.size.width-f.size.height)/2.0f, f.size.height, f.size.width);
    return rect;
}

- (UIViewController *)getPlayerViewVC
{
    id page = self;
    
    for (int i=0; i<100; i++)
    {
        if ([page isKindOfClass:[UIViewController class]])
        {
            return page;
        }
        page = [page nextResponder];
    }
    
    return nil;
}





@end
