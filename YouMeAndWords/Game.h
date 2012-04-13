//
//  Game.h
//  YouMeAndWords_v1
//
//  Created by Raj Kandati on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//A game object that saves all data required for a game. Will eventually become a managed object.

@interface Game : NSObject

@property(nonatomic, assign) int gameNumber;
@property(nonatomic, copy) NSString *gameLetters;
@property(nonatomic, copy) NSString *gameWords;
@property(nonatomic, copy) NSString *gameMeanings;

@end
