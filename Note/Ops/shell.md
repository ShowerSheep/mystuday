# Shell

阮一峰《Bash 脚本教程》

https://wangdoc.com/bash/

## 一、简介

### 1. Shell 含义

> 首先，Shell 是一个程序，提供一个与用户对话的环境。这个环境只有一个命令提示符，让用户从键盘输入命令，所以又称为命令行环境（command line interface，简写为 CLI）。Shell 接收到用户输入的命令，将命令送入操作系统执行，并将结果返回给用户。本书中，除非特别指明，Shell 指的就是命令行环境。
>
> 其次，Shell 是一个命令解释器，解释用户输入的命令。它支持变量、条件判断、循环操作等语法，所以用户可以用 Shell 命令写出各种小程序，又称为脚本（script）。这些脚本都通过 Shell 的解释执行，而不通过编译。
>
> 最后，Shell 是一个工具箱，提供了各种小工具，供用户方便地使用操作系统的功能。

### 2. Shell 种类

主要的Shell有：

> - Bourne Shell（sh）
> - Bourne Again shell（bash）
> - C Shell（csh）
> - TENEX C Shell（tcsh）
> - Korn shell（ksh）
> - Z Shell（zsh）
> - Friendly Interactive Shell（fish）

最常用的Shell是==Bash==。

查看当前设备的默认Shell

```bash
echo $SHELL
```

 ![image-20220914185525962](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914185525962.png)

查看当前Linux系统安装的所有Shell

```bash
cat /tec/shells
```

 ![image-20220914185750211](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914185750211.png)



## 二、基本语法

### 1. `echo` 命令

`echo`命令作用：在屏幕输出一行文本。

```bash
echo "hello world"
```

 ![image-20220914190418805](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914190418805.png)

输出多行文本加引号。

 ![image-20220914190603847](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914190603847.png)

#### `-n` 参数

> `echo` 默认输出文本末尾有一个回车符。`-n` 参数可以取消末尾回车符。

 ![image-20220914190836081](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914190836081.png)

> `-n`参数可以让两个`echo`命令的输出连在一起，出现在同一行。

 ![image-20220914191020192](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914191020192.png)

#### `-e` 参数

> `-e`参数会解释引号（双引号和单引号）里面的特殊字符（比如换行符`\n`）。如果不使用`-e`参数，即默认情况下，引号会让特殊字符变成普通字符，`echo`不解释它们，原样输出。

```bash
# 不加 -e 参数
echo "hello\nworld"
# 双引号情况
echo -e "hello\nworld"
# 单引号情况
echo -e 'hello\nworld'
```

 ![image-20220914191349290](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220914191349290.png)

`-e`参数把`\n`解释为换行符

### 2. `; `分号

> 分号`;`是命令的结束符，使一行可以放多个命令，上一条命令执行结束在执行第二个命令。
>
> 注意，使用分号时，第二个命令总是接着第一个命令执行，不管第一个命令执行成功或失败。

```bash
clear;ls
```



### 3. 命令组合符`&&`和`||`

```bash
command1 && command2
```

`command1`命令运行==成功==，则继续运行`command2`命令。

```bash
command1 || command2
```

`command1`命令运行==失败==，则继续运行`command2`命令。

例

```bash
cd dir ; ls
```

`cd`命令执行结束，不管成功或失败，都会执行`ls`命令。

```bash
cd dir && ls
```

只有`cd`命令执行成功，才会执行`ls`命令；如果`cd`执行失败，则不会执行`ls`命令。

```bash
mkdir dir1 || mkdir dir2
```

`mkdir dir1`命令执行成功，则不会执行`mkdir dir2`；只有前面执行失败才会执行后面的命令。

## 三、Bash模式扩展（通配符）

### 1. 简介

- `~` 波浪线扩展
- `?` 字符扩展
- `*` 字符扩展
- `[]` 方括号扩展
- `{}` 大括号扩展
- 变量扩展
- 子命令扩展
- 算术扩展

Bash允许用户关闭扩展

```bash
set -o noglob
# 或
set -f
```

重新打开扩展

```bash
set +o noglob
# 或
set +f
```

### 2. `~` 波浪线扩展

`~` 会自动扩展成当前用户家目录

```bash
echo ~
echo ~yang1
echo ~root
```

 ![image-20220916154456200](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916154456200.png)

如果 `~user` 的 `user` 不存在，则不起作用，当成扑通字符串输出

```bash
echo ~frnk
```

 ![image-20220916154705347](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916154705347.png)

`~+` 会扩展成当前所在目录，等同于`pwd`

 ![image-20220916154856085](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916154856085.png)

### 3. `?` 字符扩展

`?` 字符代表任意单个字符

如果匹配多个字符，需要多个`?`

```bash
ls ?.txt
ls ??.txt
```

 ![image-20220916155324624](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916155324624.png)

`??`匹配两个字符

> 如果文件不存在，则按照普通字符输出；`echo` 会输出`?.txt`

### 4. `*` 字符扩展

一个`*` 可以匹配任意多个字符，包括零个字符

### 5. `[]` 方括号扩展

> 方括号扩展的形式是`[...]`，只有文件确实存在的前提下才会扩展。如果文件不存在，就会原样输出。括号之中的任意一个字符。比如，`[aeiou]` 可以匹配五个元音字母中的任意一个。

`[ab]` 可以匹配`a` 或`b`，前提是必须存在。

> 方括号扩展还有两种变体：`[^...]`和`[!...]`。它们表示匹配不在方括号里面的字符，这两种写法是等价的。比如，`[^abc]`或`[!abc]`表示匹配除了`a`、`b`、`c`以外的字符。

```bash
ls ?[!a]?
```

查找文件：3个字符，中间字符不为`a`



### 6. `[start-end]` 扩展

表示一个范围`[a-c]`表示`abc`，`[0-9]` 表示`0123456789`

常用简写例子：

> - `[a-z]`：所有小写字母。
> - `[a-zA-Z]`：所有小写字母与大写字母。
> - `[a-zA-Z0-9]`：所有小写字母、大写字母与数字。
> - `[abc]*`：所有以`a`、`b`、`c`字符之一开头的文件名。
> - `program.[co]`：文件`program.c`与文件`program.o`。
> - `BACKUP.[0-9][0-9][0-9]`：所有以`BACKUP.`开头，后面是三个数字的文件名。

同样有否定形式`[start-end]` 表示匹配不属于这个范围的字符。

`[!a-zA-Z]`表示匹配非英文子母的字符；`[!1-3]`表示排除1 2 3

### 7. `{}` 大括号扩展

> 大括号扩展`{...}`表示分别扩展成大括号里面的所有值，各个值之间使用逗号分隔。比如，`{1,2,3}`扩展成`1 2 3`。

会扩展成所有给定的值，不管是否存在。

大括号内部不能有空格，否则会实效

```bash
echo {1 , 2}
```

