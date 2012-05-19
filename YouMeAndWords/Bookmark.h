//
//  Bookmark.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * meaning;


+ (Bookmark *)bookmarkWithWord:(NSString *)word andMeaning:(NSString *)meaning 
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)wordsBookmarkedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
