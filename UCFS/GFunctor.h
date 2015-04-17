//
//  GFunctor.h
//


//

#import <Foundation/Foundation.h>

@interface GFunctor : NSObject {
	void (^block)();
	__unsafe_unretained NSTimer *toInvalidate;
}

@property (nonatomic,assign) __unsafe_unretained NSTimer *toInvalidate;

- (id) initWithBlock:(void (^)())block;
- (void) invoke;

@end
