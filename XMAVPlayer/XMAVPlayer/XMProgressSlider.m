//
//  XMProgressSlider.m
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import "XMProgressSlider.h"

@implementation CacheRange

-(instancetype)initWithStartLocation:(float)startLocation cacheLength:(float)cacheLength
{
    self = [self init];
    if (self)
    {
        _startLocation = startLocation;
        _cacheLength = cacheLength;
        _endLocation = startLocation+_cacheLength-1;
    }
    return self;
}

@end

@interface XMProgressSlider ()
@property(nonatomic,strong,readonly)CAShapeLayer *blankLayer;
@property(nonatomic,strong,readonly)CAShapeLayer *progressLayer;
@property(nonatomic,strong,readonly)CAShapeLayer *cacheLayer;
@property(nonatomic,strong,readonly)CALayer *pointLayer;
@property(nonatomic,assign,readonly)BOOL canDone;
@property(nonatomic,assign,readonly)CGFloat startX;
@property(nonatomic,assign,readonly)float startValue;
@end

@implementation XMProgressSlider

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _onControl = NO;
        _canDone = NO;
        _lineWidth = 2.0f;
        _pointSize = 12.0f;
        
        _blankLayer = [CAShapeLayer layer];
        [_blankLayer setFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _lineWidth)];
        [_blankLayer setFillColor:[UIColor grayColor].CGColor];
        UIBezierPath *blankPath = [UIBezierPath bezierPathWithRect:_blankLayer.bounds];
        [_blankLayer setPath:blankPath.CGPath];
        [self.layer addSublayer:_blankLayer];
        
        
        _cacheLayer = [CAShapeLayer layer];
        [_cacheLayer setFrame:CGRectMake(0.0f, 0.f, self.bounds.size.width, _lineWidth)];
        [_cacheLayer setFillColor:[UIColor lightGrayColor].CGColor];
        [self.layer addSublayer:_cacheLayer];
        
        _progressLayer = [CAShapeLayer layer];
        [_progressLayer setFrame:CGRectMake(0.0f, 0.f, self.bounds.size.width, _lineWidth)];
        [_progressLayer setFillColor:[UIColor orangeColor].CGColor];
        [self.layer addSublayer:_progressLayer];
        
        _pointLayer = [CALayer layer];
        [_pointLayer setFrame:CGRectMake(0.0f, 0.0f, _pointSize, _pointSize)];
        [_pointLayer setBackgroundColor:[UIColor whiteColor].CGColor];
        [_pointLayer setMasksToBounds:YES];
        [_pointLayer setBorderWidth:1.0f];
        [_pointLayer setBorderColor:[UIColor orangeColor].CGColor];
        [_pointLayer setCornerRadius:_pointSize/2.0f];
        [self.layer addSublayer:_pointLayer];
        
        [self setValue:0.0f];
        
    }
    return self;
}


-(void)setValue:(float)value
{
    _value = [self viableValue:value];
    
    [_pointLayer setFrame:CGRectMake((self.bounds.size.width-_pointSize)*_value, -0.5f*(_pointSize-_lineWidth), _pointSize, _pointSize)];
    [_pointLayer removeAllAnimations];
    UIBezierPath *blankPath = [UIBezierPath bezierPathWithRect:_blankLayer.bounds];
    [_blankLayer setPath:blankPath.CGPath];
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, 0.5f*_pointSize+(self.bounds.size.width-_pointSize)*_value, _lineWidth)];
    [_progressLayer setPath:progressPath.CGPath];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_blankLayer setFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _lineWidth)];
    [_cacheLayer setFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, _lineWidth)];
    [_progressLayer setFrame:CGRectMake(0.0f, 0.f, self.bounds.size.width, _lineWidth)];
    [self setValue:_value];
    [self showCacheRanges];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _onControl = YES;
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat x = point.x;
    CGFloat cx = (_pointLayer.frame.origin.x+0.5f*_pointLayer.frame.size.width);
    if ((cx>=x&&(cx-x)<=20.0f)||(x>=cx&&(x-cx)<=20.0f))
    {
        _canDone = YES;
        _startX = x;
        _startValue = _value;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    _onControl = YES;
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat x = point.x;
    if (_canDone)
    {
        float newValue = _startValue + (x - _startX)/(self.bounds.size.width-_pointSize);
        [self setValue:newValue];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    _onControl = NO;
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat x = point.x;
    float newValue = _startValue + (x - _startX)/(self.bounds.size.width-_pointSize);
    [self setValue:newValue];
    _canDone = NO;
    if (self.changeBlock != NULL)
    {
        self.changeBlock(_value);
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    _onControl = NO;
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat x = point.x;
    float newValue = _startValue + (x - _startX)/(self.bounds.size.width-_pointSize);
    [self setValue:newValue];
    _canDone = NO;
    if (self.changeBlock != NULL)
    {
        self.changeBlock(_value);
    }
}
-(float)viableValue:(float)value
{
    if (value > 1.0f)
    {
        return 1.0f;
    }
    else if (value < 0.0f)
    {
        return 0.0f;
    }
    else
    {
        return value;
    }
}

-(void)setRanges:(NSArray<__kindof CacheRange *> *)ranges
{
    _ranges = ranges;
    [self showCacheRanges];
}

-(void)showCacheRanges
{
    
    UIBezierPath *rangePath = [UIBezierPath bezierPath];
    for (CacheRange *range in _ranges)
    {
        CGFloat startX = range.startLocation*_cacheLayer.bounds.size.width;
        CGFloat lineWidth = range.cacheLength*_cacheLayer.bounds.size.width;
        [rangePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(startX, 0.0f, lineWidth, _cacheLayer.bounds.size.height)]];
    }
    
    [_cacheLayer setPath:rangePath.CGPath];
}

@end
