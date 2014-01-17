//
//  LMGameControllerManager.m
//  SiOS
//
//  Created by Wayne Hartman on 1/17/14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//

#import "LMGameControllerManager.h"
#import "LMGameController.h"

@implementation LMGameControllerManager

static LMGameControllerManager *singleton;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[LMGameControllerManager alloc] init];
    });

    return singleton;
}

- (instancetype)init {
    if ((self = [super init])) {
        if ([GCController controllers].count > 0) {
            LMGameController *gameController = [[LMGameController alloc] initWithGameController:[[GCController controllers] firstObject]];

            self.hardwareController = gameController;
            [self registerController:self.hardwareController];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDidConnect:)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDidDisconnect:)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
    }

    return self;
}

- (void)registerController:(id<LMHardwareController>)controller {
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

#pragma mark - Notifications

- (void)controllerDidConnect:(NSNotification *)notification {
    _hardwareController = [[LMGameController alloc] initWithGameController:notification.object];
}

- (void)controllerDidDisconnect:(NSNotification *)notification {
    _hardwareController = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
