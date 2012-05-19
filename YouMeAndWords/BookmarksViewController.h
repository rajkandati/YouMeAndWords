//
//  BookmarksViewController.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@class BookmarksViewController;

@protocol BookmarksViewControllerDelegate <NSObject>

- (void)bookmarksViewController:(BookmarksViewController*)controller didTapbackButton:(id)sender;

@end

@interface BookmarksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) id<BookmarksViewControllerDelegate> delegate;
@property(nonatomic, strong) Player *player;
@property(nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@end
