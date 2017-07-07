
#import "EMCDDeviceManager.h"

@interface EMCDDeviceManager (Microphone)

// Check the availability for microphone
- (BOOL)emCheckMicrophoneAvailability;

// Get the audio volumn (0~1)
- (double)emPeekRecorderVoiceMeter;
@end
