//
//  ViewController.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"

#import "LiveVC.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)currentLiveBtn:(UIButton *)sender {
    LiveVC *liveVC = [[LiveVC alloc] init];
    liveVC.videoID = @"20170222001";
//    [self presentViewController:liveVC animated:YES completion:nil];
    [self.navigationController pushViewController:liveVC animated:YES];
}


@end
