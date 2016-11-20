//
//  Pactera_test_MTTests.m
//  Pactera_test_MTTests
//
//  Created by Mitesh Trivedi on 20/11/2016.
//  Copyright (c) 2016 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface Pactera_test_MTTests : XCTestCase

@end

@implementation Pactera_test_MTTests

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
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
