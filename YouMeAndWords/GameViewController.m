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

@interface GameViewController ()

@property (strong, nonatomic) IBOutlet UILabel *gameTimerLabel;
@property (strong, nonatomic) NSArray *alphabets;
@property (nonatomic, copy) NSMutableString *currentWord;
@property (nonatomic, strong) IBOutlet UILabel *currentWordLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;

@end

@implementation GameViewController
{
    NSArray *alphabetViews;
    //double gameTime;
    CFTimeInterval gameTime;
    NSTimer *stopWatchTimer;
    NSMutableArray *selectedAlphabetViews;
    int score;
    NSMutableArray *tempStorageForWordsCreated;
}

@synthesize game;
@synthesize gameTimerLabel;
@synthesize alphabets;
@synthesize currentWord;
@synthesize currentWordLabel;
@synthesize scoreLabel;


- (NSMutableString *)currentWord
{
    if (!currentWord) {
        currentWord = [[NSMutableString alloc] init];
    }
    return currentWord;
}

- (NSArray *)alphabets
{
    return [game objectForKey:GAME_LETTERS_KEY];
}

- (NSArray *)validWords
{
    return [game objectForKey:GAME_WORDS_KEY];
}

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
                                          initWithFrame:CGRectMake(x_origin, y_origin, ALPHABET_WIDTH, ALPHABET_HEIGHT)];
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

- (void)updateTimerLabel
{
    int minutes = gameTime / 60;
    int seconds = gameTime - (minutes * 60);
    NSString *gameTimeString = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    self.gameTimerLabel.text = gameTimeString;
    gameTime -= 1;
    
    if (gameTime < 0) {
        [stopWatchTimer invalidate];
    }
}


- (void)startNewGame
{
    int i = 0;
    for (AlphabetView *view in [self alphabetViews]) {
        [view setAlphabet:[self.alphabets objectAtIndex:i]];
        [view setScore:@"1"];
        i++;
    }
    tempStorageForWordsCreated = [[NSMutableArray alloc] init];
    score = 0;
    gameTime = 89;
    self.gameTimerLabel.text = @"01:30";
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self 
                                                    selector:@selector(updateTimerLabel) 
                                                    userInfo:nil repeats:YES];
}

- (void)loadView
{
    [super loadView];
    for (AlphabetView *view in [self alphabetViews]) {
        [self.view addSubview:view];
    }
}

- (void)alphabetView:(AlphabetView *)view gotClickedWithbutton:(UIButton *)button andAlphabet:(NSString *)alphabet;
{
    [[self currentWord] appendString:alphabet];
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
    if ([self currentWord]) {
        if ([[self validWords] containsObject:[self currentWord]] && 
            !([tempStorageForWordsCreated containsObject:self.currentWord])) {
            
            [tempStorageForWordsCreated addObject:self.currentWord];
            
            //Have to calculate score and update player score...
            score += self.currentWord.length;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
        }
        self.currentWord = nil;
        self.currentWordLabel.text = @"";
        [self resetAlphabetViews];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startNewGame];
}

- (void)viewDidUnload
{
    [self setGameTimerLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
