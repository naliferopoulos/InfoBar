#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString* GetInfo()
{
        return [NSString stringWithFormat:@"%d%%", (int)([[UIDevice currentDevice] batteryLevel] * 100)];
}

