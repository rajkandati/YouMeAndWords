//
//  GameViewController.m
//  YouMeAndWords_v1
//
//  Created by Raj Kandati on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "AlphabetView.h"
#import "YouMeAndWordsConstants.h"
#import "GameOverViewController.h"
#import "Game.h"
#import "AlphabetScores.h"

@interface GameViewController ()


//Label, that displays the game time left to the user.
@property (strong, nonatomic) IBOutlet UILabel *gameTimerLabel;


//A label that displays the letters as the users picks them.
@property (nonatomic, strong) IBOutlet UILabel *currentWordLabel;

// A label that displays the score of the user in the current game.
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;

//Array to save alphabets of the current game.
@property (strong, nonatomic) NSArray *alphabets;

//A mutable string that keeps track of the alphabets picked by user
//and is used to verify the validity of the word once user presses pop.
@property (nonatomic, copy) NSMutableString *currentWord;

//Variable that keeps track of the individual game time.
@property (nonatomic, assign) CFTimeInterval gameTime;

//Score for every word as the user creates the word.
@property (nonatomic, assign) int wordScore;

//Action invoked when pop button is pressed.
-(IBAction)wordCreated;


@end

@implementation GameViewController
{
    //Instance variable to save AlphabetViews, which hold the letters.
    NSArray *alphabetViews;
    
    //A variable that saves timer for the game.
    NSTimer *stopWatchTimer;
    
    //Array of selected alphabets(i.e views) to change colors.
    NSMutableArray *selectedAlphabetViews;
    
    //Score for individual game.
    int score;
    
    //variable that represents the number of words created for the current game.
    int numberOfWordsCreated;
    
    //variable that represents the number of six(/+) words created for the current game.
    int numberOfSixLetterWordsCreated;
    
    //A temporary array to keep track of words created in the current to avoid creation
    //of duplicate words.
    NSMutableArray *tempStorageForWordsCreated;
    
    //represents a string of words player created while playing the current game.
    //The words are appended to each other seperated by ';'
    NSMutableString *wordsPlayerCreated;
    
    //instance variable that caches current game;
    Game *currentGame;
}


@synthesize gameTimerLabel = _gameTimerLabel;
@synthesize currentWordLabel = _currentWordLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize alphabets = _alphabets;
@synthesize currentWord = _currentWord;
@synthesize player = _player;
@synthesize gameTime = _gameTime;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize wordScore = _wordScore;


//Initializes to empty object.
- (NSMutableString *)currentWord
{
    if (!_currentWord) {
        _currentWord = [[NSMutableString alloc] init];
    }
    return _currentWord;
}

//Initializes to empty object.
- (NSMutableString *)wordsPlayerCreated
{
    if (!wordsPlayerCreated) {
        wordsPlayerCreated = [[NSMutableString alloc] init];
    }
    return wordsPlayerCreated;
}

- (Game *)currentGame
{
    if (!currentGame) {
        currentGame = [self.player getCurrentGameFromManagedObjectContext:self.managedObjectContext];
    }
    return currentGame;
}


//Initializes to alphabets of the current game if empty.
- (NSArray *)alphabets
{
    if (!_alphabets) {
        _alphabets = [NSArray arrayWithArray:[Game alphabetsForGame:[self currentGame]]];
    }
    return _alphabets;
}

