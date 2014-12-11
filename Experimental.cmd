ECHO LWLibAVVideoSource ("stacked 16bit grayscale video") > temp.avs
ECHO EdgeCleanse16 (tv_range=False) >> temp.avs
call x264.exe --output cleanse.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("cleanse.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output super.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("cleanse.mp4") > temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO supersearch=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmulti.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi
