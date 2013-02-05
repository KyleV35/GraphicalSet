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
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    //Get index of card
    CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
    NSIndexPath* indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    [self cardWasTappedAtIndexPath:indexPath];
}

- (void)cardWasTappedAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        //Flip card
        [self.game flipCardAtIndex:indexPath.item];
        NSLog(@"Index: %d",indexPath.item);
        
        //Get Results of flip
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
        NSNumber* points = [resultsOfLastFlip lastObject];
        if ([points intValue] > 0) {
            [self handleMatchWithResults:(NSArray*)resultsOfLastFlip];
        }
    }

}

- (void)handleMatchWithResults:(NSArray*)resultsOfLastFlip
{
    int xPosition = 0;
    CGSize statusViewSize = self.lastFlipStatus.frame.size;
    int widthOfEachCard = (statusViewSize.width/2)/self.numberOfCardsToMatch;
    for (int i=0; i < self.numberOfCardsToMatch; i++) {
        Card* card = (Card*) resultsOfLastFlip[i];
        CardView* view = [self createCardView];
        [self populateView:view withCard:card];
        view.frame = CGRectMake(xPosition, 0, widthOfEachCard, statusViewSize.height);
        [self.lastFlipStatus addSubview:view];
        xPosition+=widthOfEachCard;
    }
    UILabel* label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = [NSString stringWithFormat:@"matched for %d points!", [[resultsOfLastFlip lastObject] intValue]];
    CGSize statusSize = self.lastFlipStatus.frame.size;
    statusSize.width -= xPosition;
    label.frame = CGRectMake(xPosition, 0, statusSize.width, statusSize.height);
    label.backgroundColor = self.lastFlipStatus.backgroundColor;
    label.textColor = [UIColor whiteColor];
    [self.lastFlipStatus addSubview:label];
}

@end
