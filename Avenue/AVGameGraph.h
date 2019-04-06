//
//  AVGameGraph.h
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVGraphNode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The graph object for finding the shortest path when given a grid.
 */
@interface AVGameGraph : NSObject

/** Returns an array of nodes with the shortest path for the provided grid, with the end first. */
+ (NSArray<AVGraphNode *> *)calculateShortestPathForGrid:(NSArray<NSArray<NSNumber *> *> *)grid;

/** Returns an array of index paths with the shortest path for the provided grid, with the end first. */
+ (NSArray<NSIndexPath *> *)calculateShortestPathWithIndexPathsForGrid:(NSArray<NSArray<NSNumber *> *> *)grid;

@end

NS_ASSUME_NONNULL_END