这样会输出`{1 , 2}`，扩展实效

如果逗号前面没有值，表示扩展第一项为空

```bash
cp a.log{,.bak}
# 等于
cp a.log a.log.bak
```

大括号可以嵌套

```bash
echo {j{p,pe}g,png}
```

输出为：`jpg jpeg png`

```bash
echo a{A{1,2},B{3,4}}b
```

输出为：`aA1b aA2b aB3b aB4b`

### 8. {start..end}扩展

> 大括号扩展有一个简写形式`{start..end}`，表示扩展成一个连续序列。比如，`{a..z}`可以扩展成26个小写英文字母。

```bash
echo {a..c}
```

输出为：`a b c`

支持逆序`echo {c..a}`

常见用途，`for`循环

```bash
for i in {1..4}
do
  echo $i
done
```

如果是数字，数字前可以加`0`

```bash
echo {001..5}
echo {001..100}
```

使用两个双点号`{start..end..step}`

```bash
echo {0..10..2}
```

输出为`0 2 4 6 8 10`

多个简写形式连用

```bash
echo {a..c}{1..3}
```

输出为：`a1 a2 a3 b1 b2 b3 c1 c2 c3`

### 9. `$` 变量扩展

Bash 将美元符号`$`开头的词元视为变量，将其扩展成变量值

```bash
echo $SHELL
echo ${SHELL}
```

变量名除了放在美元符号后面，也可以放在`${}`里面。

`${!string*}`或`${!string@}`返回所有匹配给定字符串`string`的变量名。

```
echo ${!S*}
```

输出结果：`SECONDS SHELL SHELLOPTS SHLVL SSH_AGENT_PID SSH_AUTH_SOCK`

上面例子中，`${!S*}`扩展成所有以`S`开头的变量名。

### 10. 子命令扩展

`$(...)`可以扩展成另一个命令的运行结果，该命令的所有输出都会作为返回值。

```bash
echo $(date)
```

输出结果：`Fri Sep 16 17:16:10 CST 2022`

`$(date)`返回`date`命令的运行结果

> `$(...)`可以嵌套，比如`$(ls $(pwd))`。

### 11. 算术扩展

`$((...))`可以扩展成整数运算的结果

```bash
echo $((2 + 2))
```

## 四、引号和转义

### 1. 转义

某些字符在 Bash 里面有特殊含义（比如`$`、`&`、`*`）。

```bash
echo $date
```

输出为空`$`符号不会输出

```bash
echo \$date
```

`\`转义字符，使其编程扑通字符。

 ![image-20220916183905490](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916183905490.png)

反斜杠本身也是特殊字符，如果想要原样输出反斜杠，就需要对它自身转义，连续使用两个反斜线（`\\`）。

```bash
echo \\
```

> 反斜杠除了用于转义，还可以表示一些不可打印的字符。
>
> - `\a`：响铃
> - `\b`：退格
> - `\n`：换行
> - `\r`：回车
> - `\t`：制表符

如果想要在命令行使用这些不可打印的字符，可以把它们放在引号里面，然后使用`echo`命令的`-e`参数。

```bash
echo a\tb

echo -e "a\tb"
```

 ![image-20220916184436590](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916184436590.png)

### 2. 单引号

Bash 允许字符串放在单引号或双引号之中，加以引用。

单引号用于保留字符的字面含义，各种特殊字符在单引号里面，都会变为普通字符，比如星号（`*`）、美元符号（`$`）、反斜杠（`\`）等。

```bash
echo '*'

echo '$USER'

echo '$((2+2))'

echo '$(echo foo)'
```

 ![image-20220916184721297](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916184721297.png)

> 由于反斜杠在单引号里面变成了普通字符，所以如果单引号之中，还要使用单引号，不能使用转义，需要在外层的单引号前面加上一个美元符号（`$`），然后再对里层的单引号转义。

```bash
# 错误
echo it's
# 错误
echo 'it\'s'
# 正确
echo $'it\'s'
```

 ![image-20220916185051038](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916185051038.png)

更合理的方式是在双引号之中使用单引号。

```bash
echo "it's"
```

### 3. 双引号

双引号比单引号宽松，大部分特殊字符在双引号里面，都会失去特殊含义，变成普通字符。

```bash
echo "*"
```

但是，三个特殊字符除外：美元符号（`$`）、反引号（   ）和反斜杠（`\`）。这三个字符在双引号之中，依然有特殊含义，会被 Bash 自动扩展。

```bash
echo "$SHELL"

echo "`date`"
```

 ![image-20220916185341535](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916185341535.png)

上面例子中，美元符号（`$`）和反引号（```）在双引号中，都保持特殊含义。美元符号用来引用变量，反引号则是执行子命令。

```bash
echo "I'd say: \"hello! \""

echo "\\"
```

 ![image-20220916190347885](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220916190347885.png)

### 4. Here文档

Here 文档（here document）是一种输入多行字符串的方法，格式如下。

```bash
<< token
text
token
```

下面是一个通过 Here 文档输出 HTML 代码的例子。

```bash
cat << EOF
<html>
<head>
    <title>
    The title of your page
    </title>
</head>

<body>
    Your page content goes here.
</body>
</html>
EOF
```

## 五、变量

### 1. 简介

#### 环境变量

环境变量是 Bash 环境自带的变量，进入 Shell 时已经定义好了，可以直接使用。它们通常是系统定义好的，也可以由用户从父 Shell 传入子 Shell。

`env`命令或`printenv`命令，可以显示所有环境变量。

```bash
env
printenv
```

常见的环境变量

- `BASHPID`：Bash 进程的进程 ID。
- `BASHOPTS`：当前 Shell 的参数，可以用`shopt`命令修改。
- `DISPLAY`：图形环境的显示器名字，通常是`:0`，表示 X Server 的第一个显示器。
- `EDITOR`：默认的文本编辑器。
- `HOME`：用户的主目录。
- `HOST`：当前主机的名称。
- `IFS`：词与词之间的分隔符，默认为空格。
- `LANG`：字符集以及语言编码，比如`zh_CN.UTF-8`。
- `PATH`：由冒号分开的目录列表，当输入可执行程序名后，会搜索这个目录列表。
- `PS1`：Shell 提示符。
- `PS2`： 输入多行命令时，次要的 Shell 提示符。
- `PWD`：当前工作目录。
- `RANDOM`：返回一个0到32767之间的随机数。
- `SHELL`：Shell 的名字。
- `SHELLOPTS`：启动当前 Shell 的`set`命令的参数，参见《set 命令》一章。
- `TERM`：终端类型名，即终端仿真器所用的协议。
- `UID`：当前用户的 ID 编号。
- `USER`：当前用户的用户名。

> Bash 变量名区分大小写，`HOME`和`home`是两个不同的变量。

查看单个环境变量的值，可以使用`printenv`命令或`echo`命令。

