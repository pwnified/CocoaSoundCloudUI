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

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "SCAddConnectionViewControllerDelegate.h"

@class SCAccount;

@interface SCAddConnectionViewController : UIViewController

@property (nonatomic, weak) id <SCAddConnectionViewControllerDelegate> delegate;
@property (nonatomic, strong) SCAccount *account;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, strong) NSURL *authorizeURL;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL loading;



- (id)initWithService:(NSString *)service account:(SCAccount *)anAccount delegate:(id<SCAddConnectionViewControllerDelegate>)delegate;
- (id)initWithService:(NSString *)service delegate:(id<SCAddConnectionViewControllerDelegate>)delegate;

@end
