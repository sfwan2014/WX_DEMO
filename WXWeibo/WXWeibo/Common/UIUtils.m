//
//  UIUtils.m
//  WXMovie
//
//  Created by wei.chen on 13-9-9.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIUtils.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "ProfileViewController.h"
#import "WebViewController.h"

@implementation UIUtils

+ (NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *local = [NSLocale currentLocale];
    [dateFormatter setLocale:local];
    [dateFormatter setDateFormat:formate];
    NSDate *date = [dateFormatter dateFromString:datestring];
    [dateFormatter release];
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *datestring = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return datestring;
}

+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromString:datestring formate:formate];
    
    NSString *text = [UIUtils stringFromDate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (long long)countDirectorySize:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取到目录下面所有的文件名
    NSArray *fileNames = [fileManager subpathsOfDirectoryAtPath:directory error:nil];
    
    long long sum = 0;
    for (NSString *fileName in fileNames) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        
        NSDictionary *attribute = [fileManager attributesOfItemAtPath:filePath error:nil];
        
        //        NSNumber *filesize = [attribute objectForKey:NSFileSize];
        long long size = [attribute fileSize];
        
        sum += size;
    }
    
    return sum;
}


+ (NSString *)parseSourceText:(NSString *)source {
    NSString *regex = @">\\w+<";
    NSArray *array = [source componentsMatchedByRegex:regex];
    if (array.count > 0) {
        //>新浪微博<
        NSString *s = [array objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = s.length - 2;
        NSString *result = [s substringWithRange:range];
        
        return result;
    }
    
    return nil;
}

+ (NSString *)parseLinkText:(NSString *)text {
    /*
     需要添加超链接的字符串:
     1. @用户
     2. http://www.xxx.com
     3. #话题#
     */
    NSString *regex1 = @"@[\\w]+";  //@用户
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";  //http://www.baidu.com/链接
    NSString *regex3 = @"#[\\w，,]+#";  //#话题#
    NSString *regex4 = @"\\[\\w+\\]";
    NSString *regex = [NSString stringWithFormat:@"%@|%@|%@|%@",regex1,regex2,regex3,regex4];
    
    //微博的内容
    //mutableText = @"转发微博 @张三";
//    NSString *text = _weiboModel.text;
    NSArray *macthArray = [text componentsMatchedByRegex:regex];
    
    //@用户       ---> <a href='user://@用户昵称'>@用户昵称</a>
    //http://    ---> <a href='http://xxx'>http://xxxx</a>
    //#话题#      ---> <a href='topic://话题'>#话题#</a>
    
    for (NSString *linkstring in macthArray) {
        
        //判断字符串是否以@字符开头
        if ([linkstring hasPrefix:@"@"]) { //@用户
            NSString *nickName = linkstring;  //@张三
            
            //截取@字符： @张三 ————> 张三
            nickName = [nickName substringFromIndex:1]; //张三
            
            //中文需要url编码
            NSString *encodeName = [nickName URLEncodedString];
            NSString *replacement = [NSString stringWithFormat:@"<a href='user://%@'>@%@</a>",encodeName,nickName];
            
            //替换字符串，将linkstring替换为replacement
            text = [text stringByReplacingOccurrencesOfString:linkstring withString:replacement];
        }
        else if([linkstring hasPrefix:@"http"]) { //http://url
            NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkstring,linkstring];
            text = [text stringByReplacingOccurrencesOfString:linkstring withString:replacement];
            
        } else if([linkstring hasPrefix:@"#"]) { //#话题#
            NSString *topicText = linkstring;
            //中文需要url编码
            NSString *topicEncode = [linkstring URLEncodedString];
            NSString *replacement = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",topicEncode,topicText];
            
            text = [text stringByReplacingOccurrencesOfString:linkstring withString:replacement];
        }
        //[哈哈] --> <img src='003.png' width=20 height=20>
        else if([linkstring hasPrefix:@"["]) {
            NSString *faceName = linkstring;
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
            
            NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
            NSArray *emotion = [array filteredArrayUsingPredicate:predicate];
            if (emotion.count > 0) {
                NSDictionary *faceItem = [emotion objectAtIndex:0];
                NSString *fileName = [faceItem objectForKey:@"png"];
//                NSString *fileName = @"001.png";
                NSString *replacement = [NSString stringWithFormat:@"<img src=%@ width=20 height=20>",fileName];
                text = [text stringByReplacingOccurrencesOfString:linkstring withString:replacement];
            }
        }
        
    }
    
    return text;
}

+ (void)didSelectLinkWithURL:(NSURL*)url viewController:(UIViewController *)viewCtrl {
    NSString *urlstring = url.absoluteString;
    if ([urlstring hasPrefix:@"user"]) {
        //@用户
        NSString *host = [url host];
        //中文url解码
        NSString *userName = [host URLDecodedString];
        
        ProfileViewController *profile = [[ProfileViewController alloc] init];
        profile.nickName = userName;
        [viewCtrl.navigationController pushViewController:profile animated:YES];
        [profile release];
        
    } else if([urlstring hasPrefix:@"http"]) {
        //http
        //        WXLog(@"url:%@",urlstring);
        
        WebViewController *webCtrl = [[WebViewController alloc] initWithUrl:urlstring];
        [viewCtrl.navigationController pushViewController:webCtrl animated:YES];
        [webCtrl release];
    } else if([urlstring hasPrefix:@"topic"]) {
        //topic
        NSString *host = [url host];
        //中文url解码
        NSString *topicName = [host URLDecodedString];
        WXLog(@"话题：%@",topicName);
    }
}

@end
