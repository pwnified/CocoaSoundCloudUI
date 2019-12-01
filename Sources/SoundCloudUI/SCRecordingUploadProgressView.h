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

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    SCRecordingUploadProgressViewStateUploading = 0,
    SCRecordingUploadProgressViewStateSuccess,
    SCRecordingUploadProgressViewStateFailed
} SCRecordingUploadProgressViewState;

@interface SCRecordingUploadProgressView : UIScrollView<SKStoreProductViewControllerDelegate>

@property (nonatomic, readonly, strong) UIImageView *artworkView;
@property (nonatomic, readonly, strong) UILabel *title;
@property (nonatomic, readonly, strong) UIProgressView *progress;
@property (nonatomic, readwrite, assign) SCRecordingUploadProgressViewState state;
@property (nonatomic, readwrite, strong) NSDictionary *trackInfo;

@property (nonatomic, strong) UIImage *artwork;

@end
