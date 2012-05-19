//
//  GameOverViewController.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@class GameOverViewController;

@protocol GameOverViewControllerDelegate <NSObject>

- (void)gameOverViewController:(GameOverViewController *)controller didPickNewGameForPlayer:(Player *)player;
- (void)gameOverViewController:(GameOverViewController *)controller didPickHome:(Player *)player;

@end

@interface GameOverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) Player *player;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, weak) id<GameOverViewControllerDelegate> delegate;
@property(nonatomic, strong) NSMutableString *wordsPlayerCreatedInLastGame;
@property(nonatomic, assign) int numberOfWordsPlayerCreated;

- (IBAction)segmentControlClicked:(UISegmentedControl *)segmentedControl;

@end
