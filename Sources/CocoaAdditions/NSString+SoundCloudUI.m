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

#include <CommonCrypto/CommonDigest.h>

#import "NSString+SoundCloudUI.h"
#import "NSData+SoundCloudUI.h"

@implementation NSString (SoundCloudUI)


#pragma mark UUID

+ (NSString *)stringWithUUID;
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	
    return CFBridgingRelease(string);
}

#pragma mark NSTimeInterval

+ (NSString *)stringWithSeconds:(NSTimeInterval)seconds;
{
	return [NSString stringWithMilliseconds:(NSInteger)(seconds * 1000.0)];
}


#pragma mark NSInteger

+ (NSString *)stringWithMilliseconds:(NSInteger)seconds;
{
	seconds = seconds / 1000;
	NSInteger hours = seconds / 60 / 60;
	seconds -= hours * 60 * 60;
	NSInteger minutes = seconds / 60;
	seconds -= minutes * 60;
	
	
	NSMutableString *string = [NSMutableString string];
	
	if (hours > 0) {
		[string appendFormat:@"%u.", (int)hours];
	}
	
	if (minutes >= 10 || hours == 0) {
		[string appendFormat:@"%u.", (int)minutes];
	} else {
		[string appendFormat:@"0%u.", (int)minutes];
	}
	
	if (seconds >= 10) {
		[string appendFormat:@"%u", (int)seconds];
	} else {
		[string appendFormat:@"0%u", (int)seconds];
	}
	
	return string;
}

+ (NSString *)stringWithInteger:(NSInteger)integer upperRange:(NSInteger)upperRange;
{
	if (integer <= upperRange) {
		return [[self class] stringWithFormat:@"%d", (int)integer];
	} else {
		return [[self class] stringWithFormat:@"%d+", (int)upperRange];
	}
}


#pragma mark Whitespace

- (NSArray *)componentsSeparatedByWhitespacePreservingQuotations;
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableArray *result = [NSMutableArray array];
    while (![scanner isAtEnd]) {
        NSString *tag = nil;
        NSString *beginning = [self substringWithRange:NSMakeRange([scanner scanLocation], 1)];
        if ([beginning isEqualToString:@"\""]) {
            [scanner setScanLocation:[scanner scanLocation] + 1];
            [scanner scanUpToString:@"\"" intoString:&tag];
            [scanner setScanLocation:[scanner scanLocation] + 1];
        } else {
            [scanner scanUpToString:@" " intoString:&tag];
        }
        if (![scanner isAtEnd]) {
            [scanner setScanLocation:[scanner scanLocation] + 1];
        }
        if (tag) [result addObject:tag];
    }
    return result;
}


#pragma mark JSON

- (id)JSONObject;
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [jsonData JSONObject];
}


#pragma mark Escaping

- (NSString *)stringByUnescapingXMLEntities;
{
    NSMutableString *mutableSelf = [self mutableCopy];
    [mutableSelf replaceOccurrencesOfString:@"&amp;" withString:@"&" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&#39;" withString:@"'" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&gt;" withString:@">" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&lt;" withString:@"<" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"auml;" withString:@"ä" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&Auml;" withString:@"Ä" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&ouml;" withString:@"ö" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&Ouml;" withString:@"Ö" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&uuml;" withString:@"ü" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&Üuml;" withString:@"Ü" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&szlig;" withString:@"ß" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
	return [mutableSelf copy];
}

- (NSString *)stringByEscapingXMLEntities;
{
    NSMutableString *mutableSelf = [self mutableCopy];

    [mutableSelf replaceOccurrencesOfString:@"&" withString:@"&amp;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"'" withString:@"&#39;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@">" withString:@"&gt;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"<" withString:@"&lt;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"ä" withString:@"auml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"Ä" withString:@"&Auml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"ö" withString:@"&ouml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"Ö" withString:@"&Ouml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"ü" withString:@"&uuml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"Ü" withString:@"&Üuml;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@"ß" withString:@"&szlig;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    [mutableSelf replaceOccurrencesOfString:@" " withString:@"&nbsp;" options:kNilOptions range:NSMakeRange(0, mutableSelf.length)];
    
    return [mutableSelf copy];
}

- (NSString *)stringByAddingURLEncoding;
{
	CFStringRef returnValue = CFURLCreateStringByAddingPercentEscapes (kCFAllocatorDefault, //Allocator
																	   (CFStringRef)self, //Original String
																	   NULL, //Characters to leave unescaped
																	   (CFStringRef)@"!*'();:@&=+$,/?%#[]", //Legal Characters to be escaped
																	   kCFStringEncodingUTF8); //Encoding
    return CFBridgingRelease(returnValue);
}

- (NSString *)stringByRemovingURLEncoding;
{
	CFStringRef returnValue = CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, //Allocator
																		 (CFStringRef)self,
																		 nil);
	return CFBridgingRelease(returnValue);
}


#pragma mark MD5

- (NSString *)md5Value
{
	//from http://www.tomdalling.com/cocoa/md5-hashes-in-cocoa
	NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], (CC_LONG)[inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	
	return hashStr;
}


#pragma mark Query String Helpers

- (NSDictionary *)dictionaryFromQuery;
{
	NSArray *encodedParameterPairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    
    for (NSString *encodedPair in encodedParameterPairs) {
        NSArray *encodedPairElements = [encodedPair componentsSeparatedByString:@"="];
		if (encodedPairElements.count == 2) {
			[requestParameters setValue:[[encodedPairElements objectAtIndex:1] stringByRemovingURLEncoding]
								 forKey:[[encodedPairElements objectAtIndex:0] stringByRemovingURLEncoding]];
		}
    }
	return requestParameters;
}

@end
