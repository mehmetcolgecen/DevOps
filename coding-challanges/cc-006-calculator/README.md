# Coding Challenge - 019: Calculator

The purpose of this coding challenge is to write a program that performs basic calculations (+,-,/,*).

## Learning Outcomes

At the end of this coding challenge, students will be able to;

- Analyze a problem, identify, and apply programming knowledge for an appropriate solution.

- Implement conditional statements effectively to solve a problem.

- Implement loops to solve a problem.

- Execute operations on strings.

- Decompose the problem into sub-problems and solve them distinctly using functions.

- Implement lists and dictionaries to solve a problem.

- Demonstrate their knowledge of algorithmic design principles by solving the problem effectively.

## Problem Statement

In this coding challenge, you are going to create a calculator program. The program should should be able to perform 4 operations: Summation, extraction, multiplication, and division. And you should store the latest result in the result variable. To show that your calculator is working properly, the main part of your program should ask for input operation from the user. This input has to be in the format "Number1OperationNumber2" i.e "6+1","8-4", "55*5"... You should check if the input is valid or not. If the input is not valid, you should ask for input again and print the latest result. You should stop asking for an input when "stop" is entered as an input.

- Expected Output:

```text
Welcome to the calculator! Please enter an operation: 15+6
21
To terminate, enter 'stop'; to continue, enter another operation: 78-62
16
To terminate, enter 'stop'; to continue, enter another operation: 56/8
7.0
To terminate, enter 'stop'; to continue, enter another operation: 98*5
490
To terminate, enter 'stop'; to continue, enter another operation: Hello
490
To terminate, enter 'stop'; to continue, enter another operation: This is an invalid input
490
To terminate, enter 'stop'; to continue, enter another operation: stop
```

## Solution

```python
result =0

def sum(par1,par2):
    return par1+par2

def min(par1,par2):
      return par1 - par2

def mult(par1,par2):
    return par1*par2

def div (par1,par2):
    return par1/par2

def checkValid(input,MyLst):
    par1=False 
    par2=False 
    opr = False
    operands = ["+","-","*","/"]
    MyLst["ParVal1"] = ""
    MyLst["ParVal2"] = ""
    MyLst["OprVal"] = ""

    for i in input:
        asci = ord(i)
        if  not opr and (48 <= asci <= 57):
            par1 = True
            MyLst["ParVal1"] = MyLst["ParVal1"] + i
        elif not opr and i not in operands:
            par1 = False

        if opr and (48<=asci<=57):
            par2= True
            MyLst["ParVal2"] = MyLst["ParVal2"] + i
        elif opr:
            par2 =False

        if i in operands and not opr:
            MyLst["OprVal"] = i
            opr= True

    return (opr and par1 and par2)


op = str(input("Welcome to callulator! Please enter an operation: "))
MyLst = {"ParVal1":"","ParVal2":"","OprVal":""}

while(op != "stop"):
  if checkValid(op,MyLst):
      if MyLst["OprVal"] == "+":
         result = sum(int(MyLst["ParVal1"]),int(MyLst["ParVal2"]))

      if MyLst["OprVal"] == "-":
         result = min(int(MyLst["ParVal1"]),int(MyLst["ParVal2"]))

      if MyLst["OprVal"] == "/":
         result = div(int(MyLst["ParVal1"]),int(MyLst["ParVal2"]))

      if MyLst["OprVal"] == "*":
         result = mult(int(MyLst["ParVal1"]),int(MyLst["ParVal2"]))
  print(result)  

  op = str(input("To terminate, enter 'stop'; to continue, enter another operation: "))
```

## Computational Thinking

### Decomposition

- Create the functions
  - Create the summation function.
  - Create the extraction function.
  - Create the multiplication function.
  - Create the division function.

- Create the input check function
  - There are 3 parts that have to be validated in the input:
    - Number 1 part
    - Operation part
    - Number 2 part

- Create the main part
