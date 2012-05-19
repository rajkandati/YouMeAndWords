//
//  Game.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * gameLetters;
@property (nonatomic, retain) NSString * gameMeanings;
@property (nonatomic, retain) NSNumber * gameNumber;
@property (nonatomic, retain) NSString * gameWords;
@property (nonatomic, retain) NSString * wordsPlayerCreated;
@property (nonatomic, retain) NSNumber * numberOfWordsPlayerCreated;

+ (NSArray *)alphabetsForGame:(Game *)game;
+ (NSArray *)getGameWordsArray:(Game *)game;
+ (NSMutableDictionary *)getGameMeaningsDictionary:(Game *)game;
+ (NSArray *)wordsForBookmarking:(Game *)game;
+ (NSArray *)validWordsForGame:(Game *)game;

//Method to save game objects to DB.
+ (Game *)gameWithData:(NSDictionary *)gameData 
inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

//Method to retrieve games with given game number.
+ (Game *)gameWithGameNumber:(int)gameNumber 
inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;


@end
