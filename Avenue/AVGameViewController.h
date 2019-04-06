//
//  AVGameViewController.h
//  Avenue
//
//  Created by Zach Kagin on 2/9/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVGameViewController : UIViewController

/**
 * Creates a game view controller with a grid.
 *
 * @param level The level to start the game at.
 */
- (instancetype)initWithInitialLevel:(NSUInteger)level;

@end
