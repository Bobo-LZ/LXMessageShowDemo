//
//  XWAFNManagerTests.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/23.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "XWAFNManager.h"

@interface XWAFNManagerTests : XCTestCase

@end

@implementation XWAFNManagerTests

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

#define url @"http://litchiapi.jstv.com/api/GetFeeds?column=0&PageSize=1000&pageIndex=1&val=100511D3BE5301280E0992C73A9DEC41"
#define kTestPostID @"kTestPostID"

-(void)testPOST{
//    [[XWAFNManager sharedManager] POST:url parameters:nil netIdentifier:kTestPostID progress:^(NSProgress *downloadProgress) {
//        NSLog(@"进度 - %@",downloadProgress);
//    } success:^(id responseObject) {
//         NSLog(@"responseObject = 下载成功");
//    } failure:^(NSError *error) {
//        if (error.code == -999) {
//            NSLog(@"请求取消");
//        }else{
//            NSLog(@"请求失败");
//        }
//    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
