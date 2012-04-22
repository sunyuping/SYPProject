//
//  NSArray+RNAdditions.h
//  RRSpring
//
//  Created by hai zhang on 3/6/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RNAdditions)

/**
 * Calls performSelector on all objects that can receive the selector in the array.
 * Makes an iterable copy of the array, making it possible for the selector to modify
 * the array. Contrast this with makeObjectsPerformSelector which does not allow side effects of
 * modifying the array.
 */
- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

/**
 * Extensions to makeObjectsPerformSelector to provide support for more than one object
 * parameter.
 */
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)makeObjectsPerformSelector: (SEL)selector
                        withObject: (id)p1
                        withObject: (id)p2
                        withObject: (id)p3;

/**
 * @return nil or an object that matches value with isEqual:
 */
- (id)objectWithValue:(id)value forKey:(id)key;

/**
 * @return the first object with the given class.
 */
- (id)objectWithClass:(Class)cls;

/**
 * @param selector Required format: - (NSNumber*)method:(id)object;
 */
- (BOOL)containsObject:(id)object withSelector:(SEL)selector;

@end

