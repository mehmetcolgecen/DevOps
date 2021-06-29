x=5
for i in range(x):
    if i == 0 or i == x-1:
        print("#" * x)
    else:
        print("{0}{1}{0}".format('#', (x-2)*" "))
        #print("#" + " "*(x-2) + "#")