```bash
printenv PATH
echo $PATH
```

> 注意，`printenv`命令后面的变量名，不用加前缀`$`。



#### 自定义变量

`set`命令可以显示所有变量（包括环境变量和自定义变量），以及所有的 Bash 函数。

```bash
set
```

### 2.创建变量

用户创建变量的时候，变量名必须遵守下面的规则。

- 字母、数字和下划线字符组成。
- 第一个字符必须是一个字母或一个下划线，不能是数字。
- 不允许出现空格和标点符号。

> 注意，等号两边不能有空格。
>
> 如果变量的值包含空格，则必须将值放在引号中。
>
> 等号左边是变量名，右边是变量。

```bash
FILEPATH="/etc/sysconfig/network-scripts/ifcfg-ens33"
```

变量可以重复赋值，后面的赋值会覆盖前面的赋值。

### 3. 读取变量

读取变量的时候，直接在变量名前加上`$`就可以了。

```bash
a=123
echo $a
```

如果变量不存在，Bash 不会报错，而会输出空字符。

```bash
echo The total is $100.00
echo The total is \$100.00
```

上面命令的原意是输入`$100`，但是 Bash 将`$1`解释成了变量，该变量为空，因此输入就变成了`00.00`。所以，如果要使用`$`的原义，需要在`$`前面放上反斜杠，进行转义。

读取变量的时候，变量名也可以使用花括号`{}`包围，比如`$a`也可以写成`${a}`。这种写法可以用于变量名与其他字符连用的情况。

```bash
a=123
echo $a_num
echo ${a}_num
```

 ![image-20220917093545629](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220917093545629.png)

如果变量的值本身也是变量，可以使用`${!varname}`的语法，读取最终的值。

```bash
myvar=USER
echo ${!myvar}
```

 ![image-20220917093812813](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220917093812813.png)

> 如果变量值包含连续空格（或制表符和换行符），最好放在双引号里面读取。

### 4. 删除变量

`unset`命令用来删除一个变量。

```bash
unset myvar
```

> 不存在的 Bash 变量一律等于空字符串，所以即使`unset`命令删除了变量，还是可以读取这个变量，值为空字符串。

所以，删除一个变量，也可以将这个变量设成空字符串。

```bash
foo=''
foo=
```

### 5. `export` 输出变量

> 用户创建的变量仅可用于当前 Shell，子 Shell 默认读取不到父 Shell 定义的变量。为了把变量传递给子 Shell，需要使用`export`命令。这样输出的变量，对于子 Shell 来说就是环境变量。

`export`命令用来向子 Shell 输出变量。

```bash
a=123
export a
```

```bash
export a=123
```

上面命令执行后，当前 Shell 及随后新建的子 Shell，都可以读取变量`$a`。

子 Shell 如果修改继承的变量，不会影响父 Shell。

```bash
export a=123
bash	# 新建子shell
echo $a
a=456
exit	# 退出子shell
echo a
```

 ![image-20220917094709488](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220917094709488.png)

子shell修改了环境变量`$a`，对父shell没有影响

### 6. 特殊变量

#### `$?`

`$?`为上一个命令的退出码，用来判断上一个命令是否执行成功。返回值是`0`，表示上一个命令执行成功；如果不是零，表示上一个命令执行失败。

```bash
ls doesnotexist
echo $?
```

上面例子中，`ls`命令查看一个不存在的文件，导致报错。`$?`为1，表示上一个命令执行失败。

####  `$$`

`$$`为当前 Shell 的进程 ID。

```bash
echo $$
```

这个特殊变量可以用来命名临时文件。

```bash
LOGFILE=/tmp/output_log.$$
```

#### `$_`

`$_`为上一个命令的最后一个参数。

```bash
ls /etc/sysconfig/network-scripts/ifcfg-ens33
echo $_
```

 ![image-20220920095534066](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920095534066.png)

#### `$!`

`$!`为最近一个后台执行的异步命令的进程 ID。

```bash
sleep 3000 &	# 放到后台运行
echo $!	# 返回进程ID
```

####  `$0`

`$0`为当前 Shell 的名称（在命令行直接执行时）或者脚本名（在脚本中执行时）。

```bash
echo $0
```

返回`-bash`、`zsh` 等

#### `$-`

`$-`为当前 Shell 的启动参数。

```bash
echo $-
```

输出为`himBH`等

#### `$@`和`$#`

`$#`表示脚本的参数数量，`$@`表示脚本的参数值

### 7. 变量替换

Bash 提供四个特殊语法，跟变量的默认值有关，目的是保证变量不为空。

```bash
${parameter:-word}
```

如果变量`parameter`存在且不为空，则返回它的值，否则返回`word`值。目的：返回一个默认值。

```bash
${parameter:=word}
```

如果变量`parameter`存在且不为空，则返回它的值，否则将它设置为`word`并且返回`word`。目的是设置变量的默认值。

```bash
${parameter:+word}
```

如果变量`parameter`存在且不为空，则返回它的值，否则返回空值。目的测试变量是否存在。

### 8. `declare`命令

https://wangdoc.com/bash/variable.html#declare-%E5%91%BD%E4%BB%A4



### 9. `readonly` 命令

https://wangdoc.com/bash/variable.html#readonly-%E5%91%BD%E4%BB%A4



### 10. `let` 命令

`let`命令声明变量时，可以直接执行算术表达式。

```bash
let foo=1+2
echo $foo
```

如果包含空格，使用引号

```bash
let "foo = 1 + 2"
```



## 六、字符串

### 1. 字符串长度

语法

```bash
${#varname}
```

大括号必须加，否则会识别为`$#`

### 2. 子字符串

语法

```bash
${varname:offset:length}
```

从`offset`开始，截取`length`长度。`length`为空时，从`offset`开始截取到最后。

```bash
count=frogfootman
echo ${count:4:4}
```

输出为：`foot`

```bash
$ foo="This string is long."
$ echo ${foo: -5}
long.
$ echo ${foo: -5:2}
lo
$ echo ${foo: -5:-2}
lon
```



### 3. 搜索和替换

#### 字符串头部的模式匹配

格式：

```bash
${variable#keywords}
${variable##keywords}
```

例

```bash
path=/etc/sysconfig/network-scripts/ifcfg-ens33
echo ${path#/*}
echo ${path##/*}

echo ${path#/*/}
echo ${path##/*/}
```

 ![image-20220920163943546](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920163943546.png)

#### 字符串尾部的模式匹配

```bash
${variable%keywords}
${variable%%keywords}
```

例

```bash
path=/etc/sysconfig/network-scripts/ifcfg-ens33
echo ${path%-*}
echo ${path%%-*}

echo ${path%/*}
echo ${path%%/*}
```

 ![image-20220920164537052](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920164537052.png)



### 4. 改变大小写

改变变量大小写

```bash
${varname^^}
${varname,,}
```

例

