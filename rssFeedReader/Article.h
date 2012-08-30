//
//  Article.h
//  RSSFeedReader
//
//  Created by Stephanie Shupe on 8/29/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property (strong) NSString *title;
@property (strong) NSString *subtitle;
@property (strong) NSURL *link;
@property (strong) UIImage *image;

- (Article*) initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle andLink:(NSString*)link;
- (void) performBlockWithImage: (void(^)(UIImage*)) block;

@end
