ECHO RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO nlmeanscl2 (a=10, b=0, s=4, lsb_inout=true, h=2.4, aa=1.6) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo NLM.rgb
del TMP.avs

ECHO RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO YTo420_16().DFTTest (lsb_in=true, lsb=true, sstring="0.0:16.0 0.48:8.0 0.64:0.5 1.0:0.25", sbsize=33, sosize=0, smode=0, tosize=0, tbsize=1, tmode=0, y=true, u=False, v=False).ConvertToY8 () >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo DFT.rgb
del TMP.avs

ECHO Y=RawReader("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO DFT=RawReader("DFT.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO NLM=RawReader("NLM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Y.SpatialNR (NLM=NLM, DFT=DFT) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Spatial.rgb
del TMP.avs
del DFT.rgb
del NLM.rgb

ECHO RawReader("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperV.rgb
del TMP.avs

ECHO RawReader("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO super=RawReader("SuperV.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO GetVectors (supersearch=super) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Vmulti.rgb
del TMP.avs
del SuperV.rgb

ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Spatial=RawReader ("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (Y, Spatial, dif=true) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Spatial=RawReader("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Y=RawReader("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO DifCleanse16 (Spatial, Dif, SuperD, Vmulti, Y) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo NRDif.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb

ECHO RawReader ("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO GenLimitClip16 (CM=False, original=Y) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Limit.rgb
del TMP.avs

ECHO RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperL.rgb
del TMP.avs

ECHO C=RawReader ("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo PreS.rgb
del TMP.avs
del Dif.rgb
del Limit.rgb
del SuperD.rgb
del SuperL.rgb

ECHO RawReader ("PreS.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenLimitClip16 (CM=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Limit.rgb
del TMP.avs

ECHO RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperL.rgb
del TMP.avs

ECHO RawReader ("PreS.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dither_sub16 (CMSharp16 (str=1.00), last, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("PreS.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo CM.rgb
del TMP.avs
del Dif.rgb
del Limit.rgb
del SuperD.rgb
del SuperL.rgb
del PreS.rgb

ECHO RawReader ("CM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO GenLimitClip16 (CM=False, original=Y) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Limit.rgb
del TMP.avs

ECHO RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperL.rgb
del TMP.avs

ECHO C=RawReader ("CM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("CM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S1.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb

ECHO C=RawReader ("S1.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("S1.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S2.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S1.rgb

ECHO C=RawReader ("S2.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("S2.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S3.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S2.rgb

ECHO S=RawReader ("S3.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO CM=RawReader ("CM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (S, CM, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("CM.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo PreDeconv.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S3.rgb
del Limit.rgb
del SuperL.rgb
del CM.rgb

ECHO RawReader ("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Deconv16 (dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO RawReader("PreDeconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperL.rgb
del TMP.avs

ECHO Input=RawReader("Spatial.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("PreDeconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO NRDif=RawReader("NRDif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO DeconvS=SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
ECHO DeconvS.Dither_add16 (NRDif, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Deconv.rgb
del TMP.avs
del Dif.rgb
del PreDeconv.rgb
del SuperD.rgb
del SuperL.rgb
del Spatial.rgb
del NRDif.rgb

ECHO RawReader ("Deconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO GenLimitClip16 (CM=False, original=Y) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Limit.rgb
del TMP.avs

ECHO RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperL.rgb
del TMP.avs

ECHO C=RawReader ("Deconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("Deconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S1.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb

ECHO C=RawReader ("S1.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("S1.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S2.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S1.rgb

ECHO C=RawReader ("S2.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (C.ShrinkSharp16(original=Y, str=1.00), C, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("S2.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo S3.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S2.rgb

ECHO S=RawReader ("S3.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO CM=RawReader ("Deconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Dither_sub16 (S, CM, dif=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Dif.rgb
del TMP.avs

ECHO RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=False) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperD.rgb
del TMP.avs

ECHO Input=RawReader("Deconv.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Dif=RawReader("Dif.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Limit=RawReader("Limit.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperD=RawReader("SuperD.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperL=RawReader("SuperL.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO SharpCalmer16 (Input, Dif, Limit, SuperD, SuperL, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Retouched.rgb
del TMP.avs
del Dif.rgb
del SuperD.rgb
del S3.rgb
del Limit.rgb
del SuperL.rgb
del Deconv.rgb

ECHO RawReader("Retouched.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO MinBlur16 (1) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Minblur.rgb
del TMP.avs

ECHO RawReader("Retouched.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO GenSuperclip16 (pel=4, dither=True) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo SuperR.rgb
del TMP.avs

ECHO Input=RawReader("Retouched.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Blur=RawReader("Minblur.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO SuperR=RawReader("SuperR.rgb", "Y8", 2944, 1920, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Vmulti=RawReader ("Vmulti.rgb", "BGRA", 4404, 60, packing="8:0:8") >> TMP.avs
ECHO MBlur16 (Input, Blur, SuperR, Vmulti) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Mblur.rgb
del TMP.avs
del Minblur.rgb
del SuperR.rgb

ECHO Y=RawReader ("Y.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () > TMP.avs
ECHO Retouch=RawReader ("Retouched.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO Mblur=RawReader ("Mblur.rgb", "Y8", 736, 960, packing="8:0:8").ConvertToY8 () >> TMP.avs
ECHO HaloCancelation16 (Retouch, Y, Mblur, Mblur) >> TMP.avs
call ffmpeg -i TMP.avs -c:v rawvideo Final.rgb
del TMP.avs
del Retouched.rgb
