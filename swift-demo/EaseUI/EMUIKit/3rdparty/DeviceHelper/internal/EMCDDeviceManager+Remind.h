
#import "EMCDDeviceManager.h"
#import <AudioToolbox/AudioToolbox.h>
@interface EMCDDeviceManager (Remind)

// Play system sound when receiving a new message
- (SystemSoundID)playNewMessageSound;

- (void)playVibration;

@end
