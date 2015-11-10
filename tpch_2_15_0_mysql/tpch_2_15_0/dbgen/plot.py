#!/usr/bin/python
import scipy as s
import pylab as py

def makeaverage():
#    value = [[0 for i in range(0,22)] for j in range(0,10)] 
    value = s.zeros(220).reshape((22,10)) # create a 2-dimention array
    total= s.zeros(22)

    average=open('average-pg.log','w')

    for k in range(1,10+1):
        filename='result-1g-pg-hot'+format(k)+'.log'
        fileobject=open(filename,'r')
        for i in range(0,22):
            value[i][k-1]=float(fileobject.readline().strip('\n'))
        fileobject.close()
        
    for i in range(0,22):
        for j in range(0,10):
            total[i]  += value[i][j]
        total[i] = total[i]/10
        print total[i]
        average.write(str(total[i]))  
        average.write('\n')

    average.close()


#auto add the value of the bars
def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        py.text(rect.get_x()+rect.get_width()/2., 1.03*height, '%s' % float(height))


def plotmonetvspg():
    x1=s.linspace(0,22,22,endpoint=False)
    y1=s.loadtxt('average-monet.log')
    y2=s.loadtxt('average-pg.log')
    y3=s.loadtxt('result-mysql.log')
    p1=py.bar(x1,y1,width=0.35)
    p2=py.bar(x1+0.4,y2,width=0.4,color='green')
    p3=py.bar(x1+0.8,y3,width=0.4,color='magenta')
    py.xlabel('queries')
    py.xlim(0,22)
    py.ylabel('reponse time in seconds')
    #py.xticks((p1,p2),('m','p'))
    py.legend((p1,p2,p3),('monetdb','postgresql','mysql'),loc='upper left')
    py.title('TPC-H benchmark with Postgresql and MonetDB')
    py.savefig('monetvspg_mysql.jpg')
     
