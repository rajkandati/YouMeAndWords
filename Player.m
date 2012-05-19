//
//  Player.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Bookmark.h"


@implementation Player

@dynamic lastGamePlayed;
@dynamic totalNumberOfWordsCreated;
@dynamic numberOfSixPlusLetterWordsCreated;
@dynamic totalScore;



@synthesize bookmarkWords = _bookmarkWords;
@synthesize bookmarkWordMeanings = _bookmarkWordMeanings;
@synthesize startGameData = _startGameData;


- (NSMutableArray *)bookmarkWords
{
    if (!_bookmarkWords) {
        _bookmarkWords = [[NSMutableArray alloc] init];
    }
    return _bookmarkWords;
}

- (NSArray *)startGameData
{
    if (!_startGameData) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StartOffGameData" ofType:@"plist"];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        _startGameData = (NSArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&errorDesc];
    }
    return _startGameData;
}

- (NSMutableDictionary *)bookmarkWordMeanings
{
    if (!_bookmarkWordMeanings) {
        _bookmarkWordMeanings = [[NSMutableDictionary alloc] init];
    }
    return _bookmarkWordMeanings;
}

- (void)addToBookmarks:(NSString*)word andMeaning:(NSString *)meaning inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    [Bookmark bookmarkWithWord:word andMeaning:meaning inManagedObjectContext:managedObjectContext];
}

- (Game*)getLastGameFromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    return [Game gameWithGameNumber:[self.lastGamePlayed intValue] inManagedObjectContext:managedObjectContext];
}


- (Game*)getCurrentGameFromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    return [Game gameWithGameNumber:[self.lastGamePlayed intValue] + 1 inManagedObjectContext:managedObjectContext];
}

+ (Player *)playerInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Player *player = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    
    NSError *error = nil;
    player = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (!error && !player) {
        player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:managedObjectContext];
        player.lastGamePlayed                    = 0;
        player.totalNumberOfWordsCreated         = 0;
        player.numberOfSixPlusLetterWordsCreated = 0;
        player.totalScore                        = 0;
    }
    return player;
}

+ (void)savePlayer:(Player *)player inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Player *plyr = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    
    NSError *error = nil;
    plyr = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (!error) {
        plyr.lastGamePlayed = player.lastGamePlayed;
        plyr.totalScore = player.totalScore;
        plyr.numberOfSixPlusLetterWordsCreated = player.numberOfSixPlusLetterWordsCreated;
        plyr.totalNumberOfWordsCreated = player.totalNumberOfWordsCreated;
    }
    [managedObjectContext save:&error];
}




@end
