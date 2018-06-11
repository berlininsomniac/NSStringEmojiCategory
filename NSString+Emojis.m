//
//  NSString+Emojis.m
//  NSStringEmojiExtension
//
//  Created by Benjamin Salanki on 2018. 06. 11.
//  Copyright © 2018. Totally Inappropriate Technologies. All rights reserved.
//

#import "NSString+Emojis.h"

@implementation NSString (Emojis)

/**
 *	@brief Generates and returns an @c NSString containing a regular expression that finds the ranges in the string that contain only emojis.
 *
 *	@return A string that can be fed to @c NSRegularExpression to find all emoji ranges.
 */

+ (nonnull NSString *)emojiRegexString
{
	static NSString *_emojiRegexString = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		NSMutableArray *unicodeRanges = [NSMutableArray array];
		
		// Characters are defined in UTF-32 HEX.
		
		[unicodeRanges addObject:@"\U0001F600-\U0001F64F"]; // Emoticons
		[unicodeRanges addObject:@"\U0001F300-\U0001F5FF"]; // Misc Symbols and Pictographs
		[unicodeRanges addObject:@"\U0001F680-\U0001F6FF"];	// Transport and Map
		[unicodeRanges addObject:@"\U0001F1E6-\U0001F1FF"]; // Flags
		[unicodeRanges addObject:@"\U00002600-\U000026FF"];	// Misc symbols
		[unicodeRanges addObject:@"\U00002700-\U000027BF"];	// Dingbats
		[unicodeRanges addObject:@"\U0000FE00-\U0000FE0F"];	// Variation Selectors
		[unicodeRanges addObject:@"\U00065024-\U00065039"];	// Variation Selectors (continued)
		[unicodeRanges addObject:@"\U0001F900-\U0001F9FF"];	// Supplemental Symbols and Pictographs
		[unicodeRanges addObject:@"\U00008400-\U00008447"];	// Han Characters
		[unicodeRanges addObject:@"\U00009100-\U00009300"];	// Han Characters (continued)
		[unicodeRanges addObject:@"\U00002194-\U00002199"];	// Arrows
		[unicodeRanges addObject:@"\U000023E9-\U000023FA"];	// Controller buttons and Clocks
		[unicodeRanges addObject:@"\U000025FB-\U000025FE"];	// Colored Squares
		[unicodeRanges addObject:@"\U0001F191-\U0001F19A"]; // Squared
		[unicodeRanges addObject:@"\U0001F232-\U0001F23A"]; // Squared CJK
		[unicodeRanges addObject:@"\U000000A9\U000000AE\U0000203C\U00002049\U00002122\U00002139\U000021A9\U000021AA\U0000231A"]; // Items not fitting in ranges
		[unicodeRanges addObject:@"\U0000231B\U00002328\U000023CF\U000023E9\U000024C2\U000025AA\U000025AB\U000025B6\U000025C0"]; // Items not fitting in ranges (continued)
		[unicodeRanges addObject:@"\U0001F170\U0001F171\U0001F17E\U0001F17F\U0001F18E\U0001F004\U0001F201\U0001F202\U00003030"]; // Items not fitting in ranges (continued)
		[unicodeRanges addObject:@"\U0000303D\U00003297\U00003299\U00002934\U00002935\U00002B05\U00002B06\U00002B07\U00002B1B"]; // Items not fitting in ranges (continued)
		[unicodeRanges addObject:@"\U00002B1C\U00002B50\U00002B55\U0001F21A\U0001F22F\U0001F250\U0001F251"]; // Items not fitting in ranges (continued)
		[unicodeRanges addObject:@"[(\\*|\\#|0-9)\U000020E3]"]; // Number values suffixed with a keycap. Yeah. Exactly.
		[unicodeRanges addObject:@"\U0000200D"]; // Non-breaking space

		_emojiRegexString = [NSString stringWithFormat:@"[%@]+", [unicodeRanges componentsJoinedByString:@""]];
	});
	
	return _emojiRegexString;
}

/**
 *	@brief @c NSRegularExpression for finding emoji ranges in a string.
 *
 *	@return An @c NSRegularExpression initialized to find all emoji ranges in a string.
 */

+ (nonnull NSRegularExpression *)emojiRegex
{
	static NSRegularExpression *_emojiRegex = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_emojiRegex = [NSRegularExpression regularExpressionWithPattern:[self emojiRegexString] options:NSRegularExpressionCaseInsensitive error:nil];
	});
	
	return _emojiRegex;
}

- (nonnull NSArray<NSValue *> *)emojiRanges
{
	NSMutableArray *emojiRanges = [NSMutableArray array];
	
	NSArray<NSTextCheckingResult *> *matches = [[NSString emojiRegex] matchesInString:self options:0 range:NSMakeRange(0, [self length])];
	
	for (NSTextCheckingResult *match in matches)
	{
		[emojiRanges addObject:[NSValue valueWithRange:match.range]];
	}
	
	return [NSArray arrayWithArray:emojiRanges];
}

- (BOOL)containsOnlyEmojis
{
	NSArray<NSValue *> *emojiRanges = [self emojiRanges];
	NSRange firstEmojiRange = [emojiRanges count] > 0 ? [[emojiRanges firstObject] rangeValue] : NSMakeRange(NSNotFound, 0);
	
	return (self.length > 0 && [emojiRanges count] == 1 && firstEmojiRange.location == 0 && firstEmojiRange.length == [self length]);
}

- (nonnull NSString *)stringByStrippingEmojis
{
	NSMutableString *stringByStrippingEmojis = [self mutableCopy];
	
	NSArray<NSTextCheckingResult *> *matches = [[NSString emojiRegex] matchesInString:stringByStrippingEmojis options:0 range:NSMakeRange(0, [stringByStrippingEmojis length])];

	for (NSTextCheckingResult *match in matches.reverseObjectEnumerator)
	{
		[stringByStrippingEmojis replaceCharactersInRange:match.range withString:@""];
	}
	
	return [NSString stringWithString:stringByStrippingEmojis];
}

@end
