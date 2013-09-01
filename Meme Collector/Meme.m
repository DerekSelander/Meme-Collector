//
//  Meme.m
//  Meme Collector
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Selander. All rights reserved.
//

#import "Meme.h"
#import "AFNetworking.h"

#define kMemeGeneratorJSONResultKey @"result"
#define kMemeGeneratorNameKey @"displayName"
#define kMemeGeneratorRankingKey @"ranking"
#define kMemeGeneratorDescriptionKey @"description"

@implementation Meme

@synthesize cost=_cost;
@synthesize title=_title;
@synthesize image=_image;
@synthesize itemDescription=_itemDescription;
@synthesize purchaseCount=_purchaseCount;


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        //Title
        NSDictionary *resultDictionary = dictionary[kMemeGeneratorJSONResultKey];
        self.title = resultDictionary[kMemeGeneratorNameKey];
        
        
        //Purchase Count
        NSString *purchaseCount = [NSString stringWithFormat:@"%@ Purchase Count", self.title];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:purchaseCount]) {
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:purchaseCount];
        }
        self.purchaseCount = [[NSUserDefaults standardUserDefaults] objectForKey:purchaseCount];
        
        //Cost
        NSNumber *rankingNumber = resultDictionary[kMemeGeneratorRankingKey];
        //Make sure it is not negative
        if (rankingNumber.integerValue > 50) {
            rankingNumber = @41;
        }
        self.cost = @(51 - rankingNumber.integerValue);
        
        
        //Item Description
        if (resultDictionary[kMemeGeneratorDescriptionKey]) {
            self.itemDescription = resultDictionary[kMemeGeneratorDescriptionKey];
        } else {
            self.itemDescription = @"Uh oh... There's no description";
        }
        
    }
    return self;
}

- (void)memePurchased
{
    NSString *purchaseCountKey = [NSString stringWithFormat:@"%@ Purchase Count", self.title];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:purchaseCountKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:purchaseCountKey];
        self.purchaseCount = [[NSUserDefaults standardUserDefaults] objectForKey:purchaseCountKey];
    } else {
        NSNumber *purchaseCountNumber = [[NSUserDefaults standardUserDefaults] objectForKey:purchaseCountKey];
        purchaseCountNumber = @(purchaseCountNumber.integerValue+1);
        [[NSUserDefaults standardUserDefaults] setObject:purchaseCountNumber forKey:purchaseCountKey];
        self.purchaseCount = purchaseCountNumber;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
