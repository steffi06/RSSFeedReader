//
//  FeedTableViewController.m
//  RSSFeedReader
//
//  Created by Stephanie Shupe on 8/28/12.
//  Copyright (c) 2012 burnOffBabes. All rights reserved.
//

#import "FeedTableViewController.h"
#import "RestKit.h"
#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "Article.h"

@interface FeedTableViewController () <RKRequestDelegate>

@property (strong) NSMutableArray *results;
@property (strong) NSString *baseURL;
@property BOOL responseLoaded;


@end

@implementation FeedTableViewController
@synthesize results = _results;
@synthesize baseURL = _baseURL;
@synthesize responseLoaded = _responseLoaded;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"TMZ RSS Feed";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.responseLoaded = NO;

    
    self.baseURL = @"http://www.tmz.com";
    [RKClient clientWithBaseURLString:self.baseURL];
    [self newRSSRequest];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleDone target:self action:@selector(newRSSRequest)];
    self.navigationItem.rightBarButtonItem = reloadButton;

}

-(void)viewDidAppear:(BOOL)animated {
    if (!self.responseLoaded) {
        [self newMBProgressHUD];
    }

}

- (void)newMBProgressHUD {
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    progressHUD.removeFromSuperViewOnHide = YES;
    
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    
    progressHUD.labelText = @"Fetching TMZ RSS Feed...";
    
    progressHUD.detailsLabelText = @"Bet you can't wait to see the current gossip!  We're working on it!";

    
}

- (void)newRSSRequest {

    self.results = [[NSMutableArray alloc]init];
    NSLog(@"%@", self.results);

    RKClient *client = [RKClient sharedClient];
    [client get:@"/rss.xml" delegate:self];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"%@",response);
    self.responseLoaded = YES;
    
    NSError *error;
    id<RKParser> xmlParser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];

    NSDictionary *parseResponse = [xmlParser objectFromString:[response bodyAsString] error:&error];

    NSArray *items = [[[parseResponse objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
    for (NSDictionary *item  in  items) {
        Article *article = [[Article alloc]initWithTitle:[item objectForKey:@"title"] andSubtitle:[item objectForKey:@"description"] andLink:[item objectForKey:@"link"]];
        [self.results addObject:article];
        NSLog(@"%@", article);
    }
    
    NSLog(@"%@", self.results);
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog (@"%@", error);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier ];
    }
    
    Article *article = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = article.title;
        
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = article.subtitle;
    
    [article performBlockWithImage:^void(UIImage *articleImage){
        if ([cell.textLabel.text isEqualToString:article.title]) {
            cell.imageView.image = articleImage;
            [cell setNeedsLayout];
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.imageView.image = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webVC = [WebViewController new];
    webVC.url = [[self.results objectAtIndex:indexPath.row] link];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
