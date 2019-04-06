//
//  AVGameGraph.m
//  Avenue
//
//  Created by Zach Kagin on 2/12/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGameGraph.h"
#import <UIKit/UIKit.h>

@implementation AVGameGraph

+ (NSArray<AVGraphNode *> *)calculateShortestPathForGrid:(NSArray<NSArray<NSNumber *> *> *)grid
{
    
    // Initialization
    NSMutableArray<NSMutableArray<AVGraphNode *> *> *nodes = [NSMutableArray new];
    NSMutableArray<AVGraphNode *> *unvisitedNodes = [NSMutableArray new];
    for (NSUInteger row = 0; row < grid.count; row++) {
        nodes[row] = [NSMutableArray new];
        for (NSUInteger column = 0; column < grid.count; column++) {
            NSUInteger value = grid[row][column].unsignedIntegerValue;
            AVGraphNode *node = [[AVGraphNode alloc] initWithRow:row column:column value:value];
            [nodes[row] addObject:node];
            [unvisitedNodes addObject:node];
        }
    }
    
    AVGraphNode *currentNode = nodes[0][0];
    currentNode.distanceToNode = 0;
    
    // Continue going through nodes until the exit node is reached.
    while (currentNode != nodes.lastObject.lastObject) {
        // Go through all of the current node's unvisited edges and update their distances.
        for (AVGraphNode *newNode in [self av_getAdjacentNodesForNode:currentNode allNodes:nodes]) {
            if ([unvisitedNodes containsObject:newNode]) {
                NSUInteger currentDistance = newNode.distanceToNode;
                NSUInteger newDistance = currentNode.distanceToNode + newNode.value;
                if (newDistance < currentDistance) {
                    newNode.distanceToNode = newDistance;
                    newNode.previousNode = currentNode;
                }
            }
        }
        [unvisitedNodes removeObject:currentNode];
        
        // Get the next node, which is the one with the minimum distance to it.
        NSUInteger minimumNextDistance =  NSUIntegerMax;
        AVGraphNode *nextNode = nil;
        for (AVGraphNode *node in unvisitedNodes) {
            if (node.distanceToNode < minimumNextDistance) {
                minimumNextDistance = node.distanceToNode;
                nextNode = node;
            }
        }
        currentNode = nextNode;
    }
    
    NSMutableArray<AVGraphNode *> *shortestPath = [NSMutableArray new];
    while (currentNode != nil) {
        [shortestPath addObject:currentNode];
        currentNode = currentNode.previousNode;
    }
    
    return shortestPath;
}

+ (NSArray<NSIndexPath *> *)calculateShortestPathWithIndexPathsForGrid:(NSArray<NSArray<NSNumber *> *> *)grid
{
    NSMutableArray<NSIndexPath *> *shortestPath = [NSMutableArray new];
    for (AVGraphNode *node in [self calculateShortestPathForGrid:grid]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:node.row inSection:node.column];
        [shortestPath addObject:indexPath];
    }
    return shortestPath;
}

#pragma mark - Private Methods

+ (NSArray<AVGraphNode *> *)av_getAdjacentNodesForNode:(AVGraphNode *)node
                                              allNodes:(NSArray<NSArray<AVGraphNode *> *> *)nodes
{
    NSMutableArray<AVGraphNode *> *adjacentNodes = [NSMutableArray new];
    NSUInteger row = node.row;
    NSUInteger column = node.column;
    
    // Edge to the left.
    if (node.column != 0) {
        [adjacentNodes addObject:nodes[row][column-1]];
    }
    // Edge to the top.
    if (row != 0) {
        [adjacentNodes addObject:nodes[row-1][column]];
    }
    // Edge to the right.
    if (column != nodes.count - 1) {
        [adjacentNodes addObject:nodes[row][column+1]];
    }
    // Edge to the bottom.
    if (row != nodes.count - 1) {
        [adjacentNodes addObject:nodes[row+1][column]];
    }
    return [adjacentNodes copy];
}

@end
