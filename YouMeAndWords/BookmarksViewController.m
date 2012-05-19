//
//  BookmarksViewController.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"

@interface BookmarksViewController ()

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UITextView *meaningTextView;
@property(nonatomic, strong) IBOutlet UILabel *emptyBookmarksLabel;
@property(nonatomic, strong) IBOutlet UIImageView *verticalDividerImageView;
@property(nonatomic, strong) NSMutableArray *bookmarks;
- (IBAction)backButtonTapped;

@end

@implementation BookmarksViewController

@synthesize delegate;
@synthesize player;
@synthesize meaningTextView = _meaningTextView;
@synthesize tableView = _tableView;
@synthesize emptyBookmarksLabel = _emptyBookmarksLabel;
@synthesize bookmarks = _bookmarks;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize verticalDividerImageView = _verticalDividerImageView;


- (IBAction)backButtonTapped
{
    [self.delegate bookmarksViewController:self didTapbackButton:nil];
}

- (NSMutableArray *)bookmarks
{
    if (!_bookmarks) {
        _bookmarks = [[NSMutableArray alloc] init];
    }
    return _bookmarks;
}

# pragma UITableView delegate and datasource methods.

- (void)accessoryButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookmarkCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];    
    
    UILabel *bulletLabel = (UILabel *)[cell viewWithTag:1000];
    bulletLabel.font = [UIFont systemFontOfSize:30];
    bulletLabel.textColor = [UIColor orangeColor];
    bulletLabel.text = @"\u2022";
    
    UILabel *wordLabel = (UILabel *)[cell viewWithTag:1001];
    wordLabel.font = [UIFont systemFontOfSize:14];
    wordLabel.text = bookmark.word;
    
    
    UIImage *image = [UIImage   imageNamed:@"detail-disclosure.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(22.0, 22.0, image.size.width/2, image.size.height/2);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookmarks.count;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    self.meaningTextView.text = [bookmark.meaning stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bookmarks = [NSMutableArray arrayWithArray:[Bookmark wordsBookmarkedInManagedObjectContext:self.managedObjectContext]];
    if (!self.bookmarks || self.bookmarks.count == 0) {
        self.tableView.hidden = YES;
        self.meaningTextView.hidden = YES;
        self.verticalDividerImageView.hidden = YES;
        self.verticalDividerImageView.hidden = YES;
    }
    else {
        self.emptyBookmarksLabel.hidden = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.meaningTextView setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
