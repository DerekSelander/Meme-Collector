//
//  PurchaseableItemCollectionViewCell.m
//  Meme Collector
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import "PurchaseableItemCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
@interface PurchaseableItemCollectionViewCell ()
@property (nonatomic, strong) NSArray *tappedConstraintArray;
@property (nonatomic, strong) NSArray *idleConstraintsArray;
@end

@implementation PurchaseableItemCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 10.0f;
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    ///Autolayout does not play nice with view transforms; using layers instead
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.1;
    anim.fromValue = nil;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)];
    [self.itemImageView.layer addAnimation:anim forKey:nil];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.2;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
    [self.itemImageView.layer addAnimation:anim forKey:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.2;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
    [self.itemImageView.layer addAnimation:anim forKey:nil];
}

@end
