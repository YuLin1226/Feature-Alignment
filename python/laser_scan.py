import numpy as np
from math import acos, pi
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
        self.shape_thres = 0.07
        self.R_thres = 50
        
        self.circle_thres = (pi/180)*60
        self.corner_thres = 0.7

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
    
    def classify_segment_type(self, seg):

        # for loop : "number of row" times
        for i in range( len(seg) ):
            x = seg[i][0]
            y = seg[i][1]

            x0 = x[0]
            y0 = y[0]

            xn = x[-1]
            yn = y[-1]

            xm = np.mean(x)
            ym = np.mean(y)

            _, _, r = cal_circle([x0, xm, xn], [y0, ym, yn])
            if r > self.R_thres:
                seg[i][2] = "line"
                
            else:
                seg[i][2] = "circle"
        
        return seg
                
    def corner_merger_operation(self, seg):
        k = 0
        i = 0
        
        for i in range(len(seg) - 1):
            i = i + 1 + k
            k = 0
            x1 = seg[i][0]
            y1 = seg[i][1]
            # x1m = np.mean(x1)
            # y1m = np.mean(y1)

            x2 = seg[i+1][0]
            y2 = seg[i+1][1]
            # x2m = np.mean(x2)
            # y2m = np.mean(y2)

            val = cal_acos([ x1[-1] - x1[0], y1[-1] - y1[0] ], [x2[-1] - x2[0], y2[-1] - y2[0]])

            if seg[i][2] == "circle":
            
                # circle , circle
                if seg[i][2] == seg[i+1][2]:   
                        # 合併Operation
                        seg[i][0] = seg[i][0] + seg[i+1][0]
                        seg[i][1] = seg[i][1] + seg[i+1][1]
                        seg.pop(i+1)
                        k = -1

                # circle , line   
                else:                       
                    # 判斷轉角
                    if val > self.corner_thres:
                        k = 0
                        
                    # 合併circle (後者理當是Circle，但是誤判成Line的情況)
                    else:
                        k = -1
                  
                        
                        # 合併Operation
                        seg[i][0] = seg[i][0] + seg[i+1][0]
                        seg[i][1] = seg[i][1] + seg[i+1][1]
                        seg.pop(i+1)
            
            # seg[i][2] == "line"    
            else:
                
                # line , line
                if seg[i][2] == seg[i+1][2]:  
                    
                    
                    # 判斷轉角
                    if val > self.corner_thres:  
                        k = 0
                        
                        
                    # 合併line
                    else:
                        k = -1
                        
                        
                        # 合併Operation
                        seg[i][0] = seg[i][0] + seg[i+1][0]
                        seg[i][1] = seg[i][1] + seg[i+1][1]
                        seg.pop(i+1)
                    
                    
                # line , circle
                else:                      
                    
                    
                    # 判斷轉角
                    if val > self.corner_thres:
                        k = 0
                        
                        
                    # 合併line (後者理當是Line，但是誤判成Circle的情況)
                    else:
                        k = -1
                        # 合併Operation
                        seg[i][0] = seg[i][0] + seg[i+1][0]
                        seg[i][1] = seg[i][1] + seg[i+1][1]
                        seg.pop(i+1)
        return seg

    def do_landmark(self, seg):
        circle_num = 0
        for i in range(len(seg)):
            if seg[i][2] == "circle":
                circle_num = circle_num + 1
            
        corner_num = 0
        for i in range( len(seg) - 1 ):
            
            x1 = seg[i][0][-1]
            y1 = seg[i][1][-1]
            x2 = seg[i+1][0][-1]
            y2 = seg[i+1][1][-1]

            d = cal_dist(x1,y1,x2,y2)
            if d < self.d_break_thres:
                corner_num = corner_num + 1
            


        landmark =  [   ["line",    corner_num],
                        ["circle",  circle_num] ]
        return landmark




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