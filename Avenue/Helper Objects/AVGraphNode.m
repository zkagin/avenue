//
//  AVGraphNode.m
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVGraphNode.h"

@implementation AVGraphNode

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column value:(NSUInteger)value
{
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
        _value = value;
        _distanceToNode = NSUIntegerMax;
        _previousNode = nil;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"AVGraphNode: Row: %ld, Column: %ld, Value: %ld, DistanceToNode: %ld", _row,
                                      _column, _value, _distanceToNode];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[AVGraphNode class]]) {
        return NO;
    }

    AVGraphNode *newObj = (AVGraphNode *)object;
    BOOL isSame = newObj.row == self.row && newObj.column == self.column && newObj.value == self.value &&
                  newObj.distanceToNode == self.distanceToNode && newObj.previousNode == self.previousNode;

    return isSame;
}

@end
