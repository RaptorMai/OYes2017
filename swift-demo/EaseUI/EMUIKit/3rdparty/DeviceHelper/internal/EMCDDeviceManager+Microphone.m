
#import "EMCDDeviceManager+Microphone.h"
#import "EMAudioRecorderUtil.h"

@implementation EMCDDeviceManager (Microphone)

// Check the availability for microphone
- (BOOL)emCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    
    return ret;
}

// Get the audio volumn (0~1)
- (double)emPeekRecorderVoiceMeter{
    double ret = 0.0;
    if ([EMAudioRecorderUtil recorder].isRecording) {
        [[EMAudioRecorderUtil recorder] updateMeters];
        //Get the average volumn  [recorder averagePowerForChannel:0];
        //Get the maximum volumn  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [[EMAudioRecorderUtil recorder] peakPowerForChannel:0]));
        ret = lowPassResults;
    }
    
    return ret;
}
@end
