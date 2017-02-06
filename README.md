# XMAVPlayerView
一款边播变缓存到本地的视屏播放器。缓冲完成以后可以离线观看，节省流量。（可能会有一些格式的视频不支持。希望又遇到的可以告知）
    self.customerView = [[XMAVPlayerView alloc]initWithFrame:CGRectMake(0.0f, 80.0f, self.view.bounds.size.width, 240.0f) urlPath:@"http://static.test.dsb365.com/htdocs/app/video/zuocao.mov"];
    [self.view addSubview:self.customerView];
    [self.customerView.player play];

演示图如下

![image](https://github.com/changping0823/XMTabBar/blob/master/ScreenShots/Untitled.gif)
