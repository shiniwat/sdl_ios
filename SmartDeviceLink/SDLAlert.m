//  SDLAlert.m

#import "SDLAlert.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLTTSChunk.h"

static UInt16 const SDLDefaultDuration = 5000;

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlert

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAlert]) {
    }
    return self;
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:SDLDefaultDuration];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:nil duration:duration];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration {
    return [self initWithAlertText1:alertText1 alertText2:alertText2 alertText3:alertText3 duration:duration softButtons:nil];
}

- (instancetype)initWithAlertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:nil alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:NO duration:duration softButtons:softButtons];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText playTone:(BOOL)playTone {
    return [self initWithTTS:ttsText alertText1:nil alertText2:nil playTone:playTone duration:SDLDefaultDuration];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 playTone:(BOOL)playTone duration:(UInt16)duration {
    return [self initWithTTS:ttsText alertText1:alertText1 alertText2:alertText2 alertText3:nil playTone:playTone duration:duration];
}

- (instancetype)initWithTTS:(nullable NSString *)ttsText alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration {
    NSArray *ttsChunks = [SDLTTSChunk textChunksFromString:ttsText];
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:duration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks playTone:(BOOL)playTone {
    return [self initWithTTSChunks:ttsChunks alertText1:nil alertText2:nil alertText3:nil playTone:playTone duration:SDLDefaultDuration softButtons:nil];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    return [self initWithTTSChunks:ttsChunks alertText1:alertText1 alertText2:alertText2 alertText3:alertText3 playTone:playTone duration:SDLDefaultDuration softButtons:softButtons];
}

- (instancetype)initWithTTSChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks alertText1:(nullable NSString *)alertText1 alertText2:(nullable NSString *)alertText2 alertText3:(nullable NSString *)alertText3 playTone:(BOOL)playTone duration:(UInt16)duration softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.ttsChunks = [ttsChunks mutableCopy];
    self.alertText1 = alertText1;
    self.alertText2 = alertText2;
    self.alertText3 = alertText3;
    self.playTone = @(playTone);
    self.duration = @(duration);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (void)setAlertText1:(nullable NSString *)alertText1 {
    [parameters sdl_setObject:alertText1 forName:SDLRPCParameterNameAlertText1];
}

- (nullable NSString *)alertText1 {
    return [parameters sdl_objectForName:SDLRPCParameterNameAlertText1 ofClass:NSString.class error:nil];
}

- (void)setAlertText2:(nullable NSString *)alertText2 {
    [parameters sdl_setObject:alertText2 forName:SDLRPCParameterNameAlertText2];
}

- (nullable NSString *)alertText2 {
    return [parameters sdl_objectForName:SDLRPCParameterNameAlertText2 ofClass:NSString.class error:nil];
}

- (void)setAlertText3:(nullable NSString *)alertText3 {
    [parameters sdl_setObject:alertText3 forName:SDLRPCParameterNameAlertText3];
}

- (nullable NSString *)alertText3 {
    return [parameters sdl_objectForName:SDLRPCParameterNameAlertText3 ofClass:NSString.class error:nil];
}

- (void)setTtsChunks:(nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    [parameters sdl_setObject:ttsChunks forName:SDLRPCParameterNameTTSChunks];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsChunks {
    return [parameters sdl_objectsForName:SDLRPCParameterNameTTSChunks ofClass:SDLTTSChunk.class error:nil];
}

- (void)setDuration:(nullable NSNumber<SDLInt> *)duration {
    [parameters sdl_setObject:duration forName:SDLRPCParameterNameDuration];
}

- (nullable NSNumber<SDLInt> *)duration {
    return [parameters sdl_objectForName:SDLRPCParameterNameDuration ofClass:NSNumber.class error:nil];
}

- (void)setPlayTone:(nullable NSNumber<SDLBool> *)playTone {
    [parameters sdl_setObject:playTone forName:SDLRPCParameterNamePlayTone];
}

- (nullable NSNumber<SDLBool> *)playTone {
    return [parameters sdl_objectForName:SDLRPCParameterNamePlayTone ofClass:NSNumber.class error:nil];
}

- (void)setProgressIndicator:(nullable NSNumber<SDLBool> *)progressIndicator {
    [parameters sdl_setObject:progressIndicator forName:SDLRPCParameterNameProgressIndicator];
}

- (nullable NSNumber<SDLBool> *)progressIndicator {
    return [parameters sdl_objectForName:SDLRPCParameterNameProgressIndicator ofClass:NSNumber.class error:nil];
}

- (void)setSoftButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
    [parameters sdl_setObject:softButtons forName:SDLRPCParameterNameSoftButtons];
}

- (nullable NSArray<SDLSoftButton *> *)softButtons {
    return [parameters sdl_objectsForName:SDLRPCParameterNameSoftButtons ofClass:SDLSoftButton.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
