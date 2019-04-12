//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"
#import "SDLVrHelpItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:nil vrHelp:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:nil menuIcon:nil keyboardProperties:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    self.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    self.vrHelpTitle = vrHelpTitle;
    self.vrHelp = [vrHelp mutableCopy];
    self.menuTitle = menuTitle;
    self.menuIcon = menuIcon;
    self.keyboardProperties = keyboardProperties;

    return self;
}

- (void)setHelpPrompt:(nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    [parameters sdl_setObject:helpPrompt forName:SDLRPCParameterNameHelpPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)helpPrompt {
    return [parameters sdl_objectsForName:SDLRPCParameterNameHelpPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setTimeoutPrompt:(nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    [parameters sdl_setObject:timeoutPrompt forName:SDLRPCParameterNameTimeoutPrompt];
}

- (nullable NSArray<SDLTTSChunk *> *)timeoutPrompt {
    return [parameters sdl_objectsForName:SDLRPCParameterNameTimeoutPrompt ofClass:SDLTTSChunk.class error:nil];
}

- (void)setVrHelpTitle:(nullable NSString *)vrHelpTitle {
    [parameters sdl_setObject:vrHelpTitle forName:SDLRPCParameterNameVRHelpTitle];
}

- (nullable NSString *)vrHelpTitle {
    return [parameters sdl_objectForName:SDLRPCParameterNameVRHelpTitle ofClass:NSString.class error:nil];
}

- (void)setVrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    [parameters sdl_setObject:vrHelp forName:SDLRPCParameterNameVRHelp];
}

- (nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [parameters sdl_objectsForName:SDLRPCParameterNameVRHelp ofClass:SDLVRHelpItem.class error:nil];
}

- (void)setMenuTitle:(nullable NSString *)menuTitle {
    [parameters sdl_setObject:menuTitle forName:SDLRPCParameterNameMenuTitle];
}

- (nullable NSString *)menuTitle {
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuTitle ofClass:NSString.class error:nil];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [parameters sdl_setObject:menuIcon forName:SDLRPCParameterNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:SDLImage.class error:nil];
}

- (void)setKeyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    [parameters sdl_setObject:keyboardProperties forName:SDLRPCParameterNameKeyboardProperties];
}

- (nullable SDLKeyboardProperties *)keyboardProperties {
    return [parameters sdl_objectForName:SDLRPCParameterNameKeyboardProperties ofClass:SDLKeyboardProperties.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