```bash
$ foo=heLLo
$ echo ${foo^^}
HELLO
$ echo ${foo,,}
hello
```





## 七、算术运算

### 1. 算术表达式

`((...))`语法可以进行整数的算术运算

```bash
((foo = 5 + 5))
echo $foo
```

> `((...))`会自动忽略空格，中间有没有空格都正确。

`((...))`语法支持的算术运算符如下。

- `+`：加法
- `-`：减法
- `*`：乘法
- `/`：除法（整除）
- `%`：余数
- `**`：指数
- `++`：自增运算（前缀或后缀）
- `--`：自减运算（前缀或后缀）

> 注意，除法运算符的返回结果总是整数，比如`5`除以`2`，得到的结果是`2`，而不是`2.5`。
>
> 只能计算整数，否则会报错。

### 2. 逻辑运算

`$((...))`支持以下的逻辑运算符。

- `<`：小于
- `>`：大于
- `<=`：小于或相等
- `>=`：大于或相等
- `==`：相等
- `!=`：不相等
- `&&`：逻辑与
- `||`：逻辑或
- `!`：逻辑否

- `expr1?expr2:expr3`：三元条件运算符。若表达式`expr1`的计算结果为非零值（算术真），则执行表达式`expr2`，否则执行表达式`expr3`。

```bash
echo $((3 > 2))
echo $(( (3 > 2) || (4 <= 1) ))
```

三元运算符

```bash
$ a=0
$ echo $((a<1 ? 1 : 0))
1
$ echo $((a>1 ? 1 : 0))
0
```

### 3. `expr` 运算

`expr`命令支持算术运算

```bash
expr 3 + 2
```

支持变量替换

```bash
foo=3
expr $foo + 2
```

> 不支持非整数参数

### 4. `let` 命令

将算术运算的结果，赋予一个变量

```bash
let x=2+3
echo $x
```

> 注意，`x=2+3`这个式子里面不能有空格，否则会报错。



## 八、脚本入门

### 1. Shebang 行

脚本的第一行通常是指定解释器，即这个脚本必须通过什么解释器执行。这一行以`#!`字符开头，这个字符称为 Shebang，所以这一行就叫做 Shebang 行。

`#!`后面就是脚本解释器的位置，Bash 脚本的解释器一般是`/bin/sh`或`/bin/bash`。

```bash
#!/bin/sh
# 或
#!/bin/bash
```

`#!`与脚本解释器之间有没有空格，都是可以的。

如果 Bash 解释器不放在目录`/bin`，脚本就无法执行了。为了保险，可以写成下面这样。

```bash
#!/usr/bin/env bash
```

上面命令使用`env`命令（这个命令总是在`/usr/bin`目录），返回 Bash 可执行文件的位置。

Shebang 行不是必需的，但是建议加上这行。如果缺少该行，就需要手动将脚本传给解释器。举例来说，脚本是`script.sh`，有 Shebang 行的时候，可以直接调用执行。

```bash
$ ./script.sh
```

上面例子中，`script.sh`是脚本文件名。脚本通常使用`.sh`后缀名，不过这不是必需的。

如果没有 Shebang 行，就只能手动将脚本传给解释器来执行。

```bash
/bin/sh ./script.sh
# 或者
bash ./script.sh
```

### 2. 执行权限和路径

只要指定了 Shebang 行的脚本，可以直接执行。这有一个前提条件，就是脚本需要有执行权限。可以使用下面的命令，赋予脚本执行权限。

```bash
# 给所有用户执行权限
chmod +x script.sh

# 给所有用户读权限和执行权限
chmod +rx script.sh
# 或者
chmod 755 script.sh

# 只给脚本拥有者读权限和执行权限
chmod u+rx script.sh
```

脚本的权限通常设为`755`（拥有者有所有权限，其他人有读和执行权限）或者`700`（只有拥有者可以执行）。

### 3. `env` 命令



### 4. 注释

Bash 脚本中，`#`表示注释，可以放在行首，也可以放在行尾。



### 5. 脚本参数

调用脚本的时候，脚本文件名后面可以带有参数。

```bash
script.sh word1 word2 word3
```

`script.sh`是一个脚本文件，`word1`、`word2`和`word3`是三个参数。

脚本文件内部，可以使用特殊变量，引用这些参数。

- `$0`：脚本文件名，即`script.sh`。
- `$1`~`$9`：对应脚本的第一个参数到第九个参数。
- `$#`：参数的总数。
- `$@`：全部的参数，参数之间使用空格分隔。
- `$*`：全部的参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。

> 注意，如果命令是`command -o foo bar`，那么`-o`是`$1`，`foo`是`$2`，`bar`是`$3`。

例

```bash
#!/bin/bash
# script.sh

echo "全部参数：" $@
echo "命令行参数数量：" $#
echo '$0 = ' $0
echo '$1 = ' $1
echo '$2 = ' $2
echo '$3 = ' $3
```

 ![image-20220920173252644](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920173252644.png)

用户可以输入任意数量的参数，利用`for`循环，可以读取每一个参数。

```bash
#!/bin/bash

for i in "$@"; do
  echo $i
done
```

`$@`返回一个全部参数的列表，然后使用`for`循环遍历。

如果多个参数放在双引号里面，视为一个参数.。

```bash
./script.sh "a b"
```

Bash 会认为`"a b"`是一个参数，`$1`会返回`a b`。注意，返回时不包括双引号。



## 九、`read` 命令

### 1. 用法

```bash
read [-options] [variable...]
```

`options`是参数选项，`variable`是用来保存输入数值的一个或多个变量名。如果没有提供变量名，环境变量`REPLY`会包含用户输入的一整行数据。

例子

```bash
#!/bin/bash

echo -n "输入一些文本 > "
read text
echo "你的输入：$text"
```

 ![image-20220920175509885](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920175509885.png)

`read`可以接受用户输入的多个值。

```bash
#!/bin/bash
echo Please, enter your firstname and lastname
read FN LN
echo "Hi! $LN, $FN !"
```

 ![image-20220920175723679](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920175723679.png)

如果`read`命令之后没有定义变量名，那么环境变量`REPLY`会包含所有的输入。

```bash
#!/bin/bash
# read-single: read multiple values into default variable
echo -n "Enter one or more values > "
read
echo "REPLY = '$REPLY'"
```

 ![image-20220920184758660](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920184758660.png)

`read`命令除了读取键盘输入，可以用来读取文件。

```bash
#!/bin/bash

filename='/etc/hosts'

while read myline
do
  echo "$myline"
done < $filename
```

![image-20220920184952665](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920184952665.png)

上面的例子通过`read`命令，读取一个文件的内容。`done`命令后面的定向符`<`，将文件内容导向`read`命令，每次读取一行，存入变量`myline`，直到文件读取完毕。

### 2. 参数

#### `-t` 参数

