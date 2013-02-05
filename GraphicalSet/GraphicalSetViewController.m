//
//  GraphicalSetViewController.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GraphicalSetViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"

#import "CardCollectionViewCell.h"
#import "GraphicalSetCardView.h"

@interface GraphicalSetViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

@end

#define STARTING_CARD_COUNT 12
#define CARDS_TO_ADD 3
#define CARDS_TO_MATCH 3
#define DISABLED_ALPHA 0.7f

@implementation GraphicalSetViewController


#pragma mark Virtual Function Overriding

- (NSUInteger)startingCardCount
{
    return STARTING_CARD_COUNT;
}

- (Deck*)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    return CARDS_TO_MATCH;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"GraphicalSetCard" forIndexPath:indexPath];
    if ([cell isKindOfClass:[CardCollectionViewCell class]]) {
        CardCollectionViewCell *cardCell = (CardCollectionViewCell*)cell;
        Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
        [self populateView:cardCell.cardView withCard:card];
    } else {
        NSLog(@"Cell from cardCollectionView was not a GraphicalSetCollectionViewCell.");
        exit(1);
    }
    return cell;
}

- (IBAction)dealPressed {
    [super dealPressed];
    [self.addCardsButton setEnabled:YES];
    self.addCardsButton.alpha = 1.0f;
}

#pragma mark Helper Functions


- (IBAction)addCardsPressed {
    BOOL areMoreCards = [self.game addMoreCards:CARDS_TO_ADD];
    if (!areMoreCards) {
        [self.addCardsButton setEnabled:NO];
        self.addCardsButton.alpha = DISABLED_ALPHA;
    }
    [self.cardCollectionView reloadData];
    NSUInteger count = [self.game cardCount];
    [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(count-1) inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
}

- (void)populateView:(CardView*)cardView withCard:(Card*)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard* setCard = (SetCard*)card;
        if ([cardView isKindOfClass:[GraphicalSetCardView class]]) {
            GraphicalSetCardView* setCardView = (GraphicalSetCardView*)cardView;
            [setCardView populateWithSetCard:setCard];
        } else {
            NSLog(@"Not a GraphicalSetCardView!");
            exit(1);
        }
    } else {
        NSLog(@"Not a SetCard!");
        exit(1);
    }
}

- (CardView*) createCardView
{
    return [[GraphicalSetCardView alloc] init];
}

@end
