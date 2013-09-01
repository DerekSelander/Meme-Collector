//
//  MemeManager.m
//  Meme Collector
//
//  Created by Derek Selander on a happy day.
//  Copyright (c) 2013 Selander. All rights reserved.
//

#import "MemeManager.h"
#import "AFNetworking.h"
#import "Meme.h"
#define kURLParamName @"urlName"

@interface MemeManager () 
@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation MemeManager

+ (MemeManager *)sharedManager
{
    static MemeManager *sharedMemeManager = nil;
    if (!sharedMemeManager) {
        sharedMemeManager = [[MemeManager alloc] init];
        NSURL *url = [[NSURL alloc] initWithString:@"http://version1.api.memegenerator.net/Generator_Select_ByUrlNameOrGeneratorID"];
        sharedMemeManager.client = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        [sharedMemeManager.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [sharedMemeManager.client setDefaultHeader:@"Accept" value:@"application/json"];
        [sharedMemeManager getMemeInformation];
        sharedMemeManager->_memes = [NSMutableArray arrayWithCapacity:3];

    }
    
    return sharedMemeManager;
}


- (void)getMemeInformation
{
    NSString *pathString = @"http://version1.api.memegenerator.net/Generator_Select_ByUrlNameOrGeneratorID";
    
    //    NSURL *url
    [self.client getPath:pathString parameters:@{kURLParamName: @"Y-U-No"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDictionary = responseObject[@"result"];
        NSURL *imageURL = [NSURL URLWithString:resultDictionary[@"imageUrl"]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [[AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                              imageProcessingBlock:nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                               
                                                               //Create a new instance of the meme.
                                                               Meme *meme = [[Meme alloc] initWithDictionary:responseObject];
                                                               meme.image = image;
                                                               [_memes addObject:meme];
                                                                       NSUInteger index = [self.memes indexOfObject:meme];

                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadJSONCompletedNotification object:nil userInfo:@{@"position": @(index)}];
                                                               
                                                               
                                                               
                                                           } failure:nil] start];
        
    } failure:nil];
    
    
    [self.client getPath:pathString parameters:@{kURLParamName: @"Foul-Bachelor-Frog"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
  

        NSDictionary *resultDictionary = responseObject[@"result"];

        NSURL *imageURL = [NSURL URLWithString:resultDictionary[@"imageUrl"]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [[AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                              imageProcessingBlock:nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                               
                                                               //Create a new instance of the meme.
                                                               Meme *meme = [[Meme alloc] initWithDictionary:responseObject];
                                                               meme.image = image;
                                                               [_memes addObject:meme];
                                                               NSUInteger index = [self.memes indexOfObject:meme];

                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadJSONCompletedNotification object:nil userInfo:@{@"position": @(index)}];
                                                               
                                                               
                                                               
                                                           } failure:nil] start];
        
    } failure:nil];
    
    
    [self.client getPath:pathString parameters:@{kURLParamName: @"Rage-Fu"} success:^(AFHTTPRequestOperation *operation, id responseObject) {


        NSDictionary *resultDictionary = responseObject[@"result"];
        NSURL *imageURL = [NSURL URLWithString:resultDictionary[@"imageUrl"]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [[AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                             imageProcessingBlock:nil
                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                              
                                                              Meme *meme = [[Meme alloc] initWithDictionary:responseObject];
                                                              meme.image = image;
                                                              [_memes addObject:meme];
                                                              NSUInteger index = [self.memes indexOfObject:meme];

                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadJSONCompletedNotification object:nil userInfo:@{@"position": @(index)}];

                                                              
                                                              
                                                          } failure:nil] start];
        
    } failure:nil];
   
}


- (void)memePurchased:(NSInteger)index
{
    Meme *meme = self.memes[index];
    [meme memePurchased];
}

@end
