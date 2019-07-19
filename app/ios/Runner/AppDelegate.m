#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyC9LWJiaH87CFipXkxxgUVfD49Lzf-dXM8"];
    
    ///flutter native method handler
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    ///flutter native method channel
    FlutterMethodChannel* callMethodChannel = [FlutterMethodChannel
                                               methodChannelWithName:@"mn.ddish.app"
                                               binaryMessenger:controller];
    
    [callMethodChannel  setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if([@"call" isEqualToString:call.method]){
            UIApplication *application = [UIApplication sharedApplication];
            NSArray *arguments = call.arguments;
            NSString *phoneNumber = arguments[0];
            if(phoneNumber == nil){
                printf("phone number is null");
            }
            else{
                NSURL *phoneNumberUrl = [@"tel://" stringByAppendingString:phoneNumber];
                
                NSURL *URL = [NSURL URLWithString: phoneNumberUrl];
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"Opened url");
                    }
                }];
            }
        }
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
