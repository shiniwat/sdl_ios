//  SDLPermissionItem.m
//

#import "SDLPermissionItem.h"

#import "NSMutableDictionary+Store.h"
#import "SDLHMIPermissions.h"
#import "SDLRPCParameterNames.h"
#import "SDLParameterPermissions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionItem

- (void)setRpcName:(NSString *)rpcName {
    [store sdl_setObject:rpcName forName:SDLRPCParameterNameRPCName];
}

- (NSString *)rpcName {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameRPCName ofClass:NSString.class error:&error];
}

- (void)setHmiPermissions:(SDLHMIPermissions *)hmiPermissions {
    [store sdl_setObject:hmiPermissions forName:SDLRPCParameterNameHMIPermissions];
}

- (SDLHMIPermissions *)hmiPermissions {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameHMIPermissions ofClass:SDLHMIPermissions.class error:&error];
}

- (void)setParameterPermissions:(SDLParameterPermissions *)parameterPermissions {
    [store sdl_setObject:parameterPermissions forName:SDLRPCParameterNameParameterPermissions];
}

- (SDLParameterPermissions *)parameterPermissions {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameParameterPermissions ofClass:SDLParameterPermissions.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
