//
//  ViewController.m
//  JsonTest
//
//  Created by Dn on 13-4-18.
//  Copyright (c) 2013年 Dn. All rights reserved.
//

#import "ViewController.h"

#import "SBJSON.h"
#import "ASIFormDataRequest.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize cityidLabel,dateLabel,weekLabel,weatherLabel,tempLabel,cityLabel;

- (void)dealloc
{
    [cityidLabel release],[dateLabel release],[weekLabel release],[weatherLabel release],[tempLabel release],[cityLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //解析网址通过ip 获取城市天气代码
    NSURL *url = [NSURL URLWithString:@"http://61.4.185.48:81/g/"];
    
    //    定义一个NSError对象，用于捕获错误信息
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"------------%@",jsonString);
    
    // 得到城市代码字符串，截取出城市代码
    NSString *Str;
    for (int i = 0; i<=[jsonString length]; i++)
    {
        for (int j = i+1; j <=[jsonString length]; j++)
        {
            Str = [jsonString substringWithRange:NSMakeRange(i, j-i)];
            if ([Str isEqualToString:@"id"]) {
                if (![[jsonString substringWithRange:NSMakeRange(i+3, 1)] isEqualToString:@"c"]) {
                    _intString = [jsonString substringWithRange:NSMakeRange(i+3, 9)];
                    NSLog(@"***%@***",_intString);
                }
            }
        }
    }
    
    //中国天气网解析地址；
    NSString *path=@"http://m.weather.com.cn/data/cityNumber.html";
    //将城市代码替换到天气解析网址cityNumber 部分！
    path=[path stringByReplacingOccurrencesOfString:@"cityNumber" withString:_intString];
    
    NSLog(@"path:%@",path);
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:path]];
    
    request.delegate = self;
    [request startAsynchronous];
    
    
    
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"请求开始了");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求结束了");
    //responseString就是response响应的正文内容.(即网页的源代码)
    NSString *str = request.responseString;
    NSLog(@"str is ---> %@",str);

    SBJSON *json = [[SBJSON alloc] init];
    NSDictionary *dic = [json objectWithString:str];
    NSLog(@"dic = %@",dic);
    
    NSDictionary *weatherinfo = [dic objectForKey:@"weatherinfo"];
    NSLog(@"weatherinfo  =  %@",weatherinfo);
    
    //当前城市
    NSString *city = [weatherinfo objectForKey:@"city"];
    cityLabel.text = city;
    //日期
    NSString *date = [weatherinfo objectForKey:@"date_y"];
    dateLabel.text = date;
    //星期
    NSString *week = [weatherinfo objectForKey:@"week"];
    weekLabel.text = week;
    //城市天气编码
    NSString *cityid = [weatherinfo objectForKey:@"cityid"];
    cityidLabel.text = cityid;
    //当前温度
    NSString *temp = [weatherinfo objectForKey:@"temp1"];
    tempLabel.text = temp;
    //当前天气状况
    NSString *weather = [weatherinfo objectForKey:@"weather1"];
    weatherLabel.text = weather;
    
    //更多细节请参考 输出框自己添加！

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败了");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
