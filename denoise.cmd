ECHO LWLibAVVideoSource("soft.mp4").selectevery (3,0) > temp.avs
ECHO super=LWLibAVVideoSource("superRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource("vmulti.mp4") >> temp.avs
ECHO DenoiseComp16(superclip=super, vclip=vclip, pel=4, tr=6, thsad=400, tv_range=False) >> temp.avs
call x264.exe --output comp.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource("comp.mp4") > temp.avs
ECHO repclip=LWLibAVVideoSource("soft.mp4").selectevery (3,0) >> temp.avs
ECHO CompDfttest16(repclip=repclip, tr=6, sstring="0.0:8.0 0.48:4.0 0.64:0.5 1.0:0.25", sbsize=65, repmode=13, repmodeu=13, repmodev=13, tv_range=False) >> temp.avs
call x264.exe --output r.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del comp.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource("soft.mp4").selectevery (3,1) > temp.avs
ECHO super=LWLibAVVideoSource("superRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource("vmulti.mp4") >> temp.avs
ECHO DenoiseComp16(superclip=super, vclip=vclip, pel=4, tr=6, thsad=400, tv_range=False) >> temp.avs
call x264.exe --output comp.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource("comp.mp4") > temp.avs
ECHO repclip=LWLibAVVideoSource("soft.mp4").selectevery (3,1) >> temp.avs
ECHO CompDfttest16(repclip=repclip, tr=6, sstring="0.0:4.0 0.48:2.0 0.64:0.5 1.0:0.25", sbsize=65, repmode=13, repmodeu=13, repmodev=13, tv_range=False) >> temp.avs
call x264.exe --output g.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del comp.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource("soft.mp4").selectevery (3,2) > temp.avs
ECHO super=LWLibAVVideoSource("superRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource("vmulti.mp4") >> temp.avs
ECHO DenoiseComp16(superclip=super, vclip=vclip, pel=4, tr=6, thsad=400, tv_range=False) >> temp.avs
call x264.exe --output comp.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource("comp.mp4") > temp.avs
ECHO repclip=LWLibAVVideoSource("soft.mp4").selectevery (3,2) >> temp.avs
ECHO CompDfttest16(repclip=repclip, tr=6, sstring="0.0:16.0 0.48:8.0 0.64:0.5 1.0:0.25", sbsize=65, repmode=13, repmodeu=13, repmodev=13, tv_range=False) >> temp.avs
call x264.exe --output b.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del comp.mp4
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("r.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("g.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("b.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output flat.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del r.mp4
del g.mp4
del b.mp4
del /f /s /q *.lwi
