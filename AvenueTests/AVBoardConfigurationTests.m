//
//  AVBoardConfigurationTests.m
//  AvenueTests
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AVBoardConfiguration.h"

@interface AVBoardConfigurationTests : XCTestCase
@end

@implementation AVBoardConfigurationTests

- (void)testLevels {
    NSUInteger testMatrixLevels[] =     {1, 3, 5, 8, 10, 15, 20, 24, 31, 41};
    NSUInteger testMatrixBoardSize[] =  {2, 4, 6, 8, 8,  8,  8,  8,  8,  8};
    NSUInteger testMatrixUpperRange[] = {5, 5, 5, 10, 20, 40, 40, 40, 40, 40};
    CGFloat testMatrixColorScale[] =    {1, 1, 1, 1, 1, 6.0f/7.0f, 1.0f/7.0f, 3.0f/7.0f, 1, 1};
    BOOL testMatrixRandomColors[] =     {NO, NO, NO, NO, NO, NO, NO, YES, YES, YES};
    
    for (NSUInteger i = 1; i < 10; i++) {
        NSUInteger level = testMatrixLevels[i];
        XCTAssertEqual([AVBoardConfiguration boardSizeForLevel:level], testMatrixBoardSize[i]);
        XCTAssertEqual([AVBoardConfiguration boardUpperRangeForLevel:level], testMatrixUpperRange[i]);
        XCTAssertEqualWithAccuracy([AVBoardConfiguration boardColorScaleForLevel:level], testMatrixColorScale[i], 0.01f);
        XCTAssertEqual([AVBoardConfiguration boardRandomColorsForLevel:level], testMatrixRandomColors[i]);
    }
}

@end
