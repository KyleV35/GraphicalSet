//
//  GraphicalSetViewController.m
//  GraphicalSet
//
//  Created by Kyle Vermeer on 2/2/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "GraphicalSetViewController.h"
#import "GraphicalSetCollectionViewCell.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"

@interface GraphicalSetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet GraphicalSetCardView *firstCardViewOutlet;
@property (weak, nonatomic) IBOutlet GraphicalSetCardView *secondCardViewOutlet;
@property (weak, nonatomic) IBOutlet GraphicalSetCardView *thirdCardViewOutlet;

@end

#define STARTING_CARD_COUNT 20
#define CARDS_TO_ADD 3
#define DISABLED_ALPHA 0.7f;

@implementation GraphicalSetViewController

- (CardMatchingGame*)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:STARTING_CARD_COUNT usingDeck:[[SetCardDeck alloc] init]];
    }
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstCardViewOutlet.hidden = YES;
    self.secondCardViewOutlet.hidden = YES;
    self.thirdCardViewOutlet.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)asker
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)asker numberOfItemsInSection:(NSInteger)section
{
    return [self.game cardCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)asker cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"GraphicalSetCard" forIndexPath:indexPath];
    if ([cell isKindOfClass:[GraphicalSetCollectionViewCell class]]) {
        GraphicalSetCollectionViewCell *setCell = (GraphicalSetCollectionViewCell*)cell;
        Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard*)card;
            [self updateViewForCell:setCell withSetCard:setCard];
        } else {
            NSLog(@"Card from cardAtIndex at index:%u was not a SetCard.",(NSUInteger)indexPath.item);
            exit(1);
        }
    } else {
        NSLog(@"Cell from cardCollectionView was not a GraphicalSetCollectionViewCell.");
        exit(1);
    }
    return cell;
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //Get index of card
        CGPoint tapPoint = [sender locationInView:self.cardCollectionView];
        NSIndexPath* indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
        
        if (indexPath) {
            //Flip card
            [self.game flipCardAtIndex:indexPath.item];
            NSLog(@"Index: %d",indexPath.item);
            NSLog(@"Point: %f,%f",tapPoint.x,tapPoint.y);
            
            //Get Results of flip
            [self handleLastFlip];
            
            Card* card = [self.game cardAtIndex:(NSUInteger)indexPath.item];
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard* setCard = (SetCard*) card;
                GraphicalSetCollectionViewCell* cell = (GraphicalSetCollectionViewCell*) [self.cardCollectionView cellForItemAtIndexPath:indexPath];
                [self updateViewForCell:cell withSetCard:setCard];
            }
            
            [self.cardCollectionView reloadData];
        }
    }
}

- (void)updateViewForCell:(GraphicalSetCollectionViewCell*)cell withSetCard:(SetCard*)card
{
    [cell.setCardView populateWithSetCard:card];
    [cell.setCardView setNeedsDisplay];
}

- (void) handleLastFlip
{
    NSArray *lastFlipResults = [self.game resultsOfLastFlip];
    if ([lastFlipResults count] == 4) {
        NSNumber* points = [lastFlipResults lastObject];
        if ([points intValue] > 0) {
            [self handleMatchOf:lastFlipResults[0] secondCard:lastFlipResults[1] thirdCard:lastFlipResults[2] withPoints:[points intValue]];
        }
    }
}

- (void) handleMatchOf:(SetCard*)firstCard secondCard:(SetCard*)secondCard thirdCard:(SetCard*)thirdCard withPoints:(int)points
{
    [self.firstCardViewOutlet populateWithSetCard:firstCard];
    self.firstCardViewOutlet.
    [self.firstCardViewOutlet setNeedsDisplay];
    self.firstCardViewOutlet.hidden = NO;
    [self.secondCardViewOutlet populateWithSetCard:secondCard];
    [self.secondCardViewOutlet setNeedsDisplay];
    self.secondCardViewOutlet.hidden = NO;
    [self.thirdCardViewOutlet populateWithSetCard:thirdCard];
    [self.thirdCardViewOutlet setNeedsDisplay];
    self.thirdCardViewOutlet.hidden = NO;
    [self.game removeCard:firstCard];
    [self.game removeCard:secondCard];
    [self.game removeCard:thirdCard];
}

- (IBAction)dealPressed {
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self.addCardsButton setEnabled:YES];
    self.addCardsButton.alpha = 1.0f;
}

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

@end
