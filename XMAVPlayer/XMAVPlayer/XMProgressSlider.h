//
//  XMProgressSlider.h
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ValueChangedBlock)(float newValue);

@interface CacheRange : NSObject
@property(nonatomic,assign,readonly)float startLocation;
@property(nonatomic,assign,readonly)float cacheLength;
@property(nonatomic,assign,readonly)float endLocation;
-(instancetype)initWithStartLocation:(float)startLocation cacheLength:(float)cacheLength;
@end


@interface XMProgressSlider : UIView
//是否处于时间处理中
@property(nonatomic,assign,readonly)BOOL onControl;
//数值
@property(nonatomic,assign)float value;//0.0f-1.0f
//线宽
@property(nonatomic,assign)CGFloat lineWidth;
//圆点大小
@property(nonatomic,assign)CGFloat pointSize;
//值更新时执行
@property(nonatomic,copy)ValueChangedBlock changeBlock;
//缓存范围
@property(nonatomic,strong)NSArray<__kindof CacheRange*> *ranges;


@end
