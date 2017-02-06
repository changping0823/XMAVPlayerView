//
//  ViewController.m
//  XMAVPlayer
//
//  Created by 任长平 on 16/8/12.
//  Copyright © 2016年 任长平. All rights reserved.
//

#import "ViewController.h"

#import "XMAVPlayerView.h"

@interface ViewController ()

@property (nonatomic, strong) XMAVPlayerView *customerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.customerView = [[XMAVPlayerView alloc]initWithFrame:CGRectMake(0.0f, 80.0f, self.view.bounds.size.width, 240.0f) urlPath:@"http://static.test.dsb365.com/htdocs/app/video/zuocao.mov"];
    [self.view addSubview:self.customerView];
    [self.customerView.player play];
    

    [self.customerView.controlView setPlayButtonSelected:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






