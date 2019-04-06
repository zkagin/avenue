//
//  AVGlobalStateHelper.h
//  Avenue
//
//  Created by Zach Kagin on 5/18/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A global helper to manage a persistent max level across the app.
 */
@interface AVGlobalStateHelper : NSObject

/** Returns the current max level. */
+ (NSUInteger)maxLevel;

/** Updates the max level only if it is larger than the current max level. */
+ (void)updateMaxLevel:(NSInteger)maxLevel;

@end

NS_ASSUME_NONNULL_END
