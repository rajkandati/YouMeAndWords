//
//  Game.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"


@implementation Game

@dynamic gameLetters;
@dynamic gameMeanings;
@dynamic gameNumber;
@dynamic gameWords;
@dynamic wordsPlayerCreated;
@dynamic numberOfWordsPlayerCreated;


+ (NSArray *)alphabetsForGame:(Game *)game
{
    NSMutableArray *alphabets = nil;
    NSString *letters = game.gameLetters;
    alphabets = [[NSMutableArray alloc] initWithCapacity:[letters length]];
    for (int i=0; i < [letters length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]];
        [alphabets addObject:ichar];
    }
    return alphabets;
}

+ (NSArray *)getGameWordsArray:(Game *)game
{
    NSArray *wordsArray = [game.gameWords componentsSeparatedByString:@";"];
    return wordsArray;
}

+ (NSMutableDictionary *)getGameMeaningsDictionary:(Game *)game
{
    NSMutableDictionary *wordsAndMeanings = [[NSMutableDictionary alloc] init];
    
    NSArray *wordMeaningsArray = [game.gameMeanings componentsSeparatedByString:@"\n"];
    
    //The words and meanings are separated by '#' in each line.  The following code
    //seperates a word and the respective meaning and puts them in a dictionary.
    
    NSString *wordMeaningSeperator = @"#";
    for (int i =0; i < wordMeaningsArray.count; i++) {
        NSString *currentwrdMng = [wordMeaningsArray objectAtIndex:i];
        NSRange range = [currentwrdMng rangeOfString:wordMeaningSeperator options:NSLiteralSearch];
        NSString *word = [currentwrdMng substringToIndex:range.location];
        NSString *meaning = [currentwrdMng substringFromIndex:range.location + 1];
        [wordsAndMeanings setObject:meaning forKey:word];
    }
    return wordsAndMeanings;
}

+ (NSArray *)wordsForBookmarking:(Game *)game
{
    NSMutableArray *wordsForBookmark; 
    if (game.wordsPlayerCreated.length > 0) {
        wordsForBookmark = [NSMutableArray arrayWithArray:[game.wordsPlayerCreated 
                                                           componentsSeparatedByString:@";"]];
    } else {
        wordsForBookmark = [[NSMutableArray alloc] init];
    }
    
    NSArray *wordsArray = [game.gameWords componentsSeparatedByString:@";"];
    for (int i = 0; i < wordsArray.count; i++) {
        NSString *word = [wordsArray objectAtIndex:i];
        if (![wordsForBookmark containsObject:word]) {
            [wordsForBookmark addObject:word];
        }
    }
    
    return wordsForBookmark;
}

+ (NSArray *)validWordsForGame:(Game *)game
{
    return [game.gameWords componentsSeparatedByString:@";"];
}


+ (Game *)gameWithData:(NSDictionary *)gameData 
inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Game *game = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
    request.predicate       = [NSPredicate predicateWithFormat:@"gameNumber = %@", [gameData objectForKey:@"gameNumber"]];
    
    NSError *error = nil;
    game = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (!error && !game) {
        game                   = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:managedObjectContext];
        game.gameNumber         = [gameData objectForKey:@"gameNumber"];
        game.gameLetters        = [gameData objectForKey:@"gameLetters"];
        game.gameWords          = [gameData objectForKey:@"gameWords"];
        game.gameMeanings       = [gameData objectForKey:@"gameMeanings"];
    }
    [managedObjectContext save:&error];
    return game;
}


+ (Game *)gameWithGameNumber:(int)gameNumber 
      inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Game *game = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
    request.predicate       = [NSPredicate predicateWithFormat:@"gameNumber = %@", [NSNumber numberWithInt:gameNumber]];
    
    NSError *error = nil;
    game = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (!error && game) {
        return game;
    }
    return nil;
}

@end
