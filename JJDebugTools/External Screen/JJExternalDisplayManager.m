//
// Created by Jacob Jennings on 1/26/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JJExternalDisplayManager.h"


@implementation JJExternalDisplayManager

+ (JJExternalDisplayManager *)shared
{
    static JJExternalDisplayManager *_displayManager;
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        _displayManager = [[self alloc] init];
    });
    return _displayManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _secondWindow = [[UIWindow alloc] init];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

        [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                       name:UIScreenDidConnectNotification object:nil];
        [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                       name:UIScreenDidDisconnectNotification object:nil];

        if ([[UIScreen screens] count] > 1)
        {
            [self configureWindow];
        }
    }
    return self;
}

- (void)configureWindow
{
    UIScreen *newScreen = [UIScreen screens][1];
    CGRect screenBounds = newScreen.bounds;
    self.secondWindow.frame = screenBounds;
    self.secondWindow.screen = newScreen;
    self.secondWindow.rootViewController = self.rootViewController;
    self.secondWindow.hidden = NO;
}

- (void)handleScreenDidConnectNotification:(NSNotification *)aNotification
{
    [self configureWindow];
}

- (void)handleScreenDidDisconnectNotification:(NSNotification *)aNotification
{
    self.secondWindow.hidden = YES;
}

- (BOOL)screenVisible
{
    return self.secondWindow.screen != nil;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    _rootViewController = rootViewController;

    if (self.secondWindow.screen)
    {
        self.secondWindow.rootViewController = rootViewController;
    }
}

@end