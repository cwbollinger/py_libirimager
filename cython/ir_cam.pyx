import numpy as np
cimport numpy as np

cdef extern from "libirimager/direct_binding.h":
    int evo_irimager_usb_init(char* xml_config, char* formats_def, char* log_file)
    int evo_irimager_set_temperature_range(int t_min, int t_max)
    int evo_irimager_set_radiation_parameters(float emissivity, float transmissivity, float tAmbient)
    int evo_irimager_terminate()
    int evo_irimager_get_thermal_image_size(int* w, int* h)
    int evo_irimager_get_thermal_image(int* w, int* h, unsigned short* data)
    int evo_irimager_get_palette_image_size(int* w, int* h)
    int evo_irimager_get_palette_image(int* w, int* h, unsigned char* data)
    int evo_irimager_get_thermal_palette_image(int w_t, int h_t, unsigned short* data_t, int w_p, int h_p, unsigned char* data_p)


class IrCamera(object):

    def __init__(self, xml_config_file):
        self.xml_config = xml_config_file

    def __enter__(self):
        cdef char* null_ptr = <char *> 0 # is there a better way to do this?
        retval = evo_irimager_usb_init(self.xml_config, null_ptr, null_ptr)
        if retval == -1:
            raise RuntimeError('Error initializing connection...')
        return self

    def __exit__(self, err_type, value, traceback):
        self.terminate_connection()

    def set_radiation_parameters(self, emissivity, transmissivity, tAmbient):
        retval = evo_irimager_set_radiation_parameters(emissivity, transmissivity, tAmbient)
        if retval == -1:
            raise RuntimeError('Error setting radiation parameters')

    def set_thermal_range(self, t_min, t_max):
        retval = evo_irimager_set_temperature_range(t_min, t_max)
        if retval == -1:
            raise RuntimeError('Error setting thermal range')

    def get_frame(self):
        cdef int w_t
        cdef int h_t
        cdef int w_p
        cdef int h_p
        cdef np.ndarray[np.uint16_t, ndim=1] data_t
        cdef np.ndarray[np.uint8_t, ndim=1] data_p
        retval = evo_irimager_get_thermal_image_size(&w_t, &h_t)
        if retval == -1:
            raise RuntimeError('Error getting thermal image size...')
        retval = evo_irimager_get_palette_image_size(&w_p, &h_p)
        if retval == -1:
            raise RuntimeError('Error getting palette image size...')
        data_t = np.zeros(w_t*h_t, dtype=np.dtype('u2'), order='C')
        data_p = np.zeros(w_p*h_p*3, dtype=np.dtype('u1'), order='C')
        retval = evo_irimager_get_thermal_palette_image(w_t, h_t, &data_t[0], w_p, h_p, &data_p[0])
        if retval == -1:
            raise RuntimeError('Error getting image')
        new_data_t = np.zeros(w_t*h_t, dtype=np.dtype('u2'), order='C')
        #      float t = ((((float)data[i])-1000.f))/10.f;
        for i, val in enumerate(data_t):
            new_data_t[i] = (float(val) - 1000.0) / 10.0
        return new_data_t.reshape(h_t, w_t), data_t.reshape(h_t, w_t), data_p.reshape(h_p, w_p, 3)[:,:,::-1]

    def get_palette_frame(self):
        cdef int w
        cdef int h
        cdef np.ndarray[np.uint8_t, ndim=1] data
        retval = evo_irimager_get_palette_image_size(&w, &h)
        if retval == -1:
            raise RuntimeError('Error getting palette image size...')
        data = np.zeros(w*h*3, dtype=np.dtype('u1'), order='C')
        retval = evo_irimager_get_palette_image(&w, &h, &data[0])
        if retval == -1:
            raise RuntimeError('Error getting image')
        return data.reshape(h, w, 3)[:,:,::-1] # bgr -> rgb

    def terminate_connection(self):
        retval = evo_irimager_terminate()
        if retval == -1:
            raise RuntimeError('Error terminating camera connection')
