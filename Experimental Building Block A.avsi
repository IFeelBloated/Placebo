Function GetVectors (clip search, clip "supersearch", 
         \           int "tr", int "pel", int "dct", int "thsad", string "vccs")
{
    supersearch = Default (supersearch, UnDefined ())
    tr          = Default (tr, 6)
    pel         = Default (pel, 4)
    dct         = Default (dct, 1)
    thsad       = Default (thsad, 400)
    vccs        = Default (vccs, "RGB32")

    search      = search.TComp (tr=tr).YTo420_16 ()
    supersearch = supersearch.TComp (tr=tr).ConvertToYV12 ()

    supersoft   = search.Round8 (False).MSuper (pel=pel, chroma=False, hpad=0, vpad=0, pelclip=supersearch, sharp=2, rfilter=4, levels=0)
    supersharp  = search.Round8 (False).MSuper (pel=pel, chroma=False, hpad=0, vpad=0, pelclip=supersearch, sharp=2, rfilter=2, levels=0)
    vmulti      = supersoft.MAnalyse (multi=True, overlap=16, blksize=32, search=3, chroma=False, truemotion=True, delta=tr, trymany=True,
                           \          searchparam=16, pelsearch=16, dct=dct, levels=0, divide=2, badrange=-24)
    vmulti      = supersoft.MRecalculate (vmulti, overlap=8, blksize=16, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=2)
    vmulti      = supersharp.MRecalculate (vmulti, overlap=4, blksize=8, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=2)
    vmulti      = supersharp.MRecalculate (vmulti, overlap=2, blksize=4, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=0)

    return vccs == "yv16" ? MStoreVect (vmulti, vccs="yuy2").converttoyv16 () : MStoreVect (vmulti, vccs=vccs)
}

