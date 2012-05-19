//
//  Bookmark.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bookmark.h"


@implementation Bookmark

@dynamic word;
@dynamic meaning;



+ (Bookmark *)bookmarkWithWord:(NSString *)word andMeaning:(NSString *)meaning inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Bookmark *bookmark = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:managedObjectContext];
    request.predicate       = [NSPredicate predicateWithFormat:@"word = %@", word];
    
    NSError *error = nil;
    bookmark = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
    if (!error && !bookmark) {
        bookmark                   = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmark" inManagedObjectContext:managedObjectContext];
        bookmark.word           = word;
        bookmark.meaning        = [meaning stringByReplacingOccurrencesOfString:@"#" withString:@"\\n"];
    }
    [managedObjectContext save:&error];
    return bookmark;
}


+ (NSArray *)wordsBookmarkedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity          = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:managedObjectContext];
    NSError *error = nil;
    NSArray *wordsBookmarked = [managedObjectContext executeFetchRequest:request error:&error];
    return wordsBookmarked;
}


@end
