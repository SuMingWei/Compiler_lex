# Compiler Scanner(`lex`)

###### tags: `compiler` `lab1`

## Introduction
A scanner for ***µC*** language with lex.

## Enviornment
* For Linux
    * Ubuntu 18.04 LTS
    * Install dependencies:
        ```bash=
        sudo apt install gcc flex bison python3 git
        ```
## Lexical Definitions
![](https://i.imgur.com/PHrEmuF.png)

## How to Debug
* Compile source code and feed the input to your program, then compare with the ground truth.
    ```bash=
    make clean && make
    ./myscanner < input/in01_arithmetic.c >| tmp.out 
    diff -y tmp.out answer/in01_arithmetic.out
    ```
    ![](https://i.imgur.com/Fsn8bmt.png)

## Judge
```bash=
python3 judge/judge.py
```
![](https://i.imgur.com/oaNth23.png)
