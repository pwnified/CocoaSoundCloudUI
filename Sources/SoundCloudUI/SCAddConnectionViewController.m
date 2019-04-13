/*
 * Copyright 2010, 2011 nxtbgthng for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#import "NSData+SoundCloudUI.h"

#import "NSString+SoundCloudUI.h"


#import "SCAccount.h"
#import "SCRequest.h"

#import "SCBundle.h"

#import "SCAddConnectionViewController.h"

@interface SCAddConnectionViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end



@implementation SCAddConnectionViewController

@synthesize delegate;
@synthesize account;
@synthesize service;
@synthesize authorizeURL;
@synthesize activityIndicator;
@synthesize webView;

@synthesize loading;


#pragma mark Lifecycle

- (id)initWithService:(NSString *)aService account:(SCAccount *)anAccount delegate:(id<SCAddConnectionViewControllerDelegate>)aDelegate;
{
    if (!aService) return nil;
    
    self = [super init];
    if (self) {
        loading = NO;        
        delegate = aDelegate;
        service = aService;
        account = anAccount;
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    service, @"service",
                                    @"x-soundcloud://connection", @"redirect_uri",
                                    @"touch", @"display",
                                    nil];
        
        [SCRequest performMethod:SCRequestMethodPOST
                      onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/connections.json"]
                 usingParameters:parameters
                     withAccount:anAccount
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                     
                     if (data) {
                         
                         id result = [data JSONObject];
                         
                         if (![result isKindOfClass:[NSDictionary class]]) return;
                         
                         NSString *URLString = [result objectForKey:@"authorize_url"];
                         
                         if (URLString) self.authorizeURL = [NSURL URLWithString:URLString];
                         
                     } else {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCLocalizedString(@"connection_faild", @"Connection failed")
                                                                         message:[error localizedDescription]
                                                                        delegate:nil
                                                               cancelButtonTitle:SCLocalizedString(@"connection_error_ok", @"OK")
                                                               otherButtonTitles:nil];
                         [alert show];

                     }
                 }];
    }
    return self;
}

- (id)initWithService:(NSString *)aService delegate:(id<SCAddConnectionViewControllerDelegate>)aDelegate;
{
    if (!aService) return nil;
    
    if ((self = [super init])) {
        
        loading = NO;        

        delegate = aDelegate;
        service = aService;
    }
    return self;
}

- (void)dealloc;
{
    delegate = nil;
    webView.delegate = nil;
	webView = nil;
    self.loading = NO; // this is useless, man this code is crap
}

#pragma mark Accessors

- (void)setAuthorizeURL:(NSURL *)value;
{
      authorizeURL = value;
    
    if (webView) {
        [webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];
    }
}

- (void)setLoading:(BOOL)value;
{
    if (loading == value)
        return;
    loading = value;
}

#pragma mark Views

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[SCBundle imageWithName:@"darkTexturedBackgroundPattern"]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                               UIViewAutoresizingFlexibleTopMargin |
                                               UIViewAutoresizingFlexibleLeftMargin | 
                                               UIViewAutoresizingFlexibleRightMargin);
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    if (self.authorizeURL) {
        [webView loadRequest:[NSURLRequest requestWithURL:self.authorizeURL]];
    }
}


- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    self.activityIndicator.center = self.view.center;
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if ([request.URL.scheme isEqualToString:@"x-soundcloud"]) {
        
        //NSLog(@"We got an answer! %@", request.URL);
        NSDictionary *parameters = [request.URL.query dictionaryFromQuery];
        
        BOOL success = [[parameters objectForKey:@"success"] isEqualToString:@"1"];
        
        if ([delegate respondsToSelector:@selector(addConnectionController:didFinishWithService:success:)]) {
            [delegate addConnectionController:self
                         didFinishWithService:service
                                      success:success]; //MIGHTDO: We have to find out if we were successful
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.activityIndicator stopAnimating];
}


@end
