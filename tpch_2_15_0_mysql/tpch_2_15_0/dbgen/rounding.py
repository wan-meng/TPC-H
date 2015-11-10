#!/usr/bin/python

def rounding(value):                     
    tmp=float(value)/1000
    return round(tmp,2)

def working(filename):
    numbers=open(filename,'r')
    value=[]
    for item in numbers:
    	value.append(rounding(item))
    numbers.close()

    output=open(filename,'w')
    for item in value:
    	output.write(str(item))
    	output.write('\n')
    output.close()
