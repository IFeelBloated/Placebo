Function GetVectors (clip search, clip "supersearch", 
         \           int "tr", int "pel", int "blksize", int "dct", int "thsad", string "vccs", bool "tv_range")
{
    supersearch = Default (supersearch, UnDefined ())
    tr          = Default (tr, 6)
    pel         = Default (pel, 4)
    blksize     = Default (blksize, 4)
    dct         = Default (dct, 1)
    thsad       = Default (thsad, 400)
    vccs        = Default (vccs, "yv16")
    tv_range    = Default (tv_range, True)

    overlap    = blksize/2
    blksizer   = blksize <= 4 ? blksize : blksize/2
    overlapr   = blksizer/2
    divide     = blksize <= 4 ? 0 : 2
    divider    = blksizer <= 4 ? 0 : 2

    search      = search.TComp (tr=tr)
    supersearch = supersearch.TComp (tr=tr)

    supervec    = search.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=True, hpad=16, vpad=16, pelclip=supersearch.Round8 (tv_range=tv_range), sharp=2, rfilter=4, levels=0)
    superrecal  = search.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=True, hpad=16, vpad=16, pelclip=supersearch.Round8 (tv_range=tv_range), sharp=2, rfilter=2, levels=0)
    vmulti      = supervec.MAnalyse (multi=True, overlap=overlap, blksize=blksize, search=3, chroma=True, truemotion=True, delta=tr,
                           \         searchparam=16, pelsearch=16, dct=dct, levels=0, divide=divide, badrange=-24)
    vmulti      = superrecal.MRecalculate (vmulti, overlap=overlapr, blksize=blksizer, thsad=thsad/2, chroma=True, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=divider)

    return vccs == "yv16" ? MStoreVect (vmulti, vccs="yuy2").converttoyv16 () : MStoreVect (vmulti, vccs=vccs)
}

Function GenSuperclip16 (clip input, int "pel", string "matrix", string "curve", bool "tv_range")
{
    pel        = Default (pel, 4)
    tv_range   = Default (tv_range, True)
    w          = input.width ()
    h          = input.height ()/2
    HD         = (w > 1024 || h > 576) ? True : False
    matrix     = Default (matrix, HD ? "709" : "601")
    curve      = Default (curve, "srgb")
    sCSP       = input.GetCSP ()

    RGB48Y     = sCSP=="Y8" ? input : input.EDIResize16 (output="RGB48Y", edimode="eedi3+nnedi3_repaired", tv_range=tv_range, matrix=matrix, noring=true)
    Upsample   = (pel==2) ? RGB48Y.EDIResize16 (w*2, h*2, src_left=0.25, src_top=0.25, edimode="eedi3+nnedi3_repaired", noring=true, curve=curve, tv_range=False)
             \ : (pel==4) ? RGB48Y.EDIResize16 (w*4, h*4, src_left=0.375, src_top=0.375, edimode="eedi3+nnedi3_repaired", noring=true, curve=curve, tv_range=False)
             \ : Assert (1>2,"Invalid pel value !")
    YUV        = sCSP=="Y8" ? NOP () : Dither_convert_rgb_to_yuv (Upsample.SelectEvery (3,0), Upsample.SelectEvery (3,1), Upsample.SelectEvery (3,2), output="yv24", lsb=true, mode=-1, matrix=matrix, tv_range=tv_range)
    Y          = sCSP=="Y8" ? NOP () : YUV.Grayscale16 ()
    U          = sCSP=="Y8" ? NOP () : YUV.UToY ()
    U          = sCSP=="Y8" ? NOP () 
             \ : sCSP=="YV12" ? U.Dither_resize16 (w*pel/2, h*pel/2, kernel="Spline", taps=32)
             \ : sCSP=="YUY2" ? U.Dither_resize16 (w*pel/2, h*pel, kernel="Spline", taps=32)
             \ : Assert (1>2,"Invalid colorspace for MVTool2 !")
    V          = sCSP=="Y8" ? NOP () : YUV.VToY ()
    V          = sCSP=="Y8" ? NOP () 
             \ : sCSP=="YV12" ? V.Dither_resize16 (w*pel/2, h*pel/2, kernel="Spline", taps=32)
             \ : sCSP=="YUY2" ? V.Dither_resize16 (w*pel/2, h*pel, kernel="Spline", taps=32)
             \ : Assert (1>2,"Invalid colorspace for MVTool2 !")

    output     = sCSP=="Y8" ? Upsample : YToUV (U, V, Y)

    return output
}

