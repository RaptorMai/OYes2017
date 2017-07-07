
#import <Foundation/Foundation.h>

@interface EMAudioPlayerUtil : NSObject

+ (BOOL)isPlaying;

// Get the path of what is currently being played
+ (NSString *)playingFilePath;

// Play the audio（wav）from the path
+ (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;

+ (void)stopCurrentPlaying;

@end