`read`命令的`-t`参数，设置了超时的秒数。如果超过了指定时间，用户仍然没有输入，脚本将放弃等待，继续向下执行。

```bash
#!/bin/bash

echo -n "输入一些文本 > "
if read -t 3 response; then
  echo "用户已经输入了"
else
  echo "用户没有输入"
fi
```

输入命令会等待3秒，如果用户超过这个时间没有输入，这个命令就会执行失败。`if`根据命令的返回值，转入`else`代码块，继续往下执行。

环境变量`TMOUT`也可以起到同样作用，指定`read`命令等待用户输入的时间（单位为秒）。

```bash
TMOUT=3
read response
```

上面例子也是等待3秒，如果用户还没有输入，就会超时。

#### `-p` 参数

指定用户输入的提示信息

```bash
read -p "Enter one or more values > "
echo "REPLY = '$REPLY'"
```

上面例子中，先显示`Enter one or more values >`，再接受用户的输入。

#### `-a` 参数

把用户的输入赋值给一个数组，从0号位置开始。

```bash
read -a people
# 输入数组成员
echo ${people[2]}
```

 ![image-20220920185723836](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920185723836.png)

#### `-n` 参数

只读取若干隔字符作为变量值，而不是整行读取。

```bash
read -n 3 letter
# 输入字符串
echo $letter
```

 ![image-20220920190009332](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920190009332.png)

#### `-e` 参数

`-e`参数允许用户输入的时候，使用`readline`库提供的快捷键，比如自动补全。

```bash
#!/bin/bash

echo Please input the path to the file:

read -e fileName

echo $fileName
```

上面例子中，`read`命令接受用户输入的文件名。这时，用户可能想使用 Tab 键的文件名“自动补全”功能，但是`read`命令的输入默认不支持`readline`库的功能。`-e`参数就可以允许用户使用自动补全。

#### 其他参数

- `-d delimiter`：定义字符串`delimiter`的第一个字符作为用户输入的结束，而不是一个换行符。
- `-r`：raw 模式，表示不把用户输入的反斜杠字符解释为转义字符。
- `-s`：使得用户的输入不显示在屏幕上，这常常用于输入密码或保密信息。
- `-u fd`：使用文件描述符`fd`作为输入。

### 3. IFS 变量

`read`命令读取的值，默认是以空格分隔。可以通过自定义环境变量`IFS`（内部字段分隔符，Internal Field Separator 的缩写），修改分隔标志。

`IFS`的默认值是空格、Tab 符号、换行符号，通常取第一个（即空格）。

如果把`IFS`定义成冒号（`:`）或分号（`;`），就可以分隔以这两个符号分隔的值，这对读取文件很有用。

```bash
#!/bin/bash
# read-ifs: read fields from a file

FILE=/etc/passwd

read -p "Enter a username > " user_name
file_info="$(grep "^$user_name:" $FILE)"

if [ -n "$file_info" ]; then
  IFS=":" read user pw uid gid name home shell <<< "$file_info"
  echo "User = '$user'"
  echo "UID = '$uid'"
  echo "GID = '$gid'"
  echo "Full Name = '$name'"
  echo "Home Dir. = '$home'"
  echo "Shell = '$shell'"
else
  echo "No such user '$user_name'" >&2
  exit 1
fi
```

 ![image-20220920190407187](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920190407187.png)

上面例子中，`IFS`设为冒号，然后用来分解`/etc/passwd`文件的一行。`IFS`的赋值命令和`read`命令写在一行，这样的话，`IFS`的改变仅对后面的命令生效，该命令执行后`IFS`会自动恢复原来的值。如果不写在一行，就要采用下面的写法。

```bash
OLD_IFS="$IFS"
IFS=":"
read user pw uid gid name home shell <<< "$file_info"
IFS="$OLD_IFS"
```

另外，上面例子中，`<<<`是 Here 字符串，用于将变量值转为标准输入，因为`read`命令只能解析标准输入。

如果`IFS`设为空字符串，就等同于将整行读入一个变量。

```bash
#!/bin/bash
input="/path/to/txt/file"
while IFS= read -r line
do
  echo "$line"
done < "$input"
```

上面的命令可以逐行读取文件，每一行存入变量`line`，打印出来以后再读取下一行。



## 十、条件判断

### 1. if 结构

```bash
if commands; then
  commands
[elif commands; then
  commands...]
[else
  commands]
fi
```

这个命令分成三个部分：`if`、`elif`和`else`。其中，后两个部分是可选的。

`if`和`then`写在同一行时，需要分号分隔。分号是 Bash 的命令分隔符。它们也可以写成两行，这时不需要分号。

```bash
if true
then
  echo 'hello world'
fi
if false
then
  echo 'it is false' # 本行不会执行
fi
```

除了多行的写法，`if`结构也可以写成单行。

```bash
if true; then echo 'hello world'; fi
# hello world
if false; then echo "It's true."; fi
```

> 注意，`if`关键字后面也可以是一条命令，该条命令执行成功（返回值`0`），就意味着判断条件成立。

`if` 后面可以跟任意数量的命令。这时，所有命令都会执行，但是判断真伪只看最后一个命令，即使前面所有命令都失败，只要最后一个命令返回 `0`，就会执行`then`的部分。

```bash
if flase;true; then echo "hello world"; fi
# hello world
```

`if` 后面有两条命令（ `flase;true;` ），第二条命令（ `true` ）决定 `then` 的部分是否会执行。



### 2. `test` 命令

`if`结构的判断条件，一般使用`test`命令，有三种形式。

```bash
# 写法一
test expression
# 写法二
[ expression ]
# 写法三
[[ expression ]]
```

三种形式都是等价的，第三种还支持正则判断，前两种不支持。

上面的`expression`是一个表达式。这个表达式为真，`test`命令执行成功（返回值为`0`）；表达式为伪，`test`命令执行失败（返回值为`1`）。注意，第二种和第三种写法，`[`和`]`与内部的表达式之间必须有空格。

例

```bash
# 写法一
if test -e /tmp/foo.txt ; then
  echo "Found foo.txt"
fi
# 写法二
if [ -e /tmp/foo.txt ] ; then
  echo "Found foo.txt"
fi
# 写法三
if [[ -e /tmp/foo.txt ]] ; then
  echo "Found foo.txt"
fi
```

### 3. 判断表达式

#### 数字判断
​    -eq(equal) 等于
​    -ne(not equal) 不等于
​    -ge(Greater than or equal to) 大于等于 
​    -le(Less than or equal to) 小于等于 
​    -gt(greater than) 大于
​    -lt(less than) 小于 

#### 文件判断
test
    -f #存在且是正规文件 
    -d #存在且是目录
    -h 存在且是符号链接 
    -b 块设备
    -c 字符设备
    -e #文件存在

#### test判断的逻辑运算

通过逻辑运算，可以把多个`test`判断表达式结合起来，创造更复杂的判断。三种逻辑运算`AND`，`OR`，和`NOT`，都有自己的专用符号。

