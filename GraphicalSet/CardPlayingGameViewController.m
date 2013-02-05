//
//  CardPlayingGameViewController.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/4/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardPlayingGameViewController.h"
#import "CardCollectionViewCell.h"

@interface CardPlayingGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel* scoreLabel;

@property (weak, nonatomic) IBOutlet UIView *lastFlipStatus;

@end

@implementation CardPlayingGameViewController

#pragma mark Lazy Instantiation

- (CardMatchingGame*)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck
                                                                                              ]];
        [_game setNumberOfCardsToMatch:self.numberOfCardsToMatch];
    }
    return _game;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)asker
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)asker numberOfItemsInSection:(NSInteger)section
{
    return [self.game cardCount];
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Method collectionView must implement collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath should be defined by a subclass");
    exit(1);
    return nil;
}

#pragma mark IBActions

- (IBAction)dealPressed {
    self.game = nil;
    [self.cardCollectionView reloadData];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",[self.game score]];
    for (UIView* view in self.lastFlipStatus.subviews) {
        [view removeFromSuperview];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    //Get index of card
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    NSIndexPath* indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    [self cardWasTappedAtIndexPath:indexPath];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",[self.game score]];
}

- (void)cardWasTappedAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        //Flip card
        [self.game flipCardAtIndex:indexPath.item];
        
        //Handle Flip on UI side
        [self handleLastFlip:[self.game resultsOfLastFlip]];
        
        Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
        if ([card isKindOfClass:[Card class]]) {
            Card* setCard = (Card*) card;
            CardCollectionViewCell* cell = (CardCollectionViewCell*) [self.cardCollectionView cellForItemAtIndexPath:indexPath];
            cell.cardView.faceUp = setCard.isFaceUp;
        }
    
    }
    [self.cardCollectionView reloadData];
}

#pragma mark Virtual Methods

- (NSUInteger)startingCardCount
{
    NSLog(@"The startingCardCount property should be defined by a sublass!");
    exit(1);
    return 0;
}

- (Deck*) createDeck
{
    NSLog(@"Method createDeck should be defined by a subclass!");
    exit(1);
    return nil;
}

- (NSUInteger)numberOfCardsToMatch
{
    NSLog(@"Method numberOfCardsToMatch should be defined by a subclass!");
    exit(1);
    return 0;
}

- (CardView*) createCardView
{
    NSLog(@"Method createCardView should be defined by a subclass!");
    exit(1);
    return nil;
}

- (void)populateView:(CardView *)cardView withCard:(Card *)card
{
    NSLog(@"Method populateView:(CardView *)cardView withCard:(Card *)card should be defined by a subclass!");
    exit(1);
}

- (void)handleLastFlip:(NSArray*)resultsOfLastFlip
{
    BOOL cardsRemoved = NO;
    for (int i =0; i < [resultsOfLastFlip count]; i++) {
        if ([resultsOfLastFlip[i] isKindOfClass:[Card class]]) {
            Card* card = (Card*) resultsOfLastFlip[i];
            if (card.isUnplayable) {
                cardsRemoved= YES;
                [self.game removeCard:card];
            }
        }
    }
    
    if ([resultsOfLastFlip count] == self.numberOfCardsToMatch+1) {
        [self handleMatchWithResults:(NSArray*)resultsOfLastFlip];
    } else {
        [self handleFlip];
    }

}

#define WIDTH_TO_HEIGHT_RATIO .75f

- (void) handleFlip
{
    int xPosition = 0;
    CGSize statusViewSize = self.lastFlipStatus.frame.size;
    
    //Layout cards
    int numberOfCardsTurnedUp=0;
    int widthOfEachCard = (statusViewSize.width/2)/self.numberOfCardsToMatch;
    for (int i=0; i < self.game.cardCount; i++) {
        Card* card = [self.game cardAtIndex:i];
        if (card.isFaceUp) {
            numberOfCardsTurnedUp++;
            CardView* view = [self createCardView];
            [self populateView:view withCard:card];
            view.faceUp = YES; //Force faceup
            view.unplayable = YES; //Force unplayable --> white for Set cards
            if (!view.isHorizontal) {
                widthOfEachCard = WIDTH_TO_HEIGHT_RATIO * statusViewSize.height;
            }
            view.frame = CGRectMake(xPosition, 0, widthOfEachCard, statusViewSize.height);
            [self.lastFlipStatus addSubview:view];
            xPosition+=widthOfEachCard;
        }
    }
    UILabel* label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES;
    if (numberOfCardsTurnedUp == 0) {
        label.text = [NSString stringWithFormat:@"No cards are turned up!"];
    } else if (numberOfCardsTurnedUp == 1) {
        label.text = [NSString stringWithFormat:@" is turned up!"];
    } else {
        label.text = [NSString stringWithFormat:@" are turned up!"];
    }
    
    // Make label the correct size
    int labelWidth = statusViewSize.width - xPosition;
    label.frame = CGRectMake(xPosition, 0, labelWidth, statusViewSize.height);
    
    // Make label have same bakground as its to-be superview and text white
    label.backgroundColor = self.lastFlipStatus.backgroundColor;
    label.textColor = [UIColor whiteColor];
    [self.lastFlipStatus addSubview:label];

}

- (void)handleMatchWithResults:(NSArray*)resultsOfLastFlip
{
    int xPosition = 0;
    CGSize statusViewSize = self.lastFlipStatus.frame.size;
    
    //Layout cards
    int widthOfEachCard = (statusViewSize.width/2)/self.numberOfCardsToMatch;
    for (int i=0; i < self.numberOfCardsToMatch; i++) {
        Card* card = (Card*) resultsOfLastFlip[i];
        CardView* view = [self createCardView];
        [self populateView:view withCard:card];
        view.faceUp = YES; //Force faceup
        if (!view.isHorizontal) {
            widthOfEachCard = WIDTH_TO_HEIGHT_RATIO * statusViewSize.height;
        }
        view.frame = CGRectMake(xPosition, 0, widthOfEachCard, statusViewSize.height);
        [self.lastFlipStatus addSubview:view];
        xPosition+=widthOfEachCard;
    }
    UILabel* label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES;
    int points = [[resultsOfLastFlip lastObject] intValue];
    
    // Create appropriate message depending on points
    if (points > 0) {
        label.text = [NSString stringWithFormat:@" matched for %d points!", [[resultsOfLastFlip lastObject] intValue]];
    } else {
        label.text = [NSString stringWithFormat:@" don't match! %d penalty!", [[resultsOfLastFlip lastObject] intValue]];
    }
    
    // Make label the correct size
    int labelWidth = statusViewSize.width - xPosition;
    label.frame = CGRectMake(xPosition, 0, labelWidth, statusViewSize.height);
    
    // Make label have same bakground as its to-be superview and text white
    label.backgroundColor = self.lastFlipStatus.backgroundColor;
    label.textColor = [UIColor whiteColor];
    [self.lastFlipStatus addSubview:label];
}

@end
