//
//  GameOverViewController.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverViewController.h"
#import "GameViewController.h"
#import "YouMeAndWordsConstants.h"
#import "AlphabetView.h"
#import "Game.h"

@interface GameOverViewController ()

@property (strong, nonatomic) NSArray *alphabets;
@property (nonatomic, strong) IBOutlet UITextView *meaningTextView;

//The following are all added to change the colors to clear
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControlForColorChange;
@property (nonatomic, weak) IBOutlet UINavigationBar *uiNavigationBarForColorChange;

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation GameOverViewController {
    NSArray *alphabetViews;
    int lastSelectedWord;
    Game *lastGame;
}

@synthesize player = _player;
@synthesize alphabets = _alphabets;
@synthesize meaningTextView = _meaningTextView;
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize segmentedControlForColorChange;
@synthesize uiNavigationBarForColorChange;
@synthesize wordsPlayerCreatedInLastGame = _wordsPlayerCreatedInLastGame;
@synthesize numberOfWordsPlayerCreated;
@synthesize tableView = _tableView;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (Game *)lastGame
{
    if (!lastGame) {
        lastGame = [self.player getLastGameFromManagedObjectContext:self.managedObjectContext];
    }
    return lastGame;
}

/*- (Game*)game
{
    if (!_game) {
        _game = [[_player games]objectForKey:[NSNumber numberWithInt: _player.lastGamePlayed]];
    }
    return _game;
}*/


- (NSArray *)alphabets
{
    if (!_alphabets) {
        NSMutableArray *characters = nil;
        NSString *letters = [[self lastGame] gameLetters];
        characters = [[NSMutableArray alloc] initWithCapacity:[letters length]];
        for (int i=0; i < [letters length]; i++) {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [letters characterAtIndex:i]];
            [characters addObject:ichar];
        }
        _alphabets = [NSArray arrayWithArray:characters];
    }
    return _alphabets;
}


- (NSArray *)setUpAplhabetViews
{
    int x_origin;
    int y_origin; 
    NSMutableArray *alphaViews = [[NSMutableArray alloc]init];
    
    x_origin = X_ORIGIN_OF_GRID_SMALL;
    for (int i = 0; i < NUMBERS_OF_COLUMNS_IN_GRID; i++) {
        y_origin = Y_ORIGIN_OF_GRID_SMALL;
        for (int j = 0; j < NUMBERS_OF_ROWS_IN_GRID; j++) {
            AlphabetView *alphabetView = [[AlphabetView alloc] 
                                          initWithFrame:CGRectMake(x_origin, y_origin, ALPHABET_WIDTH_SMALL, ALPHABET_HEIGHT_SMALL) forScreenSize:0];
            [alphaViews addObject:alphabetView];
            y_origin += ALPHABET_HEIGHT_SMALL + BRODER_BETWEEN_CELLS_IN_GRID_SMALL;
        }
        x_origin += ALPHABET_WIDTH_SMALL + BRODER_BETWEEN_CELLS_IN_GRID_SMALL;
    }
    return alphaViews;
}


- (NSArray *)alphabetViews
{
    if (!alphabetViews) {
        alphabetViews = [self setUpAplhabetViews];
    }
    return alphabetViews;
}

- (void)showGameBookmarks
{
    int i = 0;
    for (AlphabetView *view in [self alphabetViews]) {
        [view setAlphabet:[self.alphabets objectAtIndex:i]];
        [view setScore:@"1"];
        i++;
    }
}


- (IBAction)segmentControlClicked:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.delegate gameOverViewController:self didPickNewGameForPlayer:_player];
        lastGame = nil;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        NSString *word = [[Game wordsForBookmarking:[self lastGame]] objectAtIndex:lastSelectedWord];
        NSString *meaning = [[Game getGameMeaningsDictionary:[self lastGame]] objectForKey:word];
        [_player addToBookmarks:word andMeaning:meaning inManagedObjectContext:self.managedObjectContext];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        [self.delegate gameOverViewController:self didPickHome:_player];
        lastGame = nil;
    }
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
    static NSString *CellIdentifier = @"WordCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *word = [[Game wordsForBookmarking:[self lastGame]] objectAtIndex:indexPath.row];
    
    
    UILabel *bulletLabel = (UILabel *)[cell viewWithTag:1000];
    bulletLabel.font = [UIFont systemFontOfSize:30];

    bulletLabel.textColor = (indexPath.row < self.numberOfWordsPlayerCreated)? 
    [UIColor colorWithRed:(75/255.0) green:(139/255.0) blue:(0/255.0) alpha:1]:
    [UIColor colorWithRed:(168/255.0) green:(24/255.0) blue:(0/255.0) alpha:1];
    bulletLabel.text = @"\u2022";
    
    UILabel *wordLabel = (UILabel *)[cell viewWithTag:1001];
    wordLabel.font = [UIFont systemFontOfSize:14];
    wordLabel.text = word;
    
   /* UIButton *myAccessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [myAccessoryButton setBackgroundColor:[UIColor redColor]];
    [myAccessoryButton setImage:[UIImage imageNamed:@"my_red_accessory_image"] forState:UIControlStateNormal];
    [cell setAccessoryView:myAccessoryButton];*/
    
    UIImage *detailDisclosureImage = [UIImage   imageNamed:@"detail-disclosure.png"];
    UIImage *detailDisclosureHighlightImage = [UIImage   imageNamed:@"detail-disclosure-highlight.png"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(22.0, 22.0, detailDisclosureImage.size.width/2, detailDisclosureImage.size.height/2);
    button.frame = frame;
    [button setBackgroundImage:detailDisclosureImage forState:UIControlStateNormal];
    [button setBackgroundImage:detailDisclosureHighlightImage forState:UIControlStateHighlighted];
    
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
    return [Game getGameWordsArray:[self lastGame]].count;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    lastSelectedWord = indexPath.row;
    NSString *word = [[Game wordsForBookmarking:[self lastGame]] objectAtIndex:indexPath.row];
    if (word) {
        _meaningTextView.text = [[[Game getGameMeaningsDictionary:[self lastGame]] objectForKey:word] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
    }
    else {
        _meaningTextView.text = @"No definition available.";
    }
}

- (void)loadView
{
    [super loadView];
    for (AlphabetView *view in [self alphabetViews]) {
        [self.view addSubview:view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showGameBookmarks];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   /* NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathForImageFile = [resourcePath stringByAppendingPathComponent:@"btn-segment@2x.png"];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:pathForImageFile];
    UIImage *image = [[UIImage alloc] initWithData:imageData];*/
    UIImage *image = [UIImage imageNamed:@"btn-segment"];
    [self.segmentedControlForColorChange setBackgroundImage:image 
                                                   forState:UIControlStateNormal 
                                                 barMetrics:UIBarMetricsDefault];
    [self.uiNavigationBarForColorChange setBackgroundColor:[UIColor clearColor]];
    [self.uiNavigationBarForColorChange setTintColor:[UIColor clearColor]];
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