- `AND`运算：符号`&&`，也可使用参数`-a`。
- `OR`运算：符号`||`，也可使用参数`-o`。
- `NOT`运算：符号`!`。



#### 算术判断

Bash 还提供了`((...))`作为算术条件，进行算术运算的判断。

```bash
if ((3 > 2)); then
  echo "true"
fi
```

#### case 结构

语法结构

```bash
case expression in
  pattern )
    commands ;;
  pattern )
    commands ;;
  ...
esac
```



例

```bash
#!/bin/bash
echo -n "输入一个1到3之间的数字（包含两端）> "
read character
case $character in
  1 ) echo 1
    ;;
  2 ) echo 2
    ;;
  3 ) echo 3
    ;;
  * ) echo 输入不符合要求
esac
```

```bash
#!/bin/bash
OS=$(uname -s)
case "$OS" in
  FreeBSD) echo "This is FreeBSD" ;;
  Darwin) echo "This is Mac OSX" ;;
  AIX) echo "This is AIX" ;;
  Minix) echo "This is Minix" ;;
  Linux) echo "This is Linux" ;;
  *) echo "Failed to identify this OS" ;;
esac
```

`case`的匹配模式可以使用各种通配符，下面是一些例子。

- `a)`：匹配`a`。
- `a|b)`：匹配`a`或`b`。
- `[[:alpha:]])`：匹配单个字母。
- `???)`：匹配3个字符的单词。
- `*.txt)`：匹配`.txt`结尾。
- `*)`：匹配任意输入，通过作为`case`结构的最后一个模式。



## 十一、循环

### 1. `for ... in` 循环

遍历列表中的每一项

```bash
for variable in list
do
  commands
done
```

例

```bash
#!/bin/bash

for i in word1 word2 word3
do
	echo $1
done
```

列表可以由通配符产生

```bash
for i in *.png
do
	ls -l $i
done
```



### 2. `for` 循环

结构

```sell
for (( expression1; expression2; expression3 )); do
  commands
done
```

支持C语言循环算法

```bash
#!/bin/bash
for (( i=1; i <= 5; i++ ))
do
	echo "$i"
done
```

```bash
for ((;;))
do
  read var
  if [ "$var" = "." ]; then
    break
  fi
done
```

反复读取命令行输入，直到输入了一个 `.` 跳出整个循环

### 3. `while` 循环

语法结构

```bash
while condition; do
  commands
done
```

例

```bash
#!/bin/bash
number=0
while [ "$number" -lt 10 ]; do
  echo "Number = $number"
  number=$((number + 1))
done
```

只要变量`$number`小于10，就会不断加1，直到`$number`等于10，然后退出循环。

```bash
while true
do
  echo 'Hello World';
done
```

死循环

### 4. `until` 循环

与 `while` 相反，不符合条件继续循环，复合条件跳出循环。

```bash
until condition; do
  commands
done
```

### 5. 循环控制

> shift	continue	break	exit

#### `shift` 

`shift`命令可以改变脚本参数，每次执行都会移除脚本当前的第一个参数（`$1`），使得后面的参数向前一位。

```bash
#!/bin/bash

echo "一共输入了 $# 个参数"

while [ "$1" != "" ]; do
  echo "剩下 $# 个参数"
  echo "参数：$1"
  shift
done
```

 ![image-20220920174910897](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220920174910897.png)

#### `break`

条件成立跳出整个循环

```bash
#!/usr/bin/bash
for i in {1..10}
do
if [ $i -eq 7 ];then
        #continue	# 不会输出7
        #break	# 输出1-6
        #exit 34	# 到7退出脚本
else
        echo $i
fi
echo "本次输出结束"
done
echo "脚本结束循环"
```



#### `continue`

条件成立不执行下面代码，跳出本次循环，进行下一次循环



#### `exit`

退出脚本



## 十二、函数

### 1. 简介

用法

```bash
# 第一种
fn() {
  # codes
}
# 第二种
function fn() {
  # codes
}
```

### 2. 参数变量

函数体内可以使用参数变量，获取函数参数。函数的参数变量，与脚本参数变量是一致的。

- `$1`~`$9`：函数的第一个到第9个的参数。
- `$0`：函数所在的脚本名。
- `$#`：函数的参数总数。
- `$@`：函数的全部参数，参数之间使用空格分隔。
- `$*`：函数的全部参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。

如果函数的参数多于9个，那么第10个参数可以用`${10}`的形式引用，以此类推。

```bash
#!/bin/bash
# test.sh
function alice {
  echo "alice: $@"	# 函数全部参数
  echo "$0: $1 $2 $3 $4"
  echo "$# arguments"	# 函数参数总数
}
alice in wonderland
```

 ![image-20220922170718811](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220922170718811.png)



## 十三、数组

### 1.创建数组

数组采用逐个赋值的方法创建

```bash
array[index]=values
```

创建三个成员的数组

```bash
array[0]=val
array[1]=val
array[3]=val
```

一次性赋值的方式

```bash
array=(value1 value2 ... valueN)
```

```bash
days=([0]=Sun [1]=Mon [2]=Tue [3]=Wed [4]=Thu [5]=Fri [6]=Sat)
```

只指定某些值，也是可以的

```bash
names=(tom [5]=arry frank)
```

这样定义数组时，`tom`是0号位置，`arry`是5号位置，`frank`是6号位置。

没有赋值的数组元素默认值是空字符串

定义数组时，可以使用通配符。

```bash
mp3s=(*.mp3)
```

将当前目录的所有mp3文件放到一个数组。

先用`declare -a`声明一个数组

```bash
declare -a arrayName
```

`read -a`命令则是将用户的命令行输入，存入一个数组。

```bash
read -a dice
```

将用户的命令输入，存入数组`dice`。

### 2. 读取数组

#### 读取单个元素

读取指定位置元素

```bash
echo ${array[i]}
```



#### 读取所有成员

```bash
echo ${array[@]}
```



### 3. 数组长度

数组长度（一共有多少成员）

```bash
${#array[*]}
${#array[@]}
```



### 4. 提取数组序号

`${!array[@]}`或`${!array[*]}`，可以返回数组的成员序号，即哪些位置是有值的。

```bash
$ arr=([5]=a [9]=b [23]=c)
$ echo ${!arr[@]}
5 9 23
$ echo ${!arr[*]}
5 9 23
```

### 5. 追加数组成员

数组末尾追加成员，可以使用`+=`赋值运算符。它能够自动地把值追加到数组末尾。否则，就需要知道数组的最大序号，比较麻烦。

```bash
$ foo=(a b c)
$ echo ${foo[@]}
a b c

$ foo+=(d e f)
$ echo ${foo[@]}
a b c d e f
```

### 6. 删除数组

删除一个数组成员，使用`unset`命令。

