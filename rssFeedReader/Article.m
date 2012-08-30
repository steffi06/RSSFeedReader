//
//  Article.m
//  RSSFeedReader
//
//  Created by Stephanie Shupe on 8/29/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "Article.h"
#import "TFHpple.h"

@implementation Article
@synthesize title = _title;
@synthesize subtitle =_subtitle;
@synthesize link = _link;
@synthesize image = _image;

-(Article*)initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle andLink:(NSString*)link
{
    self = [super init];
    if(self){
        self.title = title;
        self.subtitle = subtitle;
        self.link = [NSURL URLWithString:link];
    }
    return self;
}

- (void) performBlockWithImage: (void(^)(UIImage*)) block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if (!self.image){
            NSData *htmlData = [NSData dataWithContentsOfURL:self.link];

            TFHpple *doc = [[TFHpple alloc]initWithHTMLData:htmlData];
            NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='all-post-body group']//img[1]"];
            TFHppleElement *firstElement = [elements objectAtIndex:0];

            
            NSError *error;
            NSURLResponse *response;
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[firstElement objectForKey:@"src"]]];
            NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            
        
            if (data) {
                self.image = [UIImage imageWithData:data];

            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(self.image);
        });
    });
}

@end
