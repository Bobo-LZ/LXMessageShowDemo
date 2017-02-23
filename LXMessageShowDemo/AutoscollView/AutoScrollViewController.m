//
//  AutoScrollViewController.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/21.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "AutoScrollViewController.h"
#import "IMessageShowCell.h"
#import "IMessage.h"
#import "XWMessageSqliteTool.h"

#define kCellID @"kCellID"

@interface AutoScrollViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) int timerInt;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *datas;
@end
@implementation AutoScrollViewController
+ (instancetype)initWithVideoID:(NSString *)videoID frame:(CGRect)frame{
    AutoScrollViewController *autoScrollVC = [[AutoScrollViewController alloc] init];
    autoScrollVC.datas = [XWMessageSqliteTool getSortedIMessages:videoID];
    autoScrollVC.view.frame = CGRectMake(frame.origin.x, frame.origin.y - 64, frame.size.width, frame.size.height);
    return autoScrollVC;
}

-(instancetype)initWithVideoID:(NSString *)videoID frame:(CGRect)frame{
    if (self = [super init]) {
        self.datas = [XWMessageSqliteTool getSortedIMessages:videoID];
        self.view.frame = frame;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)loadView{
    [super loadView];
    NSLog(@"loadView");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor orangeColor];
     self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"IMessageShowCell" bundle:nil] forCellReuseIdentifier:kCellID];
    // 开启滚动
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timerInt = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollTheWinnerList:) userInfo:nil repeats:YES];
}
//滚动
- (void)scrollTheWinnerList:(NSTimer *)time
{
    if (self.datas.count == 0) {
        return;
    }
    self.timerInt ++;
    if (self.timerInt == self.datas.count) {
        self.timerInt = 0;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.timerInt inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.timerInt inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark 循环滚动
- (void)resetContentOffsetIfNeeded
{
    CGPoint contentOffset  = self.tableView.contentOffset;
    if  ( contentOffset.y <= 0.0) {
        contentOffset.y = 0;
        self.timerInt = 0;
    } else if ( contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height) ) {
        contentOffset.y = - self.tableView.bounds.size.height;
    }
    [self.tableView setContentOffset: contentOffset];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMessageShowCell *cell = (IMessageShowCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
    IMessage *message = [self.datas objectAtIndex:indexPath.row];
    cell.userNameLB.text = message.userName;
    cell.contentLB.text = [NSString stringWithFormat:@"消息时间戳 :%zd",message.IMDate];
//    if (message.IMDate % 9 == 0) {
//        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"超跑飞驰而过动画" preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:ac animated:YES completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [ac dismissViewControllerAnimated:YES completion:nil];
//        });
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}
@end
