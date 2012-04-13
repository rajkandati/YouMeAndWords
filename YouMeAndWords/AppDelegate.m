//
//  AppDelegate.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "YouMeAndWordsConstants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize homeViewController = _homeViewController;


- (NSString *)uuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}

- (Player *)createPlayer 
{
    /*Check if a player has an existing uuid saved and create either an
      empty player object or player object from user defaults */ 
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Player *player = [[Player alloc] initFromDefaults:defaults];
    
    return player;
}

/**
 * The following method is code that can be deleted at a later stage once all data
 * has been uploaded to the database. The method returns mutable dictionary with
 * game numbers as keys and game objects as values in the dictionary.
 **/
- (NSMutableDictionary *)getGamesForThePlayer
{

    //LetterDef contains the meanings of various words along with the source.
    
    NSString *letterDefPath = [[NSBundle mainBundle] pathForResource:@"LetterDef" ofType:@"txt"];
    NSError *letterDefReadError;
    
    //The whole file is read as a string.
    
    NSString *stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:letterDefPath
                                      encoding:NSUTF8StringEncoding
                                      error:&letterDefReadError];
    
    //The string separated based on line breaks.
    
    NSArray *arrayOfLines = [stringFromFileAtPath componentsSeparatedByString:@"\n"];
    
    //The words and meanings are separated by '#' in each line.  The following code
    //seperates a word and the respective meaning and puts them in a dictionary.
    
    NSString *searchStr = @"#";
    NSMutableDictionary *wordsAndMeanings = [[NSMutableDictionary alloc] init];
    for (int i =0; i < arrayOfLines.count; i++) {
        NSString *currentStr = [arrayOfLines objectAtIndex:i];
        NSRange range = [currentStr rangeOfString:searchStr options:NSLiteralSearch];
        NSString *word = [currentStr substringToIndex:range.location];
        NSString *meaning = [currentStr substringFromIndex:range.location + 1];
        [wordsAndMeanings setObject:meaning forKey:word];
    }
    
    //Letters file conmtains the individual game letters and the words, that can be
    //formed using the letters. Each game has a key, game letters and game words. The
    //key starts with '#' and is used to seperate each game.
    
    NSMutableDictionary *gamesForThePlayer = [[NSMutableDictionary alloc] init];
    
    NSString *lettersPath = [[NSBundle mainBundle] pathForResource:@"Letters" ofType:@"txt"];
    NSError *letterReadError;
    
    //The file is read in as a string.
    
    NSString *lettersStringFromFileAtPath = [[NSString alloc]
                                             initWithContentsOfFile:lettersPath
                                             encoding:NSUTF8StringEncoding
                                             error:&letterReadError];
    
    //The individual games are seperated using '#' as seperator and stored in an array.
    
    NSArray *arrayOfGames = [lettersStringFromFileAtPath componentsSeparatedByString:@"#"];
    
    //The letters aand words in a game are seperated by ';'.
    
    NSString *gameSeparatorStr = @";";
    
    for (int i =0; i < arrayOfGames.count; i++) {
        Game *game = [[Game alloc] init];
        NSString *gameStr = [arrayOfGames objectAtIndex:i];
        
        //Calculate the location of the id in the individual game and remove the ID from the game string.
        
        NSRange rangeForId = [gameStr rangeOfString:gameSeparatorStr options:NSLiteralSearch];
        NSString *gameWithoutId = [gameStr substringFromIndex:rangeForId.location+1];
        
        //Calculate the location of the letters in the individual game and seperate the letters from 
        //possible words list.
        
        NSRange rangeForLetters = [gameWithoutId rangeOfString:gameSeparatorStr options:NSLiteralSearch];
        NSString *letters = [gameWithoutId substringToIndex:rangeForLetters.location];
        NSString *possibleWords = [gameWithoutId substringFromIndex:rangeForLetters.location + 1];
        
        //Creating an array of possible words to use as iteration while determining the meaning
        //of each word.
        NSArray *possibleWordsArr = [possibleWords componentsSeparatedByString:@";"];
        
        
        //Creating a string of all the available meanings for the words of an individual game.
        //The format is to append word#meaning\nword#meaning\n...
        
        NSMutableString *meanings = [[NSMutableString alloc] init];
        for (int j = 0; j < possibleWordsArr.count; j++) {
            NSString *word = [possibleWordsArr objectAtIndex:j];
            NSString *meaning = [wordsAndMeanings objectForKey:word];
            [meanings appendString:word];
            [meanings appendString:@"#"];
            if (meaning) {
                [meanings appendString:meaning];
            } 
            if (j < possibleWordsArr.count - 1) {
                [meanings appendString:@"\n"];
            }
        }
        
        //Create a game object using the values from above and save in the mutable dictionary.
        
        [game setGameNumber:i+1];
        [game setGameLetters:letters];
        [game setGameWords:possibleWords];
        [game setGameMeanings:meanings];
        [gamesForThePlayer setObject:game forKey:[NSNumber numberWithInt:i+1]];
    }
    return gamesForThePlayer;
     
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //Create a player object from userdefaults
    
    Player *player = [self createPlayer];
    [player setGames:[self getGamesForThePlayer]];
    
    //Passing along managed object context & game player to the HomeViewController
    
    _homeViewController = (HomeViewController*) self.window.rootViewController;
    if (_homeViewController && [_homeViewController respondsToSelector:@selector(setManagedObjectContext:)] ) {
        _homeViewController.managedObjectContext = self.managedObjectContext;
        _homeViewController.player = player;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YouMeAndWords" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YouMeAndWords.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
