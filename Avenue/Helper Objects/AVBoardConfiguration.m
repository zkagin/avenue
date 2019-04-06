//
//  AVBoardConfiguration.m
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2019 Zach Kagin. All rights reserved.
//

#import "AVBoardConfiguration.h"

static const NSUInteger kConceptChangeIncrement = 7;

@implementation AVBoardConfiguration

+ (NSUInteger)boardSizeForLevel:(NSUInteger)level
{
    return 1 + MIN(level, kConceptChangeIncrement);
}

+ (NSUInteger)boardUpperRangeForLevel:(NSUInteger)level
{
    if (level <= kConceptChangeIncrement) {
        return 5;
    } else if (level <= 2*kConceptChangeIncrement) {
        return 5 + 5 * (level - kConceptChangeIncrement);
    } else {
        return 40;
    }
}

+ (CGFloat)boardColorScaleForLevel:(NSUInteger)level
{
    if (level <= 2*kConceptChangeIncrement) {
        return 1.0f;
    } else if (level <= 3*kConceptChangeIncrement) {
        return 1.0f * (3*kConceptChangeIncrement - level) / kConceptChangeIncrement;
    } else if (level <= 28) {
        return 1.0f - (4.0f*kConceptChangeIncrement - level) / kConceptChangeIncrement;
    } else {
        return 1.0f;
    }
}

+ (BOOL)boardRandomColorsForLevel:(NSUInteger)level
{
    if (level <= 3*kConceptChangeIncrement) {
        return NO;
    } else {
        return YES;
    }
}


@end
