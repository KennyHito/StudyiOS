//
//  inject.m
//  helloHook
//
//  Created by KennyHito on 2022/8/25.
//

#import "inject.h"
#import "fishhook.h"
#import "MyPtraceHeader.h"//只是为了可以拿到ptrace头文件等内容

@implementation inject

//原函数指针
int (*ptrace_p)(int _request, pid_t _pid, caddr_t _addr, int _data);
//自定义函数
int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data){
    if (_request == PT_DENY_ATTACH) {//拒接lldb
        return 0;  
    }
    return ptrace_p(_request,_pid,_addr,_data);
}

+ (void)load{
    // fishhook进行交换
    struct rebinding ptraceBd;
    ptraceBd.name = "ptrace";
    ptraceBd.replacement = my_ptrace;
    ptraceBd.replaced = (void *) &ptrace_p;
    struct rebinding bindings[1] = {ptraceBd};
    rebind_symbols(bindings, 1);
}

@end
