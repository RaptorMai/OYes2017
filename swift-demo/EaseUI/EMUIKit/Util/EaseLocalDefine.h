
#ifndef EaseLocalDefine_h
#define EaseLocalDefine_h

#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

#endif /* EaseLocalDefine_h */
