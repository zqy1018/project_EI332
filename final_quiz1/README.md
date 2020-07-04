# 测试题 1

具体答案见 `final_quiz1.pdf`。

## 要求

在你自己设计完成的单周期和流水线 CPU 基础上，修改或者添加一个地址为 `A8h` 的 32 位输出端口，端口名字定义为你的姓名的全拼。

以如下两段 .mif 文件作为指令和数据存储器初始值，完成对单周期 CPU 和流水线 CPU 的仿真。注意存储器大小与你的设计匹配。

`sc_instmem.mif` 如下。其不应被修改。

```
DEPTH = 64;           % Memory depth and width are required %
WIDTH = 32;           % Enter a decimal number %
ADDRESS_RADIX = HEX;  % Address and value radixes are optional %
DATA_RADIX = HEX;     % Enter BIN, DEC, HEX, or OCT; unless %
                      % otherwise specified, radixes = HEX %
CONTENT
BEGIN
[0..F] : 00000000;   % Range--Every address from 0 to 1F = 00000000 %

0 : 20010000;     
1 : 20020004;   
2 : 200300a8;    
3 : 200a0005;     
4 : 8c240000;  
5 : 8c450000;   
6 : 00a43020;   
7 : ac660000;     
8 : 8c280008;      
9 : 3109000f;  
A : 00094900;  
B : 01095020;    
C : ac6a0000;      
D : 08000008;      
END ;
```

`sc_datamem.mif` 如下。必须修改第三个单元的数据，将你的学号后 8 位直接作为 16 进制数据存入该单元。

```
DEPTH = 32;           % Memory depth、width are required %
WIDTH = 32;           % Enter a decimal number %
ADDRESS_RADIX = HEX;  % Address and value radixes are optional %
DATA_RADIX = HEX;     % Enter BIN, DEC, HEX, or OCT; unless %
CONTENT               % otherwise specified, radixes = HEX %

BEGIN
[0..1F] : 00000000;   % Range--Every address from 0 to 1F = 00000000 %

       0 : 0000AAAA;       %(0) data[0] %
       1 : 55550000;       %(4) data[1] %
       2 : 30910256;       %(8) data[2] change to your student number’s last 8 digits%
       4 : 00000019;       %(10) data[3] %
       5 : 00000012;       %(14) data[4] %
       6 : 00000002;       %(18) data[5] %
       7 : 00000078;       %(1C) data[6] %
       9 : 00000010;       %(24) data[7] %
End ;
```

自行编写仿真激励波形文件，要求如下。
1. CPU 指令周期设置为 10 ns，CPU 复位信号初值为复位有效状态，30 ns 后无效。
2. 必选观测信号：CPU 复位信号、CPU 工作时钟、读取指令存储器时钟、CPU 内部寄存器 R0 至 R10，地址为 `A8h` 的 32 位IO输出端口（也即是说修改后 CPU 模块应该包含自行扩展的地址为 `A8h` 的输出端口）。
3. 建议同时选择观测：指令指针 PC、指令数据 inst、datamem 的读写时钟。

给出指定代码在两个CPU上分别仿真运行 200 ns 和 320 ns 时的 R8、R9、R10 寄存器结果，并截取**仅**含有从 0 ns 开始的 25 个指令时钟周期时间段内的仿真波形。

答案应当包含：
1. 修改后的流水线 CPU 编译结果截图（示例附后，请参阅）。
2. 修改后的单周期 CPU 编译结果截图（示例同上，请参阅）。
3. 仿真运行 200 ns 和 320 ns 时的单周期 CPU 的 R8、R9、R10 寄存器结果。
4. 仿真运行 200 ns 和 320 ns 时的流水线 CPU 的 R8、R9、R10 寄存器结果。
5. 从 0 ns 开始的 25 个指令时钟周期时间段内的单周期 CPU 仿真波形与简单说明。
6. 从 0 ns 开始的 25 个指令时钟周期时间段内的流水线 CPU 仿真波形与简单说明。