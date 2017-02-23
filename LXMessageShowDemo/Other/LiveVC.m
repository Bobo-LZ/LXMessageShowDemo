//
//  LiveVC.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/22.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "LiveVC.h"
#import "Base.h"
#import "AutoScrollViewController.h"
#import "IMessage.h"
#import "XWMessageSqliteTool.h"

@interface LiveVC ()

@end

@implementation LiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self testSaveIMsToDB];
    
    AutoScrollViewController *autoShowVC = [AutoScrollViewController initWithVideoID:self.videoID frame:CGRectMake(8, kScreenHeight - 200 - 30, 250, 210)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addChildViewController:autoShowVC];
    [self.view addSubview:autoShowVC.view];
}

-(void)testSaveIMsToDB{
    NSMutableArray *IMs = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        IMessage *message = [IMessage initWith:[NSString stringWithFormat:@"IMID_%zd",i] UID:[NSString stringWithFormat:@"UID_%zd",i] content:[NSString stringWithFormat:@"content_%zd",i] type:[NSString stringWithFormat:@"type_%zd",i]];
        message.giftURL = [NSString stringWithFormat:@"giftURL_%zd",i];
        message.IMDate = i + arc4random_uniform(5);// [NSString stringWithFormat:@"%zd",i + arc4random_uniform(5)];
        message.userName = [NSString stringWithFormat:@"userName_%zd",i];
        message.tidewayEmoji = [NSString stringWithFormat:@"tidewayEmoji_%zd",i];
        [IMs addObject:message];
    }
    
    BOOL result = [XWMessageSqliteTool saveOrUpdateIMs:IMs videoID:self.videoID];
    NSLog(@"%zd",result);
}


@end
