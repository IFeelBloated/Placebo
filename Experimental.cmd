ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output super.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("super.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
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

ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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









ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi
















ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
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

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi








ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi
















ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
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

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO converttoy8 () >> temp.avs
ECHO CubicSharp16 (str=1.00, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi


































ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("c3.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi
























ECHO soft=LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
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

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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





































ECHO LWLibAVVideoSource ("search.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO Deconv16 (dif=true) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limitfinal.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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






















ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superd.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("superd.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultid.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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


















ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s1.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi






















ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=0.64, tv_range=False) >> temp.avs
call x264.exe --output limit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("s2.mp4") > temp.avs
ECHO a=last >> temp.avs
ECHO ShrinkSharp16 (original=LWLibAVVideoSource ("search.mp4"), str=1.00, tv_range=False) >> temp.avs
ECHO Dither_sub16 (last, a, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del vmultit.mp4
del /f /s /q *.lwi






















ECHO soft=LWLibAVVideoSource ("deconv.mp4") > temp.avs
ECHO sharp=LWLibAVVideoSource ("s3.mp4") >> temp.avs
ECHO Dither_sub16 (sharp, soft, wrap=False, y=3, u=3, v=3, dif=True) >> temp.avs
call x264.exe --output dif.mp4 --preset ultrafast --qp 0 temp.avs
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

ECHO LWLibAVVideoSource ("limit.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superlimit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("dif.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superdif.mp4 --preset ultrafast --qp 0 temp.avs
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
del s3.mp4
del dif.mp4
del limit.mp4
del superd.mp4
del superdif.mp4
del superlimit.mp4
del vmultid.mp4
del /f /s /q *.lwi


















ECHO LWLibAVVideoSource ("sharpr.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output supert.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("sharpr.mp4") > temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO supersearch=LWLibAVVideoSource ("supert.mp4") >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, blksize=4, dct=1, thsad=1200, vccs="yv16", tv_range=False) >> temp.avs
call x264.exe --input-csp i422 --output-csp i422 --output vmultit.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del supert.mp4
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("sharpr.mp4") > temp.avs
ECHO converttoy8 () >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb", tv_range=False) >> temp.avs
ECHO YTo420_16() >> temp.avs
call x264.exe --output superclip.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del /f /s /q *.lwi

ECHO LWLibAVVideoSource ("sharpr.mp4") > temp.avs
ECHO blur=MinBlur16 (radius=1) >> temp.avs
ECHO superclip=LWLibAVVideoSource ("superclip.mp4") >> temp.avs
ECHO vclip=LWLibAVVideoSource ("vmultit.mp4") >> temp.avs
ECHO MBlur16 (blur=blur, superclip=superclip, vclip=vclip, pel=4, tr=6, thsad=1200, repmode=16, repmodeu=16, repmodev=16, tv_range=False) >> temp.avs
call x264.exe --output Minblur.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del superclip.mp4
del vmultit.mp4
del /f /s /q *.lwi










ECHO LWLibAVVideoSource ("sharpr.mp4") > temp.avs
ECHO minblur=LWLibAVVideoSource ("Minblur.mp4") >> temp.avs
ECHO detect=LWLibAVVideoSource ("Minblur.mp4") >> temp.avs
ECHO HaloCancelation16 (minblur=minblur, detect=detect, RGB=False, a1=16, a2=96, a3=128, radius=4, output=True, tv_range=False) >> temp.avs
call x264.exe --output sharp.mp4 --preset ultrafast --qp 0 temp.avs
del temp.avs
del Minblur.mp4
del sharpr.mp4
del /f /s /q *.lwi