Function GenSuperclip16 (clip input, int "pel", string "curve")
{
    pel        = Default (pel, 4)
    w          = input.width ()
    h          = input.height ()/2
    curve      = Default (curve, "srgb")

    Upsample   = (pel==2) ? input.EDIResize16 (w*2, h*2, src_left=0.25, src_top=0.25, edimode="eedi3+nnedi3_repaired", noring=true, curve=curve, tv_range=False)
             \ : (pel==4) ? input.EDIResize16 (w*4, h*4, src_left=0.375, src_top=0.375, edimode="eedi3+nnedi3_repaired", noring=true, curve=curve, tv_range=False)
             \ : Assert (1>2,"Invalid pel value !")

    return Upsample.Round8 (False)
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

Function YTo420_16 (clip c)
{
    output    = c.ConvertToYV12 ().Grayscale16 ()

    return output
}

Function MinBlur_SBR16 (clip input)
{
    rg11D    = Dither_sub16 (input, input.SBR16 (), dif=True, y=3, u=1, v=1)
    rg4D     = Dither_sub16 (input, input.Dither_removegrain16 (4, -1, -1), dif=True, y=3, u=1, v=1)
    DD       = Dither_diff_compromise16 (RG11D, RG4D)

    output   = input.Dither_sub16 (DD, dif=True, y=3, u=1, v=1)

    return output
}

Function SBR16 (clip input) 
{
    rg11D    = Dither_sub16 (input, input.Dither_removegrain16 (11, -1, -1) , dif=True, y=3, u=1, v=1)
    rg11Dr   = rg11D.Dither_removegrain16 (11, -1, -1)

    abrg11D  = rg11D.Dither_lut16 ("x 32768 - abs", y=3, u=1, v=1)
    Ddiff    = Dither_sub16 (rg11D, rg11Dr, dif=True, y=3, u=1, v=1)    
    abDdiff  = Ddiff.Dither_lut16 ("x 32768 - abs", y=3, u=1, v=1)
    abDDD    = Dither_sub16 (abDdiff, abrg11D, dif=True, y=3, u=1, v=1)

    Dmask1   = abDDD.Dither_lut16 ("x 32768 < 65535 0 ?", y=3, u=1, v=1)
    Ddiffg   = Ddiff.Dither_lut16 ("x 32768 == x x 32768 < 0 65535 ? ?", y=3, u=1, v=1).Dither_get_msb ()
    rg11Dg   = rg11D.Dither_lut16 ("x 32768 == x x 32768 < 0 65535 ? ?", y=3, u=1, v=1).Dither_get_msb ()
    Dmask2   = mt_lutxy (Ddiffg, rg11Dg, "x 128 - y 128 - * 0 < 0 255 ?", y=3, u=1, v=1)

    DD1      = Dither_merge16 (rg11D, Ddiff, Dmask1, luma=False, y=3, u=1, v=1)
    DD2      = Dither_merge16_8 (DD1.Dither_gen_null_diff16 (), DD1, Dmask2, luma=False, y=3, u=1, v=1)

    output   = input.Dither_sub16 (DD2, dif=True, y=3, u=1, v=1)

    return output
}

Function MinBlur16 (clip input, int "radius")
{
    radius   = Default (radius, 1)
    
    RG11     = (radius==1) ? input.Dither_removegrain16 (11, -1, -1)
    \        : (radius==2) ? input.Dither_removegrain16 (11, -1, -1).Dither_removegrain16 (20, -1, -1)
    \        : (radius==3) ? input.Dither_removegrain16 (11, -1, -1).Dither_removegrain16 (20, -1, -1).Dither_removegrain16 (20, -1, -1)
    \        : Assert (1>2, "radius must be 1-3!")

    RG4      = (radius==1) ? input.Dither_removegrain16 (4, -1, -1)
    \        : (radius==2) ? input.Dither_median16 (2, 2, 0, y=3, u=1, v=1)
    \        : (radius==3) ? input.Dither_median16 (3, 3, 0, y=3, u=1, v=1)
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

    brightdif  = Dither_sub16 (input, bright_limit, dif=true, y=3, u=1, v=1)
    darkdif    = Dither_sub16 (input, dark_limit, dif=true, y=3, u=1, v=1)

    brightDdec = brightdif.Dither_lut16 ("x " + os16 + " - 32768 > x " + os16 + " - 32768 ?", y=3, u=1, v=1)
    darkDdec   = darkdif.Dither_lut16 ("x " + us16 + " + 32768 < x " + us16 + " + 32768 ?", y=3, u=1, v=1)

    output     = input.Dither_sub16 (brightDdec, dif=true, y=3, u=1, v=1).Dither_sub16 (darkDdec, dif=true, y=3, u=1, v=1)

    return output
}

Function Dither_min_dif16 (clip input1, clip input2, clip ref)
{
    maxdif     = Dither_max_dif16 (input1, input2, ref, y=3, u=1, v=1)
    bin_stack  = mt_lutxy (input1, maxdif, "x y == 255 0 ?", y=3, u=1, v=1)
    bin_msb    = bin_stack.Dither_get_msb ()
    bin_lsb    = bin_stack.Dither_get_lsb ()
    bin        = mt_logic (bin_msb, bin_lsb, "min", y=3, u=1, v=1)
    
    output     = Dither_merge16_8 (input1, input2, bin, luma=False, y=3, u=1, v=1)

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
    abdiff1    = Dither_lut16 (diff1, "x 32768 - abs", y=3, u=1, v=1)
    abdiff2    = Dither_lut16 (diff2, "x 32768 - abs", y=3, u=1, v=1)
    abdiffdiff = Dither_sub16 (abdiff1, abdiff2, dif=True, y=3, u=1, v=1)
    bin        = Dither_lut16 (abdiffdiff, "x 32768 <= 0 65535 ?", y=3, u=1, v=1)

    output     = Dither_merge16 (diff1, diff2, bin, luma=False, y=3, u=1, v=1)

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
