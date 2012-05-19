//
//  AlphabetScores.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlphabetScores.h"

@implementation AlphabetScores

static AlphabetScores *sharedInstance = nil;

@synthesize scores = _scores;


// Get the shared instance and create it if necessary.
+ (AlphabetScores *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[super allocWithZone:NULL] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary *)scores {
    if (!_scores) {
        _scores = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"1",@"A",
                   @"3",@"B",
                   @"3",@"C",
                   @"2",@"D",
                   @"1",@"E",
                   @"4",@"F",
                   @"2",@"G",
                   @"4",@"H",
                   @"1",@"I",
                   @"8",@"J",
                   @"5",@"K",
                   @"1",@"L",
                   @"3",@"M",
                   @"1",@"N",
                   @"1",@"O",
                   @"3",@"P",
                   @"10",@"Q",
                   @"1",@"R",
                   @"1",@"S",
                   @"1",@"T",
                   @"1",@"U",
                   @"4",@"V",
                   @"4",@"W",
                   @"8",@"X",
                   @"4",@"Y",
                   @"10",@"Z",nil];
    }
    return _scores;
}


@end
