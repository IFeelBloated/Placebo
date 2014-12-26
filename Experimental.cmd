ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output super.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmulti.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output c1.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del dif.mp4
del limit.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output c1RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s1.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c1.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s1RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c1RGB.mp4
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output c2.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s1.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output c2RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s1RGB.mp4
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s2.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c2.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s2RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c2RGB.mp4
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output c3.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s2.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output c3RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s2RGB.mp4
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s3.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c3.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s3RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del c3RGB.mp4
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3RGB.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO dif=Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True).dither_lut16 ("x 32768 - 0.64 * 32768 +") >> temp.avs
ECHO soft.Dither_add16 (dif, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s3.mp4
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3RGB.mp4") >> temp.avs
ECHO dif=Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True).dither_lut16 ("x 32768 - 0.64 * 32768 +") >> temp.avs
ECHO soft.Dither_add16 (dif, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s3RGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output limitfinal.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del dif.mp4
del limit.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output limitfinalRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO Deconv16 (dif=true) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO Deconv16 (dif=true) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitfinal.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitfinalRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitfinal.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output deconv.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del dif.mp4
del limitfinal.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitfinalRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitfinalRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("soft.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitfinalRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmulti.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output deconvRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitfinalRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superd.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("superd.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultid.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superd.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s1.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del dif.mp4
del limit.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s1RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del difRGB.mp4
del limitRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s2.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s1.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s2RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del s1RGB.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supertRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO s=LWLibAVVideoSource ("search.mp4") >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (s, s, s), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output s3.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s2.mp4
del dif.mp4
del limit.mp4
del supert.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2RGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("supertRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output s3RGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del s2RGB.mp4
del difRGB.mp4
del limitRGB.mp4
del supertRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultit.mp4
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("deconvRGB.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3RGB.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output difRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO dif=Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True).dither_lut16 ("x 32768 - 0.64 * 32768 +") >> temp.avs
ECHO soft.Dither_add16 (dif, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s3.mp4
del /f /s /q *.lwi

ECHO soft=LWLibAVVideoSource ("deconvRGB.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3RGB.mp4") >> temp.avs
ECHO dif=Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True).dither_lut16 ("x 32768 - 0.64 * 32768 +") >> temp.avs
ECHO soft.Dither_add16 (dif, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output limitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del s3RGB.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimitRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("difRGB.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdifRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO dif=LWLibAVVideoSource ("dif.mp4") >> temp.avs
ECHO limit=LWLibAVVideoSource ("limit.mp4") >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superd.mp4") >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdif.mp4") >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimit.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output sharpr.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del deconv.mp4
del dif.mp4
del limit.mp4
del superd.mp4
del superdif.mp4
del superlimit.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,0) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,0) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,0) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,0) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output R.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,1) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,1) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,1) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,1) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output G.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconvRGB.mp4").selectevery (3,2) > temp.avs
ECHO dif=LWLibAVVideoSource ("difRGB.mp4").selectevery (3,2) >> temp.avs
ECHO limit=LWLibAVVideoSource ("limitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superdRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superdif=LWLibAVVideoSource ("superdifRGB.mp4").selectevery (3,2) >> temp.avs
ECHO superlimit=LWLibAVVideoSource ("superlimitRGB.mp4").selectevery (3,2) >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultid.mp4") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, repmodeu=13, repmodev=13, str=1.0, tv_range=False) >> temp.avs
call x264.exe --output B.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO r=LWLibAVVideoSource ("R.mp4") > temp.avs
ECHO g=LWLibAVVideoSource ("G.mp4") >> temp.avs
ECHO b=LWLibAVVideoSource ("B.mp4") >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call x264.exe --output sharprRGB.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del R.mp4
del G.mp4
del B.mp4
del deconvRGB.mp4
del difRGB.mp4
del limitRGB.mp4
del superdRGB.mp4
del superdifRGB.mp4
del superlimitRGB.mp4
del vmultid.mp4
del /f /s /q *.lwi
