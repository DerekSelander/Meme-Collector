//
//  ViewController.h
//  Reverse Me
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Derek Selander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *ItemCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *memeDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCurrencyButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalLayoutConstraint;


@end