//Creates a 3 x 3 grid of alphabet views and assigns GameViewController as a delegate
//to each of the views.
- (NSArray *)setUpAplhabetViews
{
    int x_origin;
    int y_origin; 
    NSMutableArray *alphaViews = [[NSMutableArray alloc]init];
    
    x_origin = X_ORIGIN_OF_GRID;
    for (int i = 0; i < NUMBERS_OF_COLUMNS_IN_GRID; i++) {
        y_origin = Y_ORIGIN_OF_GRID;
        for (int j = 0; j < NUMBERS_OF_ROWS_IN_GRID; j++) {
            AlphabetView *alphabetView = [[AlphabetView alloc] 
                                          initWithFrame:CGRectMake(x_origin, y_origin, ALPHABET_WIDTH, ALPHABET_HEIGHT) forScreenSize:1];
            alphabetView.delegate = self;
            [alphaViews addObject:alphabetView];
            y_origin += ALPHABET_HEIGHT + BRODER_BETWEEN_CELLS_IN_GRID;
        }
        x_origin += ALPHABET_WIDTH + BRODER_BETWEEN_CELLS_IN_GRID;
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


- (void)updatePlayerOnGameFinish
{
    
    self.player.totalScore = [NSNumber numberWithInt:self.player.totalScore.intValue + score];
    self.player.totalNumberOfWordsCreated = [NSNumber numberWithInt:self.player.totalNumberOfWordsCreated.intValue + numberOfWordsCreated];
    self.player.numberOfSixPlusLetterWordsCreated = [NSNumber numberWithInt:self.player.numberOfSixPlusLetterWordsCreated.intValue + numberOfSixLetterWordsCreated];
    [self currentGame].wordsPlayerCreated = wordsPlayerCreated;
    //[self currentGame].numberOfWordsPlayerCreated = [NSNumber numberWithInt:numberOfWordsCreated];
    self.player.lastGamePlayed = [NSNumber numberWithInt:self.player.lastGamePlayed.intValue + 1];
    [Player savePlayer:self.player inManagedObjectContext:self.managedObjectContext];
}


//Scheduled to be invoked every second. Updates the timer label and Invokes
//GameOverController once the gametime reaches 0.
- (void)updateTimerLabel
{
    int minutes = self.gameTime / 60;
    int seconds = self.gameTime - (minutes * 60);
    NSString *gameTimeString = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    self.gameTimerLabel.text = gameTimeString;
    self.gameTime -= 1;
    
    if (self.gameTime < 0) {
        [stopWatchTimer invalidate];
        [self updatePlayerOnGameFinish];
        //Show the GameOver screen when the user runs out of time.
        //[self.delegate gameViewController:self didFinishGameForPlayer:self.player];
        //[self.presentingViewController dismissModalViewControllerAnimated:YES];
        //[self.delegate gameViewController:self didFinishGameForPlayer:self.player];
        [self performSegueWithIdentifier:@"GameOver" sender:self];
        
    }
}


//The Game and Game alphabets are re-set to empty values at the begining of every game.
- (void)resetGameVaues
{
    self.alphabets = nil;
    self.gameTime = 0;
    numberOfWordsCreated = 0;
    numberOfSixLetterWordsCreated = 0;
    score = 0;
    tempStorageForWordsCreated = [[NSMutableArray alloc] init];
    wordsPlayerCreated = nil;
    currentGame = nil;
    self.currentWord = nil;
    self.currentWordLabel.text=@"";
    [self resetAlphabetViews];
}



- (void)startNewGame
{
    [self resetGameVaues];
    
    int i = 0;
    for (AlphabetView *view in [self alphabetViews]) {
        [view setAlphabet:[self.alphabets objectAtIndex:i]];
        NSString *alphabetScore = [[[AlphabetScores sharedInstance] scores] 
                                   objectForKey:[self.alphabets objectAtIndex:i]];
        [view setScore:alphabetScore];
        i++;
    }
    
    self.gameTime = 90;
    self.gameTimerLabel.text = @"01:30";
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self 
                                                    selector:@selector(updateTimerLabel) 
                                                    userInfo:nil repeats:YES];
}


- (void)alphabetView:(AlphabetView *)view gotClickedWithbutton:(UIButton *)button andAlphabet:(NSString *)alphabet;
{
    [self.currentWord appendString:alphabet];
    self.wordScore += [[[[AlphabetScores sharedInstance] scores] objectForKey:alphabet] intValue] + pow(2, self.currentWord.length - 1);
    self.currentWordLabel.text = self.currentWord;
    
    if (!selectedAlphabetViews) selectedAlphabetViews = [[NSMutableArray alloc] init];
    [selectedAlphabetViews addObject:view];
}

- (void)resetAlphabetViews
{
    for (AlphabetView *av in selectedAlphabetViews) {
        [av resetAlphViewButtons];
    }
}

-(IBAction)wordCreated
{
    if (self.currentWord) {
        if ([[Game validWordsForGame:[self currentGame]] containsObject:self.currentWord] && 
            !([tempStorageForWordsCreated containsObject:self.currentWord])) {
            
            [tempStorageForWordsCreated addObject:self.currentWord];
            
            //Have to calculate score and update player score...
            score += self.wordScore;
            
            
            if (numberOfWordsCreated !=0 ) {
                [[self wordsPlayerCreated] appendString:@";"];
            }  
            [[self wordsPlayerCreated] appendString:self.currentWord];
            
            numberOfWordsCreated += 1;
            numberOfSixLetterWordsCreated += (self.currentWord.length >= 6)? 1: 0;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        }
        self.currentWord = nil;
        self.currentWordLabel.text = @"";
        self.wordScore = 0;
        [self resetAlphabetViews];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GameOver"]) {
        //Don't do anything for now...
        GameOverViewController *govc = (GameOverViewController*)segue.destinationViewController;
        govc.player = self.player;
        govc.managedObjectContext = self.managedObjectContext;
        govc.delegate = self;
        govc.wordsPlayerCreatedInLastGame = wordsPlayerCreated;
        govc.numberOfWordsPlayerCreated = numberOfWordsCreated;
    } 
}

#pragma GameOverViewControllerDelegate method

- (void)gameOverViewController:(GameOverViewController *)controller didPickNewGameForPlayer:(Player *)player
{
    [self dismissModalViewControllerAnimated:YES];
    [self.view setNeedsDisplay];
}


- (void)gameOverViewController:(GameOverViewController *)controller didPickHome:(Player *)player
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
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
    
    [self startNewGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.gameTimerLabel = nil;
    self.currentWordLabel = nil;
    self.scoreLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
