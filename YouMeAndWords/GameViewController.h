//
//  GameViewController.h
//  YouMeAndWords_v1
//
//  Created by Raj Kandati on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlphabetView.h"

@interface GameViewController : UIViewController <AlphabetViewDelegate>

@property(nonatomic, strong) NSMutableDictionary *game;


-(IBAction)wordCreated;

@end
