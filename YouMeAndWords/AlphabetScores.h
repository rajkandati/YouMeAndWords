//
//  AlphabetScores.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlphabetScores : NSObject

+ (id)sharedInstance;
@property(nonatomic, retain) NSDictionary *scores;

@end
