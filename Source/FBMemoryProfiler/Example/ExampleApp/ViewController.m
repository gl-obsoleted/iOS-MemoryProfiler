//
//  ViewController.m
//  testAlloc_demo
//
//  Created by dev on 2016/12/7.
//  Copyright © 2016年 dev. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

double jx3m_usedMemory()
{
    //task_basic_info_data_t taskInfo;
    mach_task_basic_info_data_t taskInfo;
    //mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    mach_msg_type_number_t infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         //TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    //unsigned long long l = [[NSProcessInfo processInfo] physicalMemory];
    //return l / 1024.0 / 1024.0;
    vm_size_t l = taskInfo.resident_size;
    //vm_size_t l = taskInfo.virtual_size;
    double res = l/1024.0/1024.0;
    return res;
}

double jx3m_virtualMemory()
{
    //task_basic_info_data_t taskInfo;
    mach_task_basic_info_data_t taskInfo;
    //mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    mach_msg_type_number_t infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         //TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    //unsigned long long l = [[NSProcessInfo processInfo] physicalMemory];
    //return l / 1024.0 / 1024.0;
    vm_size_t l = taskInfo.virtual_size;
    //vm_size_t l = taskInfo.virtual_size;
    double res = l/1024.0/1024.0;
    return res;
}

double jx3m_availableMemory()
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}


char* pArray[100];
int i = 0;
int size = 20*1024*1024;
void jx3m_alloc()
{
    char* psz = (char*)malloc(size);
    memset(psz,0x0,size);
    pArray[i] = psz;
    i++;
}


void jx3m_write()
{
    for(int j = 0;j < i;j++)
    {
        memset(pArray[j],'*',size-1);
    }
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self create_button: 100 :@selector(button_alloc:) :100 :400 :@"alloc"];
    [self create_button: 100 :@selector(button_write:) :200 :400 :@"write"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor grayColor];
    label.tag = 1;
    [label sizeToFit];
    //设置“添加”label的位置
    label.frame = CGRectMake(50,70, 380,300);
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"";
    label2.font = [UIFont systemFontOfSize:20];
    label2.textColor = [UIColor grayColor];
    label2.tag = 2;
    [label2 sizeToFit];
    //设置“添加”label的位置
    label2.frame = CGRectMake(50,120, 380,300);
    [self.view addSubview:label2];
    
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"";
    label3.font = [UIFont systemFontOfSize:20];
    label3.textColor = [UIColor grayColor];
    label3.tag = 3;
    [label3 sizeToFit];
    //设置“添加”label的位置
    label3.frame = CGRectMake(50,170, 380,300);
    [self.view addSubview:label3];
    
    NSTimer* timer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    
}


- (void)update:(id)userinfo{
    UILabel *label = (UILabel *)[self.view viewWithTag:1];
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"available:%lf",jx3m_availableMemory()]];
    label.text = astring;
    
    UILabel *label2 = (UILabel *)[self.view viewWithTag:2];
    NSString *astring2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"virtual:%lf",jx3m_virtualMemory()]];
    label2.text = astring2;
    
    UILabel *label3 = (UILabel *)[self.view viewWithTag:3];
    NSString *astring3 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"used:%lf",jx3m_usedMemory()]];
    label3.text = astring3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)create_button :(double)width :(SEL)btn_pressed :(double)x :(double)y :(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:btn_pressed forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(x,y , 3*width/4, 35);
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 10.0;
    [self.view addSubview:button];
    return button;
}

-(void)button_alloc:(id)sender
{
    //NSLog(@"used: %lf", jx3m_usedMemory());
    jx3m_alloc();
    
}

-(void)button_write:(id)sender
{
    //NSLog(@"used: %lf", jx3m_usedMemory());
    jx3m_write();
    
}


@end
