//
//  AVGraphNode.h
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Object to represent the node of a graph.
 */
@interface AVGraphNode : NSObject

@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;
@property (nonatomic, readonly) NSUInteger value;
@property (nonatomic, readwrite) NSUInteger distanceToNode;
@property (nonatomic, readwrite) AVGraphNode *previousNode;

/**
 * Initializes a graph node.
 *
 * @param row   	The row in the grid.
 * @param column    The column in the grid.
 * @param value     The value of the cell, e.g. the cost to get to the node.
 */
- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column value:(NSUInteger)value;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