```bash
$ foo=(a b c d e f)
$ echo ${foo[@]}
a b c d e f

$ unset foo[2]
$ echo ${foo[@]}
a b d e f
```

将某个成员设为空值，可以从返回值中“隐藏”这个成员。

> 注意，这里是“隐藏”，而不是删除，因为这个成员仍然存在，只是值变成了空值。







## 十四、正则表达式

正则表达式是表达文本模式的方法

- `.`：匹配任何单个字符。
- `?`：上一项是可选的，最多匹配一次。
- `*`：前一项将被匹配零次或多次。
- `+`：前一项将被匹配一次或多次。
- `{N}`：上一项完全匹配N次。
- `{N，}`：前一项匹配N次或多次。
- `{N，M}`：前一项至少匹配N次，但不超过M次。
- `--`：表示范围，如果它不是列表中的第一个或最后一个，也不是列表中某个范围的终点。
- `^`：匹配行首的空字符串；也代表不在列表范围内的字符。
- `$`：匹配行尾的空字符串。
- `\b`：匹配单词边缘的空字符串。
- `\B`：匹配空字符串，前提是它不在单词的边缘。
- `\<`：匹配单词开头的空字符串。
- `\>`：匹配单词末尾的空字符串。

### 1. 元字符

元字符是表示特殊函数的字符，包括 `^ $ . [ ] { } - ? * + ( ) | \\` 。

除了元字符，其他字符在正则表达式中，都表示原来的含义。

- `.` 匹配任意字符，但不含空字符
- `^` 匹配文本行开头
- `$` 匹配文本行结尾

```bash
示例                      功能                       示例
^                       行首定位符                  ^love 
$                       行尾定位符                  love$ 
.                       匹配单个字符                 l..e  
*                       匹配前导符0到多次            ab*love 
.*                      匹配任意多个字符（贪婪匹配）
[]                      匹配方括号中任意一个字符      [lL]ove
[ - ]                   匹配指定范围内的一个字符      [a-z0-9]ove             
[^]                     匹配不在指定组里的字符        [^a-z0-9]ove
\                       用来转义元字符               love\.
\<                      词首定位符                  \<love
\>                      词尾定位符                  love\>
\(\)                    匹配后的标签
```

扩展元字符

```bash
扩展正则表达式元字符             功能                  示例
+                       匹配一次或多次前导字符        [a-z]+ove
?                       匹配零次或一次前导字符        lo?ve
a|b                     匹配a或b                   love|hate
x{m}                    字符x重复m次               o{5}
x{m,}                   字符x重复至少m次            o{5,}
x{m,n}                  字符x重复m到n次             o{5,10}
()						字符组						love(able|rs)ov ov+ (ov)+
```

### 2. 正则判断

运用正则，判断需要`[[ ]]`

```bash
num1=1
[[ $num1 =~ ^[0-9]+$ ]] && echo "yes" || echo "no"
```

输出：`yes`

> 注意：\^在[]内表示取反，\^在[]外表示以什么开头
>
> ```bash
> num3=1b1
> [[ $num3 =~ ^[0-9]+$ ]] && echo "yes" || echo "no"
> ```
>
> 输出：`no`

小数

```bash
num=1.6
[[ $num =~ ^[0-9]\.[0-9]+$ || $num =~ ^[0-9]+$ ]] && echo "yes" || echo "no"
## 输入的只能是数字(包括小数)
```

输出：`yes`



## 十五、`sed`

文本编辑工具

默认不对源文件操作

### 1. 语法

```bash
sed 选项 命令参数 文件
```

选项：

-r 支持正则式

常用命令参数

p 达因查看文件内容（print）

```bash
sed -r 'p' test.txt
```



### 2. 查找替换

查找替换文件内容

```bash
sed -r 's/root/ROOT/' test.txt
```

查找`test.txt` 文件中的 `root` 替换为 `ROOT` 只替换第一个。

全局替换

```bash
sed -r 's/root/ROOT/g' test.txt
```

`gi` 可以忽略大小写

> 可以使用 `:` 或 `#` 等作为分隔符。
>
> 源文件不变

想让源文件改变，可以使用重定向

```bash
sed -r 's/root/ROOT/g' test.txt > xxx.txt
```

例

关闭seLinux

```bash
sed -r 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
```



### 3. 多重编辑选项 `-f`

使用多个 `-e` 参数

```bash
sed -r -e 's/root/ROOT/' -e 's/bin/BIN/' test.txt
```

 另

```bash
vim s.sed

s/MA/Massachusetts/ 
s/PA/Pennsylvania/ 
s/CA/California/ 
s/VA/Virginia/ 
s/OK/Oklahoma/

sed -f s.sed test.txt	#输出
sed -f s.sed test.txt > newfile.txt	#保存输出
```

先创建想要编辑内容文件，再使用 `-f` 参数引用文件。



### 4. 行定位

```bash
# 输出前5行
sed -n '1,5p' text.txt

# 输出包含指定内容的行
sed -n '/SUSE/p' text.txt

# 输出不包含指定内容的行
sed -n '/SUSE/!p' text.txt
```

可以和查找替换一起使用

```bash
sed -r '1,3s/root/ROOT/' test.txt	# 替换前3行的第一个root
sed -r '1,3s/root/ROOT/g' test.txt	# 前3行的root全部替换
```



### 5. 删除行 `d`

```bash
sed  '1d' test.txt	# 删除第一行
sed  '1,10d' test.txt	# 删除前10行

sed -r '2,$d' passwd	# 删除第2行至末尾


sed -r '1~2d' passwd	# 删除奇数行,间隔两行删除
sed '0~2d' passwd    # 删除偶数行，从0开始间隔2行删除
```

**根据匹配内容删除行**

```bash
sed -r '/^root/d' passwd    # 删除root开头的行
sed -r '/root/d' passwd  # 含有root的行都删除
sed -r '/bash/,3d' passwd  # 匹配到bash行，到此行的第3行删除
```

### 6. `-i`  对源文件操作

```bash
sed -r -i '参数' 文件
```

修改保存为另一个文件

```bash
sed -i.bak 's/nginx/NGINX/g' passwd
```

永久关闭seLinux

```bash
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
```

### 7. 插入行

```bash
sed -r '1iaaaaa' test.txt
```

第1行变成 `aaaaa` 。

 ![image-20220923091942604](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220923091942604.png)

多行插入

```bash
sed -r '2i222222\
> 3333333\
> 4444444' passwd
```



### 8. 修改行内容

```bash
sed -r '4c\asfasdf' passwd
```

多行

```bash
sed -r '4c\11111111\
> aaaaaaaaaa\
> bbbbbbbbb' passwd
```



### 注意

调用变量用双引号

```bash
A=123
echo $A | sed -r 's/$A/456/'
echo $A | sed -r "s/$A/456/"
```

 ![image-20220923092933901](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220923092933901.png)

