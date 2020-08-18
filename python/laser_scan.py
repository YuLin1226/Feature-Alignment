import numpy as np
from math import acos 
import csv
import matplotlib.pyplot as plt

class Segment():
    def __init__(self):
        '''
        Parameters:
        d_thres : for segmentation of the consecutive data points.
        d_break_thres : for segmentation of the breakpoints. 
        
        '''
        self.d_thres = 5
        self.d_break_thres = 10

        self.seg = []


    def do_segment(self, x, y):
        for i in range(len(x)):
            
            d_sum = 0
            for L in range(len(x)):
                d       = cal_dist( x[0] , y[0] , x[L+1] , y[L+1] )
                d_conti = cal_dist( x[L] , y[L] , x[L+1] , y[L+1] )
                d_sum   = d_sum + d_conti
                
                if (d_sum - d) > self.d_thres or L == (len(x) - 1) or d_conti > self.d_break_thres:
                    
                    self.seg.append([
                        x[0:L+1],
                        y[0:L+1],
                        []
                    ])
                    x = x[L+1 : len(x)]
                    y = y[L+1 : len(y)]

                    break
            if len(x) <= 2:
                self.seg[-1][0] = self.seg[-1][0] + x
                self.seg[-1][1] = self.seg[-1][1] + y
                break
    






def cal_acos(v1, v2):
    '''
    Input:
    v1 : Input vector.
    v2 : Input vector.
    
    Output:
    value : Angle between these two vectors. (unit: rad)
    '''
    d1 = (v1[0]**2 + v1[1]**2)**(0.5)
    d2 = (v2[0]**2 + v2[1]**2)**(0.5)
    
    value = acos( (v1[0]*v2[0]+v1[1]*v2[1])/(d1*d2) )
    return value

def cal_circle(x, y):
    '''
    Input:
    x : List or array which stores 3 data respectively.
    y : List or array which stores 3 data respectively.
    
    Output:
    xc : X coordinate of the center.
    yc : X coordinate of the center.
    R  : Radius of the center.
    '''

    A = np.array([
        [ 2*x[0], 2*y[0], 1 ],
        [ 2*x[1], 2*y[1], 1 ],
        [ 2*x[2], 2*y[2], 1 ]
    ])
    B = np.array([
        [ x[0]**2 + y[0]**2 ],
        [ x[1]**2 + y[1]**2 ],
        [ x[2]**2 + y[2]**2 ]
    ])

    X = np.linalg.solve(A, B)
    xc = X[0]
    yc = X[1]
    R  = ( X[2] + xc**2 + yc**2 )**(0.5)
    return xc, yc, R


def cal_dist(xi, yi, xf, yf):
    
    dx = xi - xf
    dy = yi - yf
    
    return (dx**2 + dy**2)**(0.5)

def read_csv(csv_file_scan='case1.csv'):
    
    '''
    Read the scan data set from the csv file.
    '''
    with open(csv_file_scan) as scan:
        scan_csv = csv.reader(scan)
        scan_list = []
        # Data from csv file are "string", 
        # so they need to be change to float type by "list(map(float, row))" operation.
        for row in scan_csv:
            x = list(map(float, row))
            scan_list.append(x)
        scan_set = np.array(scan_list)
    
    return scan_set

if __name__ == "__main__":
    scan = read_csv()
    print(np.shape(scan))
    x = scan[1]
    print(x)