//
//  Player.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Game.h"


@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * lastGamePlayed;
@property (nonatomic, retain) NSNumber * totalNumberOfWordsCreated;
@property (nonatomic, retain) NSNumber * numberOfSixPlusLetterWordsCreated;
@property (nonatomic, retain) NSNumber * totalScore;


//property to save bookmarked words in ordered fashion.
@property(nonatomic, strong) NSMutableArray *bookmarkWords;

//property to save save meanings of bookmarked words.
@property(nonatomic, strong) NSMutableDictionary *bookmarkWordMeanings;

@property(nonatomic, strong) NSArray *startGameData;




+ (Player *)playerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)savePlayer:(Player *)player inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (Game*)getLastGameFromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
- (Game*)getCurrentGameFromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

//Method to add bookmarked words and meanings.
//- (void)addToBookmarks:(NSString*)word andMeaning:(NSString *)meaning;
- (void)addToBookmarks:(NSString*)word andMeaning:(NSString *)meaning inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;


@end
