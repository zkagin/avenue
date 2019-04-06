//
//  AVGlobalStateHelper.m
//  Avenue
//
//  Created by Zach Kagin on 5/18/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGlobalStateHelper.h"

NSString * const kUserDefaultMaxLevelKey = @"kUserDefaultMaxLevelKey";
NSString * const kUserDefaultMaxDifficultyKey = @"kUserDefaultMaxDifficultyKey";

@implementation AVGlobalStateHelper

+ (NSUInteger)maxLevel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger maxLevel = [userDefaults integerForKey:kUserDefaultMaxLevelKey];
    if (maxLevel == 0) {
        maxLevel = 1;
        [userDefaults setInteger:maxLevel forKey:kUserDefaultMaxLevelKey];
        [userDefaults synchronize];
    }
    return maxLevel;
}

+ (void)updateMaxLevel:(NSInteger)maxLevel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (maxLevel > [AVGlobalStateHelper maxLevel]) {
        [userDefaults setInteger:maxLevel forKey:kUserDefaultMaxLevelKey];
    }
    [userDefaults synchronize];
}

@end