Function TTrim (clip input, int "tr")
{
    output     = input.trim (tr, input.framecount ()-Eval ("""tr+1"""))

    return output
}

Function TComp (clip input, int "tr")
{
    output     = input.trim (tr+1, tr*2).reverse ()+input+input.trim (input.framecount ()-Eval ("""tr*2+1"""), input.framecount ()-Eval ("""tr+2""")).reverse ()

    return output
}

Function GetCSP (clip c)
{
    return c.IsPlanar ? c.IsYV12 ? "YV12" :
    \                   c.IsYV16 ? "YV16" :
    \                   c.IsYV24 ? "YV24" : c.GetCSP_Y8_YV411 () :
    \      c.IsYUY2   ? "YUY2"   :
    \      c.IsRGB32  ? "RGB32"  :
    \      c.IsRGB24  ? "RGB24"  : "Unknown"
    
    
    Function GetCSP_Y8_YV411 (clip c) {
        try {
            c.UtoY
            csp = "YV411"
        } catch ( error_msg ) {
        csp = "Y8"
        }
        return csp
    }
}

Function YTo420_16 (clip c)
{
    output    = c.ConvertToYV12 ().Grayscale16 ()

    return output
}

Function MinBlur_SBR16 (clip input)
{
    rg11D    = Dither_sub16 (input, input.SBR16 (), dif=True, y=3, u=3, v=3)
    rg4D     = Dither_sub16 (input, input.Dither_removegrain16 (4, 4, 4), dif=True, y=3, u=3, v=3)
    DD       = Dither_diff_compromise16 (RG11D, RG4D)

    output   = input.Dither_sub16 (DD, dif=True, y=3, u=3, v=3)

    return output
}

Function SBR16 (clip input) 
{
    rg11D    = Dither_sub16 (input, input.Dither_removegrain16 (11, 11, 11) , dif=True, y=3, u=3, v=3)
    rg11Dr   = rg11D.Dither_removegrain16 (11, 11, 11)

    abrg11D  = rg11D.Dither_lut16 ("x 32768 - abs", y=3, u=3, v=3)
    Ddiff    = Dither_sub16 (rg11D, rg11Dr, dif=True, y=3, u=3, v=3)    
    abDdiff  = Ddiff.Dither_lut16 ("x 32768 - abs", y=3, u=3, v=3)
    abDDD    = Dither_sub16 (abDdiff, abrg11D, dif=True, y=3, u=3, v=3)

    Dmask1   = abDDD.Dither_lut16 ("x 32768 < 65535 0 ?", y=3, u=3, v=3)
    Ddiffg   = Ddiff.Dither_lut16 ("x 32768 == x x 32768 < 0 65535 ? ?", y=3, u=3, v=3).Dither_get_msb ()
    rg11Dg   = rg11D.Dither_lut16 ("x 32768 == x x 32768 < 0 65535 ? ?", y=3, u=3, v=3).Dither_get_msb ()
    Dmask2   = mt_lutxy (Ddiffg, rg11Dg, "x 128 - y 128 - * 0 < 0 255 ?", y=3, u=3, v=3)

    DD1      = Dither_merge16 (rg11D, Ddiff, Dmask1, luma=False, y=3, u=3, v=3)
    DD2      = Dither_merge16_8 (DD1.Dither_gen_null_diff16 (), DD1, Dmask2, luma=False, y=3, u=3, v=3)

    output   = input.Dither_sub16 (DD2, dif=True, y=3, u=3, v=3)

    return output
}

