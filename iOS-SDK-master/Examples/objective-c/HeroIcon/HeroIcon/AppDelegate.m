//
// Please report any problems with this app template to contact@estimote.com
//

#import "AppDelegate.h"

#import "HeroIconManager.h"

@interface AppDelegate ()

@property (nonatomic) HeroIconManager *heroIconManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // TODO: put your App ID and App Token here
    // You can get them by adding your app on https://cloud.estimote.com/#/apps
    [ESTConfig setupAppID:@"<#App ID#>" andAppToken:@"<#App Token#>"];

    self.heroIconManager = [HeroIconManager new];
    [self.heroIconManager enableHeroIconForBeaconID:
     // TODO: replace with UUID, major and minor of your own beacon
     [[BeaconID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:1 minor:1]];

    // NOTE: if you come in range of the beacon with the screen turned on, you'll need to turn it off and then on again for the app icon to show on the lock screen.

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
