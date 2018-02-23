import sys

import numpy as np
import cv2
from ir_cam import IrCamera

with IrCamera(sys.argv[1]) as ir_cam:

    for i in range(500):
        data_t, data_p = ir_cam.get_frame()

        cv2.imshow('visual data', data_p)
        cv2.waitKey(5)