#### 经典用法

1. 删除配置文件中 # 号注释的行

```bash
sed -ri '/^#/d' ssh_config
```

2. 给文件行添加注释

```bash
sed -r '2,5s/^/#/' passwd
```

3. 给文件行添加和取消注释

```bash
sed -ri s/^#baseurl/baseurl/g   /etc/yum.repos.d/CentOS-Base.repo
sed -r s/^mirrorlist/#mirrorlist/g   /etc/yum.repos.d/CentOS-Base.repo
```

4. 删除配置文件中//号注释行

```bash
sed -r '\#^//#d' passwd
```

5. 删除配置文件中空格或tab键开头的行

```bash
sed -r '\#^[ \t]#d' passwd
```



## 十六、awk

AWK是一种优良的文本处理工具

### 1. 用法

```bash
awk '{print $1 $2 $3 ...}'
```

`$0` 整行输出

分隔符默认是空格，指定分隔符 `-F":"`

```bash
awk -F":" '{print $1, $2}' passwd
```

`NF` 代表一共有多少列

`NR` 代表行

查看系统架构

```bash
uname -a |awk '{print $(NF-1)}'
```

例

```bash
cat passwd | awk -F ":" '{print "username: " $1 " gid: " $4}'
```

 ![image-20220926094616485](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220926094616485.png)



### 2. command

> BEGIN{}                    			 {}               							END{}         		filename
>
> 行处理前的动作          行内容处理的动作     行处理之后的动作    文件名

例

```bash
cat passwd | awk 'BEGIN{print "------"} {print "username: " $1} END{print "ok"}'
```

![image-20220926094158468](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220926094158468.png)



### 3. 相关变量

- $0:表示整行；
- NF : 统计字段的个数
- $NF:是number finally,表示最后一列的信息
- RS：输入记录分隔符；
- ORS：输出记录分隔符。
- NR:打印记录号，（行号）
- FNR：可以分开,按不同的文件打印行号。（多个文件）
- FS : 输入字段分隔符,默认为一个空格。  
- OFS 输出的字段分隔符，默认为一个空格。 
- FILENAME 文件名  被处理的文件名称
- $1  第一个字段，$2第二个字段，依次类推...

例

```bash
cat /etc/passwd | awk 'BEGIN{FS=":"} {print $1,$2}'
cat /etc/passwd | awk -F ":"  '{print $1,$2}'
```

显示行号

```bash
cat /etc/passwd | awk '{print NR,$0}'
```

把文件按行拆开

```bash
cat a.txt | awk 'BEGIN {RS=":"} {print NR,$0}'
```

 ![image-20220926103926855](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220926103926855.png)

```bash
cat b.txt | awk 'BEGIN {RS=" "} {print $0}'
```

 ![image-20220926104216732](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220926104216732.png)

### 4. 关系运算符

> 实现 字符串的完全相等需要使用 `==`
>
> 字符串需要使用双引号
> `!=` 表示不等于

匹配某一个标签

```bash
cat /etc/passwd | awk -F ":" '$1=="root" {print $0}'
```

第一列是 `root` 的整行输出。

```bash
awk -F":" '$1 != "root"' /etc/passwd
```

`!=` 表示不等于

```bash
awk -F":" '$NF == "/bin/bash"' /etc/passwd
```

最后一列是 `/bin/bash` 的输出。

关系运算符有

> `<` 小于  例如  `x<y`
> `>`  大于 `x>y`
> `<=` 小于或等于 `x<=y`
> `==` 等于 `x==y`
> `!=` 不等于 `x!=y`
> `>=` 大于等于 `x>=y`

例

```bash
awk -F":" '$3 == 0' /etc/passwd
awk -F":" '$3 < 10' /etc/passwd
```

> 算术运算：`+`, `-`, `*`, `/`, `%(模:   取余)`,   `^(幂：2^3)`

例

```bash
awk -F: '$3 * 10 > 500' /etc/passwd
```

逻辑操作符和复合模式

> `&&` 逻辑与, 相当于  并且
> `||`逻辑或，相当于 或者
> `!` 逻辑非 , 取反

```bash
awk -F":" '$1~/root/ && $3<=15' /etc/passwd
awk -F":" '$1~/root/ || $3<=15' /etc/passwd
```



### 5. 条件判断

#### if判断

> ++i：从1开始加，赋值在运算
> i++: 从0开始加，运算在赋值
> if语句：
> {if(表达式)｛语句;语句;...｝}

例

```bash
cat /etc/passwd | awk -F":" '{if($3==0) {print $1 " is administrator"}}'
```

显示管理员用户姓名

```bash
cat /etc/passwd | awk -F":" '{if($3>=0 && $3<=1000){i++}} END{print i}'
```

统计系统用户数量

#### for 循环

```bash
awk '{for(i=1;i<=2;i++) {print $0}}' /etc/passwd
```

每行打印两遍

例

改图片名字，把 `stu_01_20220923055045.jpg` 改为 `stu0120220923055045.jpg`。

```bash
touch stu_{01..90}_`date +%Y%m%d%H%M%S`.jpg
```

方法1：

```bash
#!/bin/bash
for i in $(ls stu*.jpg)
do
        NEWNAME=`echo ${i} | awk -F "_" '{print $1$2$3}'`
        mv $i $NEWNAME
done
```

方法2:

```bash
ls stu*.jpg | awk -F "_" '{print "mv " $0 " ", $1$2$3}' | bash
```



## 十七、expect

实现批量修改密码，批量推送ssh的公钥，进行远程ssh连接，任何批量操作的基本都能处理。

安装

```bash
yum -y install expect
```



### 1. 用法

> 用法: 
> 1)定义expect脚本执行的shell
> 		#!/usr/bin/expect     -----类似于#!/bin/bash 
> 2)set timeout 30
> 		设置超时时间30s 
> 3)spawn
> 		spawn是执行expect之后后执行的内部命令开启一个会话 #功能:用来执行shell的交互命令
> 4)expect ---相当于捕捉
> 		功能:判断输出结果是否包含某项字符串(相当于捕捉返回的结果)，没有则会断开，否则等待一段时间后返回，等待通过timeout设置 
> 5)send
> 		执行交互动作，将交互要执行的命令进行发送给交互指令，命令字符串结尾要加上“\r”，#---相当于回车
> 6)interract 
> 		执行完后保持交互状态，需要等待手动退出交互状态，如果不加这一项，交互完成会自动退出
> 7)exp_continue 
> 		继续执行接下来的操作

非交互式ssh连接

创建 `ssh.exp` ，使用 `expect ssh.exp` 执行。

```bash
#!/usr/bin/expect
spawn ssh root@192.168.1.130 # "ls /root"	# 跟要执行的命令

expect {
        "yes/no" {  send "yes\r"; exp_continue }
        "password:" { send "123\r" };
}
expect eof
#interact	# 保持交互状态
```

