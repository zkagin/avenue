//
//  AVBoardConfiguration.h
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2019 Zach Kagin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Helper methods for generating board configurations. See AVGameBoardView for explanations. */
@interface AVBoardConfiguration : NSObject

+ (NSUInteger)boardSizeForLevel:(NSUInteger)level;
+ (NSUInteger)boardUpperRangeForLevel:(NSUInteger)level;
+ (CGFloat)boardColorScaleForLevel:(NSUInteger)level;
+ (BOOL)boardRandomColorsForLevel:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
