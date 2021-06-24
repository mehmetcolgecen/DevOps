import re
class calculator:
    def __init__(self,z=None, x=None, y=None, oper=None):
        self.x = x
        self.y = y
        self.z = z = input("Welcome to the calculator! Please enter an operation:")
        self.oper= oper
        
    def operation(self):
        self.x,self.oper,self.y = re.findall("\d+|[+-/*]", self.z)
        
    def sum(self):
        return int(self.x) + int(self.y)

    def subs(self):
        return int(self.x) - int(self.y)

    def multiply(self):
        return int(self.x) * int(self.y)

    def divide(self):
        return int(self.x) / int(self.y)

    def exe(self):
        self.operation()
        if self.oper == "+":
            return self.sum()
        elif self.oper == "-":
            return self.subs()
        elif self.oper == "*":
            return self.multiply()
        elif self.oper == "/":
            return self.divide()
        else:
            print("Wrong Operator")

mehmet = calculator()

print(mehmet.exe())