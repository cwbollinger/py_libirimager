import sys
import csv

import numpy as np
import cv2
from ir_cam import IrCamera

with IrCamera(sys.argv[1]) as ir_cam:

    for i in range(10000):
        data_t, data_p = ir_cam.get_frame()

        cv2.imshow('visual data', data_p)
        print '----------------'
        print data_t
        print '----------------'
        cv2.waitKey(5)
    '''
    n_rows, n_cols = data_t.shape
    print data_t[0]
    with open('test.csv', 'w') as csvfile:
        thermalwriter = csv.writer(csvfile)
        for row in range(n_rows):
            thermalwriter.writerow(data_t[row])
    '''

