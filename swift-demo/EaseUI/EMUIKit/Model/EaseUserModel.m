
#import "EaseUserModel.h"

@implementation EaseUserModel

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super init];
    if (self) {
        _username = username;
        self.nickname = @"";
        self.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
        self.unreadMessageCount = 0;
    }
    
    return self;
}

@end
