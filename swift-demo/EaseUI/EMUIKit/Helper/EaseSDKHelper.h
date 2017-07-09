

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>

#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"

//#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface EaseSDKHelper : NSObject<EMClientDelegate>

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - init Hyphenate

- (void)hyphenateApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt;

#pragma mark - call

@end