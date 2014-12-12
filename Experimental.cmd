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
del super.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("cleanse.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superclip.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("D:\test\cleanse.mp4") > temp.avs
ECHO blur=MinBlur16 (radius=1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superclip.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO MBlur16 (blur=blur, superclip=superclip, vclip=vclip, tr=6, thsad=1200, repmode=16, repmodeu=16, repmodev=16, tv_range=False) >> temp.avs
call x264.exe --output Minblur.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del superclip.mp4
del vmulti.mp4
del /f /s /q *.lwi
