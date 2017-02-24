//
//  XWMessageSqliteToolTests.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XWMessageSqliteTool.h"
#import "IMessage.h"
@interface XWMessageSqliteToolTests : XCTestCase

@end

@implementation XWMessageSqliteToolTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testCreateIMDB{


}

/// 测试插入新数据
-(void)testInsertIMS{
    NSMutableArray *IMs = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        IMessage *message = [IMessage initWith:[NSString stringWithFormat:@"IMID_%zd",i] UID:[NSString stringWithFormat:@"UID_%zd",i] content:[NSString stringWithFormat:@"content_%zd",i] type:[NSString stringWithFormat:@"type_%zd",i]];
        message.giftURL = [NSString stringWithFormat:@"giftURL_%zd",i];
        message.IMDate = i + arc4random_uniform(5);// [NSString stringWithFormat:@"%zd",i + arc4random_uniform(5)];
        message.userName = [NSString stringWithFormat:@"userName_%zd",i];
        message.tidewayEmoji = [NSString stringWithFormat:@"tidewayEmoji_%zd",i];
        [IMs addObject:message];
    }
    
    BOOL result = [XWMessageSqliteTool saveOrUpdateIMs:IMs videoID:@"20170221002"];
    XCTAssertTrue(result);
}

/// 测试提取排序后的IMs
-(void)testSortedIMs{
    NSMutableArray *sortedIMs = [XWMessageSqliteTool getSortedIMessages:@"20170221002"];
    [sortedIMs enumerateObjectsUsingBlock:^(IMessage *im, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"IMDate : %zd",im.IMDate);
    }];
    
}

-(void)testInsertLivingIMs{
    NSMutableArray *IMs = [NSMutableArray array];
    for (int i = 0; i < 2000; i++) {
        IMessage *message = [IMessage initWith:[NSString stringWithFormat:@"IMID_%zd",i] UID:[NSString stringWithFormat:@"UID_%zd",i] content:[NSString stringWithFormat:@"content_%zd",i] type:[NSString stringWithFormat:@"type_%zd",i]];
        message.giftURL = [NSString stringWithFormat:@"giftURL_%zd",i];
        message.IMDate = i + arc4random_uniform(5);// [NSString stringWithFormat:@"%zd",i + arc4random_uniform(5)];
        message.userName = [NSString stringWithFormat:@"userName_%zd",i];
        message.tidewayEmoji = [NSString stringWithFormat:@"tidewayEmoji_%zd",i];
        [IMs addObject:message];
    }
    
    BOOL result = [XWMessageSqliteTool saveLivingIMs:IMs videoID:@"20170222002"];
    XCTAssertTrue(result);
}

-(void)testSaveLivingOneIM{
    for (int i = 2000; i < 2001; i++) {
        IMessage *message = [IMessage initWith:[NSString stringWithFormat:@"IMID_%zd",i] UID:[NSString stringWithFormat:@"UID_%zd",i] content:[NSString stringWithFormat:@"content_%zd",i] type:[NSString stringWithFormat:@"type_%zd",i]];
        message.giftURL = [NSString stringWithFormat:@"giftURL_%zd",i];
        message.IMDate = i + arc4random_uniform(5);// [NSString stringWithFormat:@"%zd",i + arc4random_uniform(5)];
        message.userName = [NSString stringWithFormat:@"userName_%zd",i];
        message.tidewayEmoji = [NSString stringWithFormat:@"tidewayEmoji_%zd",i];
        BOOL result = [XWMessageSqliteTool saveLivingOneIM:message videoID:@"20170222002"];
        XCTAssertTrue(result);
    }
}

-(void)testMessageDictInit{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = @"IMID_001";
    dict[@"UID"] = @"UID_001";
    dict[@"content"] = @"content_001";
    IMessage *testImessage = [IMessage initWithDict:dict];
    NSLog(@"testImessage.IMID : %@",testImessage.IMID);
    
}
 


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
