from distutils.core import setup
from distutils.extension import Extension

try:
    from Cython.Distutils import build_ext
except ImportError:
    use_cython = False
else:
    use_cython = True

cmdclass = {}
ext_modules = []

if use_cython:
    ext_modules += [
        Extension('ir_cam', ['ir_cam.pyx'],
            libraries = ['irdirectsdk'],
            language='c++'
        )
    ]
    cmdclass.update({ 'build_ext': build_ext })
else:
    ext_modules += [
        Extension('ir_cam', ['ir_cam.cpp'],
            libraries = ['irdirectsdk'],
            language='c++'
        )
    ]

setup(
    name = "ir_imager",
    version = "0.1",
    description = "Python wrapper for libirimager",
    url = "http://github.com/cwbollinger/py_ir_imager",
    author = "Chris Bollinger",
    author_email = "cwbollinger@gmail.com",
    cmdclass = cmdclass,
    ext_modules = ext_modules,
    packages = ["ir_imager"],
    license = "MIT"
)
