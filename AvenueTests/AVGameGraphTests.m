//
//  AVGameGraphTests.m
//  AvenueTests
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AVGameGraph.h"
#import "AVGraphNode.h"

@interface AVGameGraphTests : XCTestCase
@end

@implementation AVGameGraphTests

- (void)testCorrectAnswerStepByStep
{
    NSArray<NSArray<NSNumber *> *> *grid =
    @[
      @[@(0), @(1), @(4)],
      @[@(4), @(1), @(4)],
      @[@(4), @(1), @(0)],
      ];
    NSArray<AVGraphNode *> *shortestPath = [AVGameGraph calculateShortestPathForGrid:grid];
    XCTAssertTrue(shortestPath.count == 5);
    XCTAssertTrue(shortestPath[0].row == 2 && shortestPath[0].column == 2);
    XCTAssertTrue(shortestPath[1].row == 2 && shortestPath[1].column == 1);
    XCTAssertTrue(shortestPath[2].row == 1 && shortestPath[2].column == 1);
    XCTAssertTrue(shortestPath[3].row == 0 && shortestPath[3].column == 1);
    XCTAssertTrue(shortestPath[4].row == 0 && shortestPath[4].column == 0);
}



- (void)testCorrectAnswerWinding
{
    NSArray<NSArray<NSNumber *> *> *grid =
    @[
      @[@(0), @(1), @(1), @(1), @(1), @(9)],
      @[@(9), @(9), @(9), @(9), @(1), @(9)],
      @[@(9), @(9), @(9), @(9), @(1), @(9)],
      @[@(9), @(9), @(1), @(1), @(1), @(9)],
      @[@(9), @(9), @(1), @(9), @(9), @(9)],
      @[@(9), @(9), @(1), @(1), @(1), @(0)],
      ];
    NSArray<AVGraphNode *> *shortestPath = [AVGameGraph calculateShortestPathForGrid:grid];
    XCTAssertTrue(shortestPath.count == 15);
}

@end
