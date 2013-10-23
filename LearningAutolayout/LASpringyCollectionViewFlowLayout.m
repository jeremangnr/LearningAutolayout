//
//  LASpringyCollectionViewFlowLayout.m
//  LearningAutolayout
//
//  Created by Jeremias Nunez on 10/23/13.
//  Copyright (c) 2013 Globant. All rights reserved.
//

#import "LASpringyCollectionViewFlowLayout.h"

@interface LASpringyCollectionViewFlowLayout()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation LASpringyCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - behavior.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - behavior.anchorPoint.x);
        // items farther to the touch should take a little more time to move
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 2500.0f; // smaller values make it more "springy"
        
        UICollectionViewLayoutAttributes *item = behavior.items.firstObject;
        CGPoint center = item.center;
        
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }
    
    return NO;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGSize contentSize = self.collectionView.contentSize;
    // not cool, we could have thousands of items
    NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
    
    if ([self.dynamicAnimator.behaviors count] == 0) {
        
        for (id<UIDynamicItem> item in items) {
            UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:item
                                                                       attachedToAnchor:item.center];
            
            behavior.length = 0.0f;
            behavior.damping = 0.8f;
            behavior.frequency = 1.0f;
            
            [self.dynamicAnimator addBehavior:behavior];
        }
        
    }
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (void)removeBehaviors {
    [self.dynamicAnimator removeAllBehaviors];
}

@end
