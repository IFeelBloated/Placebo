ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo super.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("super.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmulti.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("super.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c1.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c1RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb

ECHO RawReader ("c1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("c1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("c1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("c1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("c1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s1.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("c1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s1RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del c1.rgb
del c1RGB.rgb

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c2.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c2RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del s1.rgb
del s1RGB.rgb

ECHO RawReader ("c2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("c2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("c2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("c2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("c2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s2.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("c2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s2RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del c2.rgb
del c2RGB.rgb

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO CubicSharp16 (str=0.64, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Dither_sub16 (CubicSharp16 (str=1.00, curve="srgb"), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c3.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo c3RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del s2.rgb
del s2RGB.rgb

ECHO RawReader ("c3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("c3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("c3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("c3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("c3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s3.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("c3RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s3RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del c3.rgb
del c3RGB.rgb

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO last.dither_add16 (dither_sub16 (s, last, dif=true).dither_lut16 ("x 32768 - 0.64 * 32768 +"), dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO last.dither_add16 (dither_sub16 (s, last, dif=true).dither_lut16 ("x 32768 - 0.64 * 32768 +"), dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO dither_sub16 (s, last, dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO dither_sub16 (s, last, dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("super.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitfinal.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitfinalRGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del s3.rgb
del s3RGB.rgb

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Deconv16 (dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO Deconv16 (dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limitfinal.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitfinalRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitfinal.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("super.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo deconv.rgb
del temp.avs
del dif.rgb
del limitfinal.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitfinalRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitfinalRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("soft.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitfinalRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmulti.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo deconvRGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitfinalRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superd.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdRGB.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("superd.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultid.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superd.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s1.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s1RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("s1.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s2.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("s1RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s2RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del s1.rgb
del s1RGB.rgb

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supertRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=o, str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO ShrinkSharp16 (original=Interleave (o, o, o), str=0.64) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=o, str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO o=RawReader ("search.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Dither_sub16 (ShrinkSharp16 (original=Interleave (o, o, o), str=1.00), last, dif=True) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("s2.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s3.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("s2RGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("supertRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultit.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo s3RGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del vmultit.rgb
del supert.rgb
del supertRGB.rgb
del s2.rgb
del s2RGB.rgb

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO last.dither_add16 (dither_sub16 (s, last, dif=true).dither_lut16 ("x 32768 - 0.64 * 32768 +"), dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limit.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO last.dither_add16 (dither_sub16 (s, last, dif=true).dither_lut16 ("x 32768 - 0.64 * 32768 +"), dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo limitRGB.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO dither_sub16 (s, last, dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo dif.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO s=RawReader ("s3RGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO dither_sub16 (s, last, dif=true) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo difRGB.rgb
del temp.avs

ECHO RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimit.rgb
del temp.avs

ECHO RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superlimitRGB.rgb
del temp.avs

ECHO RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdif.rgb
del temp.avs

ECHO RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo superdifRGB.rgb
del temp.avs

ECHO RawReader ("deconv.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO dif=RawReader ("dif.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limit.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superd.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdif.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimit.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo SharpR.rgb
del temp.avs
del dif.rgb
del limit.rgb
del superdif.rgb
del superlimit.rgb

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,0).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo R.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,1).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo G.rgb
del temp.avs

ECHO RawReader ("deconvRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () > temp.avs
ECHO dif=RawReader ("difRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO limit=RawReader ("limitRGB.rgb", "Y8", 736, 704, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superclip=RawReader ("superdRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superdif=RawReader ("superdifRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO superlimit=RawReader ("superlimitRGB.rgb", "Y8", 2944, 1408, packing="8:0:8").selectevery (3,2).ConvertToY8 () >> temp.avs
ECHO vclip=RawReader ("vmultid.rgb", "BGRA", 4404, 44, packing="8:0:8") >> temp.avs
ECHO SharpCalmer16 (dif=dif, limit=limit, superclip=superclip, superdif=superdif, superlimit=superlimit, vclip=vclip, pel=4, tr=6, thsad=400, repmode=13, str=1.0) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo B.rgb
del temp.avs

ECHO r=RawReader ("R.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO g=RawReader ("G.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO b=RawReader ("B.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO Interleave (r, g, b) >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo SharpRRGB.rgb
del temp.avs
del R.rgb
del G.rgb
del B.rgb
del difRGB.rgb
del limitRGB.rgb
del superdifRGB.rgb
del superlimitRGB.rgb
del s3.rgb
del s3RGB.rgb
del vmultid.rgb
del superd.rgb
del superdRGB.rgb
del deconv.rgb
del deconvRGB.rgb

ECHO RawReader ("SharpR.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO GenSuperclip16 (pel=4, curve="srgb") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo supert.rgb
del temp.avs

ECHO RawReader ("SharpR.rgb", "Y8", 736, 704, packing="8:0:8").ConvertToY8 () > temp.avs
ECHO MinBlur16 (radius=1) >> temp.avs
ECHO supersearch=RawReader ("supert.rgb", "Y8", 2944, 1408, packing="8:0:8").ConvertToY8 () >> temp.avs
ECHO GetVectors (supersearch=supersearch, tr=6, pel=4, dct=1, thsad=400, vccs="RGB32") >> temp.avs
call ffmpeg -i temp.avs -c:v rawvideo vmultit.rgb
del temp.avs
del supert.rgb
