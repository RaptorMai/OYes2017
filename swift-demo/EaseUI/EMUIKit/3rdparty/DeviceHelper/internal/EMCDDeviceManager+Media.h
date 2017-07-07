
#import "EMCDDeviceManagerBase.h"

@interface EMCDDeviceManager (Media)

#pragma mark - AudioPlayer

// Play the audio
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;
// Stop playing
- (void)stopPlaying;

- (void)stopPlayingWithChangeCategory:(BOOL)isChange;

-(BOOL)isPlaying;

#pragma mark - AudioRecorder

// Start recording
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                                completion:(void(^)(NSError *error))completion;

// Stop recording
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion;
-(void)cancelCurrentRecording;


-(BOOL)isRecording;

// Get the path of saved data
+ (NSString*)dataPath;

@end
