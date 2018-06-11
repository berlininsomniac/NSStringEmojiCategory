//
//  NSString+Emojis.h
//  NSStringEmojiExtension
//
//  Created by Benjamin Salanki on 2018. 06. 11.
//  Copyright © 2018. Totally Inappropriate Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief Category on @c NSString for finding ranges of substrings that contain emojis.
 */

@interface NSString (Emojis)

/**
 *	@brief Finds the ranges in the receiver that consist only of emojis.
 *
 *	@discussion The ranges are calculated using @c NSRegularExpression.
 *
 *	@return An array of @c NSRange values wrapped in @c NSValue objects. If there are no matches, an empty array is returned.
 */

- (nonnull NSArray<NSValue *> *)emojiRanges;

/**
 *	@brief Checks wether the receiver consist solely of emojis.
 *
 *	@return @c YES, if the receiver consists only of emojis, @c NO otherwise.
 */

- (BOOL)containsOnlyEmojis;

/**
 *	@brief Creates a new @c NSString by stripping the emojis from the receiver.
 *
 *	@return A new @c NSString instance with the substrings from the receiver that do not contain emojis.
 */

- (nonnull NSString *)stringByStrippingEmojis;

@end