Function MinBlur16 (clip input, int "radius")
{
    radius   = Default (radius, 1)
    
    RG11     = (radius==1) ? input.Dither_removegrain16 (11, 11, 11)
    \        : (radius==2) ? input.Dither_removegrain16 (11, 11, 11).Dither_removegrain16 (20, 20, 20)
    \        : (radius==3) ? input.Dither_removegrain16 (11, 11, 11).Dither_removegrain16 (20, 20, 20).Dither_removegrain16 (20, 20, 20)
    \        : Assert (1>2, "radius must be 1-3!")

    RG4      = (radius==1) ? input.Dither_removegrain16 (4, 4, 4)
    \        : (radius==2) ? input.Dither_median16 (2, 2, 0, y=3, u=3, v=3)
    \        : (radius==3) ? input.Dither_median16 (3, 3, 0, y=3, u=3, v=3)
    \        : Assert (1>2, "radius must be 1-3!")

    output   = Dither_min_dif16 (RG11, RG4, input)
    
    return output
}

Function Grayscale16 (clip input)
{
    MSB       = input.Dither_get_msb ().mt_lut ("x" ,y=3, u=-128, v=-128)
    LSB       = input.Dither_get_lsb ().mt_lut ("x" ,y=3, u=0, v=0)

    output    = StackVertical (MSB, LSB)

    return output
}

Function Dither_clamp16 (clip input, clip "bright_limit", clip "dark_limit", float "overshoot", float "undershoot")
{
    overshoot  = Default (overshoot, 0)
    undershoot = Default (undershoot, 0)
    os16       = string  (overshoot*256)
    us16       = string  (undershoot*256)

    brightdif  = Dither_sub16 (input, bright_limit, dif=true, y=3, u=3, v=3)
    darkdif    = Dither_sub16 (input, dark_limit, dif=true, y=3, u=3, v=3)

    brightDdec = brightdif.Dither_lut16 ("x " + os16 + " - 32768 > x " + os16 + " - 32768 ?", y=3, u=3, v=3)
    darkDdec   = darkdif.Dither_lut16 ("x " + us16 + " + 32768 < x " + us16 + " + 32768 ?", y=3, u=3, v=3)

    output     = input.Dither_sub16 (brightDdec, dif=true, y=3, u=3, v=3).Dither_sub16 (darkDdec, dif=true, y=3, u=3, v=3)

    return output
}

Function Dither_min_dif16 (clip input1, clip input2, clip ref)
{
    maxdif     = Dither_max_dif16 (input1, input2, ref, y=3, u=3, v=3)
    bin_stack  = mt_lutxy (input1, maxdif, "x y == 255 0 ?", y=3, u=3, v=3)
    bin_msb    = bin_stack.Dither_get_msb ()
    bin_lsb    = bin_stack.Dither_get_lsb ()
    bin        = mt_logic (bin_msb, bin_lsb, "min", y=3, u=3, v=3)
    
    output     = Dither_merge16_8 (input1, input2, bin, luma=False, y=3, u=3, v=3)

    return output
}

Function Dither_gen_null_diff16 (clip input)
{
    msb     = input.Dither_get_msb ().mt_lut ("x", y=-128, u=-128, v=-128)
    lsb     = input.Dither_get_lsb ().mt_lut ("x", y=0, u=0, v=0)

    output  = StackVertical (msb,lsb)

    return output
}

Function Dither_diff_compromise16 (clip diff1, clip diff2)
{
    abdiff1    = Dither_lut16 (diff1, "x 32768 - abs", y=3, u=3, v=3)
    abdiff2    = Dither_lut16 (diff2, "x 32768 - abs", y=3, u=3, v=3)
    abdiffdiff = Dither_sub16 (abdiff1, abdiff2, dif=True, y=3, u=3, v=3)
    bin        = Dither_lut16 (abdiffdiff, "x 32768 <= 0 65535 ?", y=3, u=3, v=3)

    output     = Dither_merge16 (diff1, diff2, bin, luma=False, y=3, u=3, v=3)

    return output
}

