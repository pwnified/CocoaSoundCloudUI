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

#import "UIDevice+SoundCloudUI.h"

@implementation UIDevice (SoundCloudUI)

+ (BOOL)isIPad;
{
	if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		return YES; 
	}
	return NO;
}

+ (BOOL)isTallIphone;
{
	if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
		CGSize size = UIScreen.mainScreen.bounds.size;
        if (MAX(size.width, size.height) >= 568.0f) { // this is going to break as well. Stupid shit.
			return YES;
		}
    }
    return NO;
}
@end
