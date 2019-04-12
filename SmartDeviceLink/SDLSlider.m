//  SDLSlider.m
//


#import "SDLSlider.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSlider

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSlider]) {
    }
    return self;
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout {
    NSArray<NSString *> *footer = nil;
    if (sliderFooter != nil) {
        footer = @[sliderFooter];
    }

    return [self initWithNumTicks:numTicks position:position sliderHeader:sliderHeader sliderFooters:footer timeout:timeout];
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout {
    self = [self initWithNumTicks:numTicks position:position];
    if (!self) {
        return nil;
    }

    self.sliderHeader = sliderHeader;
    self.sliderFooter = [sliderFooters mutableCopy];
    self.timeout = @(timeout);

    return self;
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.numTicks = @(numTicks);
    self.position = @(position);

    return self;
}

- (void)setNumTicks:(NSNumber<SDLInt> *)numTicks {
    [parameters sdl_setObject:numTicks forName:SDLRPCParameterNameNumberTicks];
}

- (NSNumber<SDLInt> *)numTicks {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameNumberTicks ofClass:NSNumber.class error:&error];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [parameters sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (NSNumber<SDLInt> *)position {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNamePosition ofClass:NSNumber.class error:&error];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    [parameters sdl_setObject:sliderHeader forName:SDLRPCParameterNameSliderHeader];
}

- (NSString *)sliderHeader {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameSliderHeader ofClass:NSString.class error:&error];
}

- (void)setSliderFooter:(nullable NSArray<NSString *> *)sliderFooter {
    [parameters sdl_setObject:sliderFooter forName:SDLRPCParameterNameSliderFooter];
}

- (nullable NSArray<NSString *> *)sliderFooter {
    return [parameters sdl_objectsForName:SDLRPCParameterNameSliderFooter ofClass:NSString.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLRPCParameterNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLRPCParameterNameTimeout ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
