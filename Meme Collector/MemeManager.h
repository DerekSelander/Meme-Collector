//
//  MemeManager.h
//  Meme Collector
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Selander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemeManager : NSObject

/*!
 An array of memes available to the user for collecting. 
 */
@property (nonatomic, strong, readonly) NSMutableArray *memes;

/*!
 Singleton app money manager
 */
+ (MemeManager *)sharedManager;

/*!
 Tells the manager that a transaction from user currency has taken place. This method updates the interal data store of the memes being presented
  @param  index The index of the meme located in the memes property
 */
- (void)memePurchased:(NSInteger)index;
@end