Function TV2PC16 (clip input)
{
    input_Yfloor   = 4096
    input_Cfloor   = 4096
    input_Yceil    = 60160
    input_Cceil    = (65535-32768)/(65535.5-32768)*(61440-32768)+32768
    output_Yfloor  = 0
    output_Cfloor  = 0.5
    output_Yceil   = 65535
    output_Cceil   = 65535
    upper_limit    = 65535
    input_neutral  = 32768
    output_neutral = 32768

    Yexpr  = String (input_Yfloor)+"-"+String (output_Yfloor)+";"+ String (input_Yceil)+"-"+String (output_Yceil)
    Yexpr  = "0-"+String (output_Yfloor)+";"+Yexpr
    Yexpr  = Yexpr+";"+String (upper_limit)+"-"+String (output_Yceil)

    Cexpr  = String (input_Cfloor)+"-"+String (output_Cfloor)+";"+String (input_neutral)+"-"+String (output_neutral)+";"+String (input_Cceil)+"-"+String (output_Cceil)
    Cexpr  = "0-"+String (output_Cfloor)+";"+Cexpr
    Cexpr  = Cexpr+";"+String (upper_limit)+"-"+String (output_Cceil)

    output = input.SmoothCurve16 (Ycurve=Yexpr, Ucurve=Cexpr, Vcurve=Cexpr, mode=0, interp=0, HQ=True,
    \                             dither=-1, limiter=False, TVrange=0)

    return output
}

Function Convert8To16 (clip input, bool "tv_range")
{ 
    tv_range  = Default (tv_range, True)

    iCceil    = (255-128) / (255.5-128) * (65535.5-32768) + 32768
    Yexpr     = "0-0  ;                  255-65535             ;65535-65535          "
    Cexpr     = "0-0.5;0.5-0.5;128-32768;255-"+String(iCceil)+";65535-"+String(iCceil)
    fullrange = StackVertical (input.Dither_gen_null_lsb (), input).
    \           SmoothCurve16 (Ycurve=Yexpr, Ucurve=Cexpr, Vcurve=Cexpr, mode=0, interp=0, HQ=True,
    \                          dither=-1, limiter=False, TVrange=0)                           

    output    = tv_range ? input.Dither_convert_8_to_16 ()
                \        : fullrange

    return output
}

Function Round8 (clip input, bool "tv_range") 
{
    tv_range  = Default (tv_range, True)

    iCceil    = (255-128) / (255.5-128) * (65535.5-32768) + 32768
    Yexpr     = "0-0;                                           65535-255"
    Cexpr     = "0-0.5;0.5-0.5;32768-128;"+String(iCceil)+"-255;65535-255"
    fullrange = input.SmoothCurve16 (Ycurve=Yexpr, Ucurve=Cexpr, Vcurve=Cexpr, mode=0, interp=0, HQ=True,
    \                                dither=-1, limiter=False, TVrange=0)

    output    = tv_range ? input.ditherpost (mode=-1, y=3, u=3, v=3)
                \        : fullrange.Dither_get_lsb ()

    return output
}

Function Padding16 (clip input, int "left", int "top", int "right", int "bottom")
{
    msb    = input.Dither_get_msb ().Padding (left, top, right, bottom)
    lsb    = input.Dither_get_lsb ().Padding (left, top, right, bottom)

    output = StackVertical (msb, lsb)

    return output
}

Function Padding (clip input, int "left", int "top", int "right", int "bottom")
{
    w      = input.width ()
    h      = input.height ()

    output = input.PointResize (w+left+right, h+top+bottom, -left, -top, w+left+right, h+top+bottom)

    return output
}
