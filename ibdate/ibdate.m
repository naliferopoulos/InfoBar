#import <Foundation/Foundation.h>

NSString* GetInfo()
{

        NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM"];
        
        return [dateFormatter stringFromDate:[NSDate date]];
}

