Function SharpCalmer16 (clip input, clip "dif", clip "limit", clip "superclip", clip "superdif", clip "superlimit", clip "vclip", clip "repclip",
         \              int "pel", int "tr", int "thsad", int "repmode", int "repmodeu", int "repmodev",
         \              float "str", bool "tv_range")
{
    dif        = Default (dif, UnDefined ())
    limit      = Default (limit, UnDefined ())
    superclip  = Default (superclip, UnDefined ())
    superdif   = Default (superdif, UnDefined ())
    superlimit = Default (superlimit, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    repclip    = Default (repclip, dif)
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    repmode    = Default (repmode, 13)
    repmodeu   = Default (repmodeu, repmode)
    repmodev   = Default (repmodev, repmode)
    str        = Default (str, 1.00)
    tv_range   = Default (tv_range, True)

    a          = input.TComp (tr=tr)
    dif        = dif.TComp (tr=tr)
    limit      = limit.TComp (tr=tr)
    superlimit = superlimit.TComp (tr=tr)
    superclip  = superclip.TComp (tr=tr)
    superdif   = superdif.TComp (tr=tr)
    blankdif   = dif.Round8 (tv_range=tv_range).Mt_lut ("x", y=-128, u=-128, v=-128)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    superdif   = dif.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=True, hpad=16, vpad=16, pelclip=superdif.Round8 (tv_range=tv_range), sharp=2, rfilter=2, levels=0)
    supercomp  = limit.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=True, hpad=16, vpad=16, pelclip=superlimit.Round8 (tv_range=tv_range), sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)

    MDeG       = blankdif.MDegrainN (superdif, vmulti, tr, thSAD2=thsad/2, thSADC2=thsad/2, thSAD=thsad, thSADC=thsad, thSCD1=10000, thSCD2=255, limit=255, limitc=255, plane=4, lsb=True)
    Repair     = MDeG.TTrim (tr=tr).Dither_Repair16 (repclip, mode=repmode, modeu=repmodeu, modev=repmodev)
    TAverage   = input.Dither_add16 (Repair, dif=True, y=3, u=3, v=3).TComp (tr=tr)

    comp       = a.Round8 (tv_range=tv_range).MCompensate (supercomp, vmulti, tr=tr, thSAD=thsad, thSAD2=thsad/2, thSCD1=10000, thSCD2=255)
    max        = comp.MaxMulti (tr=tr).Convert8To16 (tv_range=tv_range)
    min        = comp.MinMulti (tr=tr).Convert8To16 (tv_range=tv_range)
    TLimit     = TAverage.Dither_clamp16 (max, min, 0, 0).TTrim (tr=tr)

    SLimit     = input.SharpLimit16 (sharp=TLimit, str=str)

    return SLimit
}

Function HaloCancelation16 (clip sharp, clip "source", clip "minblur", clip "detect", int "a1", int "a2", int "a3", int "radius", int "mthr", bool "tv_range")
{
    source   = Default (source, UnDefined ())
    minblur  = Default (minblur, UnDefined ())
    detect   = Default (detect, UnDefined ())
    a1       = Default (a1, 16)
    a2       = Default (a2, 96)
    a3       = Default (a3, 128)
    radius   = Default (radius, 4)
    mthr     = Default (mthr, 60)
    tv_range = Default (tv_range, True)

    detect.Round8 (tv_range=tv_range)
    EM       = TEMMod (ThreshY=0, type=1).mt_lut ("x "+String (a1)+" "+String (a3)+" / 255 * - 4 *")
    EEM      = EM.mt_expand ().mt_lut ("x "+String (a2)+" "+String (a3)+" / 255 * - 4 *")
    RM       = mt_lutxy (EEM, EM, "x y -").mt_xxflate_multi (mode="inflate", radius=radius).
             \ mt_lut ("x "+String (a1)+" "+String (a3)+" / 255 * - 4 *").Grayscale ()
    RMask1   = mt_logic (sharp.RMask1_16_8 (mthr=mthr, tv_range=tv_range), source.RMask1_16_8 (mthr=mthr, tv_range=tv_range), "max")
    RMask2   = mt_logic (sharp.RMask2_16_8 (tv_range=tv_range), source.RMask2_16_8 (tv_range=tv_range), "max")
    Mask     = mt_logic (RM, RMask1, "min").mt_logic (RMask2, "min")
    dr       = minblur.Dither_limit_dif16 (sharp, thr=12.0, elast=3.00, y=3, u=3, v=3)

    return Dither_Merge16_8 (sharp, dr, Mask, luma=True, y=3, u=3, v=3)
}

Function mt_xxflate_multi (clip input, string "mode", int "radius", int "a")
{
    mode     = Default (mode, "inflate")
    radius   = Default (radius, 1)
    a        = Default (a, radius)

    (mode == "inflate") ? input.mt_inflate () :
  \ (mode == "deflate") ? input.mt_deflate () : Assert (1>2,"Invalid Mode !")

    a        = a-1

    return (a > 0) ? last.mt_xxflate_multi (mode=mode, a=a)
  \                : last
}

Function Deconv16 (clip input, float "wn", int "x", int "y", int "lx", int "ty", int "rx", int "by", int "elx", int "ety", float "fr", float "scale",
         \         bool "dif", string "matrix", string "curve", bool "tv_range")
{
    w          = input.width ()
    h          = input.height ()/2
    HD         = (w > 1024 || h > 576) ? True : False
    matrix     = Default (matrix, HD ? "709" : "601")
    curve      = Default (curve, "srgb")
    sCSP       = input.GetCSP ()
    wn         = Default (wn, 0.32)
    x          = Default (x, 1)
    y          = Default (y, 1)
    lx         = Default (lx, UnDefined ())
    ty         = Default (ty, UnDefined ())
    rx         = Default (rx, UnDefined ())
    by         = Default (by, UnDefined ())
    elx        = Default (elx, UnDefined ())
    ety        = Default (ety, UnDefined ())
    fr         = Default (fr, 99.99)
    scale      = Default (scale, 0.48)
    dif        = Default (dif, False)
    tv_range   = Default (tv_range, True)

    RGB48Y     = sCSP=="Y8" ? input : 
                            \ input.EDIResize16 (output="RGB48Y", edimode="eedi3+nnedi3_repaired", tv_range=tv_range, matrix=matrix, noring=true)
    Upsample   = RGB48Y.EDIResize16 (w*2, h*2, edimode="eedi3+nnedi3_repaired", noring=true, curve=curve, tv_range=False).YTo420_16 ()
    DeconvU    = Upsample.DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale, tv_range=False).
                         \DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale, tv_range=False)
    UDif       = Dither_sub16 (DeconvU, Upsample, dif=True, y=3, u=3, v=3).
               \ EDIResize16 (w, h, kernel_d="cubic", kernel_u="cubic", a1=-1, a2=0, noring=True, curve=curve, tv_range=False).
               \ Dither_lut16 ("x 32768 - 0.64 * 32768 +", y=3, u=3, v=3).
               \ ConvertToY8 ()
    DeconvL    = RGB48Y.YTo420_16 ().
               \ DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale, tv_range=False).
               \ ConvertToY8 ()
    LDif       = Dither_sub16 (DeconvL, RGB48Y, dif=True, y=3, u=3, v=3).
               \ Dither_lut16 ("x 32768 - 0.36 * 32768 +", y=3, u=3, v=3)
    MDif       = Dither_add16 (LDif, UDif, dif=True, y=3, u=3, v=3)
    Sharp      = RGB48Y.Dither_add16 (MDif, dif=True, y=3, u=3, v=3)

    output     = dif ? MDif : Sharp

    return output
}

Function DeconvKernel16 (clip input, float "wn", int "x", int "y", int "lx", int "ty", int "rx", int "by", int "elx", int "ety", float "fr", float "scale", bool "tv_range")
{
    wn       = Default (wn, 0.32)
    x        = Default (x, 1)
    y        = Default (y, 1)
    lx       = Default (lx, UnDefined ())
    ty       = Default (ty, UnDefined ())
    rx       = Default (rx, UnDefined ())
    by       = Default (by, UnDefined ())
    elx      = Default (elx, UnDefined ())
    ety      = Default (ety, UnDefined ())
    fr       = Default (fr, 99.99)
    scale    = Default (scale, 0.48)
    tv_range = Default (tv_range, True)

    input8   = input.Round8 (tv_range=tv_range).AssumeFieldBased ()
    color    = input8.FQRestore (line=False, wn=wn, x=0, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, oval=False, fr=fr, scale=scale).AssumeFrameBased ().Convert8To16 (tv_range=tv_range)
    deconv   = input8.FQRestore (line=False, wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, oval=False, fr=fr, scale=scale).AssumeFrameBased ().Convert8To16 (tv_range=tv_range)
    colordif = Dither_sub16 (input, color, dif=True, y=3, u=3, v=3)
    fixed    = Dither_add16 (deconv, colordif, dif=True, y=3, u=3, v=3)

    return fixed
}

Function ShrinkSharp16 (clip input, clip "original", float "str", bool "tv_range")
{
    original = Default (original, input)
    str      = Default (str, 1.00)
    tv_range = Default (tv_range, True)

    ECleanse = input.EdgeCleanse16 (original=original, tv_range=tv_range)
    EShrink  = ECleanse.EdgeShrink16 (str=str*3)

    return EShrink
}

Function CubicSharp16 (clip input, float "str", string "matrix", string "curve", bool "tv_range")
{
    str        = Default (str, 1.00)
    tv_range   = Default (tv_range, True)
    w          = input.width ()
    h          = input.height ()/2
    HD         = (w > 1024 || h > 576) ? True : False
    matrix     = Default (matrix, HD ? "709" : "601")
    curve      = Default (curve, "srgb")
    sCSP       = input.GetCSP ()

    RGB48Y     = sCSP=="Y8" ? input : 
                            \ input.EDIResize16 (output="RGB48Y", edimode="eedi3+nnedi3_repaired", tv_range=tv_range, matrix=matrix, noring=true)
    Linear     = RGB48Y.Dither_y_gamma_to_linear (tv_range_in=False, tv_range_out=False, curve=curve, u=1, v=1, sigmoid=True)
    Upsample   = Linear.EDIResize16 (w*2, h*2, edimode="eedi3+nnedi3_repaired", noring=true, curve="linear", tv_range=False)
    Blur       = Upsample.CubicBlur16 ().CubicBlur16 ().CubicBlur16 ()
    SDif       = Dither_sub16 (Upsample, Blur, dif=True, y=3, u=3, v=3)
    BDif       = SDif.Dither_lut16 ("x = 32768", y=3, u=3, v=3)
    LDif       = BDif.Dither_limit_dif16 (SDif, thr=4.00, elast=3.00, y=3, u=3, v=3)
    Dif        = Dither_sub16 (SDif, LDif, dif=True, y=3, u=3, v=3).
               \ EDIResize16 (w, h, kernel_d="cubic", kernel_u="cubic", a1=-1, a2=0, noring=True, curve="linear", tv_range=False)
    GDif       = Dif.Dither_y_linear_to_gamma (tv_range_in=False, tv_range_out=False, curve=curve, u=1, v=1, sigmoid=True)
    Sharp      = RGB48Y.Dither_add16 (Dif, dif=True, y=3, u=3, v=3)
    LSharp     = RGB48Y.SharpLimit16 (sharp=Sharp, str=str)

    return LSharp
}

Function CubicBlur16 (clip input)
{
    w        = input.Width ()
    h        = input.Height ()/2

    Blur     = input.Dither_resize16nr (w*4, h*4, kernel="cubic", a1=1, a2=0)
    Sharp    = input.Dither_resize16nr (w*4, h*4, kernel="cubic", a1=-1, a2=0)
    Dif      = Dither_sub16 (Blur, Sharp, dif=True, y=3, u=3, v=3).Dither_resize16nr (w, h, kernel="cubic", a1=-1, a2=0)

    output   = input.Dither_add16  (Dif, dif=True, y=3, u=3, v=3)

    return output
}

Function SharpLimit16 (clip input, clip "sharp", float "str")
{
    sharp    = Default (sharp, UnDefined ())
    str      = Default (str, 1.00)

    Sharpdif = Dither_sub16 (sharp, input, dif=True, y=3, u=3, v=3)
    Dif      = Dither_lut16 (Sharpdif, "x 256 / 128 - abs 4 / 1 4 / ^ 4 * "+String (str)+" * x 256 / 128 - x 256 / 128 - abs 1.001 + / * 128 + 256 *", y=3, u=3, v=3)

    output   = input.Dither_add16 (Dif, dif=True, y=3, u=3, v=3)

    return output
}

Function EdgeShrink16 (clip input, float "str")
{
    str       = Default (str, 3.00)

    ShrinkV   = input.ShrinkKernel16 (str=str)
    Flip      = StackVertical (ShrinkV.Dither_get_msb ().TurnLeft (), ShrinkV.Dither_get_lsb ().TurnLeft ())
    Shrink    = Flip.ShrinkKernel16 (str=str)

    output    = StackVertical (Shrink.Dither_get_msb ().TurnRight (), Shrink.Dither_get_lsb ().TurnRight ())

    return output
}

Function ShrinkKernel16 (clip input, float "str")
{
    str       = Default (str, 3.00)

    Blur      = input.Dither_Median16 (rx=0, ry=1, rt=0).Dither_Repair16 (input, 16, 16, 16)
    Dif       = Dither_sub16 (blur, input, dif=true, y=3, u=3, v=3).Dither_lut16 ("x 32768 - "+String (str)+" * 32768 +", y=3, u=3, v=3).Dither_removegrain16 (11, 11, 11)
    BlurD     = Dif.SBR16 ()
    BlankD    = Dif.Dither_lut16 ("x = 32768")
    MaxD      = Dither_max_dif16 (Dif, BlurD, BlankD, y=3, u=3, v=3)
    CDMask    = Dither_sub16 (MaxD, BlurD, dif=true, y=3, u=3, v=3).Dither_lut16 ("x 32768 = 0 65535 ?", y=3, u=3, v=3)
    FDif      = Dither_merge16 (BlurD, BlankD, CDMask, luma=False, y=3, u=3, v=3)
    
    output    = input.Dither_add16 (FDif, dif=true, y=3, u=3, v=3)

    return output
}

Function EdgeCleanse16 (clip input, clip "original", int "radius", int "mthr", bool "tv_range")
{
    original  = Default (original, UnDefined ())
    radius    = Default (radius, 1)
    mthr      = Default (mthr, 150)
    tv_range  = Default (tv_range, True)

    ring      = Defined (original) ? original.Ring16 () : input.Ring16 ()
    soft      = Defined (original) ? original : input
    EBlur     = input.MinBlur16 (radius)
    Mask      = mt_lutxy (mt_logic (mt_logic (input.RMask1_16_8 (mthr, tv_range=tv_range), 
                                    \          ring.RMask1_16_8 (mthr, tv_range=tv_range), "max"), 
                          \         input.RMask2_16_8 (tv_range=tv_range), "and"), 
                \         soft.MinBlur_SBR16 ().ComplexProtectMask16_8 (tv_range=tv_range), "x y -").Grayscale ()

    output    = Dither_merge16_8 (input, EBlur, Mask, luma=True, y=3, u=3, v=3)

    return output
}

Function MaxMulti (clip input, clip "start", int "a", int "tr")
{
    tr       = Default (tr, 3)
    start    = Default (start, Mt_logic (input.SelectEvery (tr*2+1, 0), input.SelectEvery (tr*2+1, 1), "max", y=3, u=3, v=3))
    a        = Default (a, 2)

    max      = Mt_logic (start, input.SelectEvery (tr*2+1, a), "max", y=3, u=3, v=3)
    a        = a+1

    output   = (a == tr*2+1) ? max : input.MaxMulti (start=max, tr=tr, a=a)

    return output
}

Function MinMulti (clip input, clip "start", int "a", int "tr")
{
    tr       = Default (tr, 3)
    start    = Default (start, Mt_logic (input.SelectEvery (tr*2+1, 0), input.SelectEvery (tr*2+1, 1), "min", y=3, u=3, v=3))
    a        = Default (a, 2)

    min      = Mt_logic (start, input.SelectEvery (tr*2+1, a), "min", y=3, u=3, v=3)
    a        = a+1

    output   = (a == tr*2+1) ? min : input.MinMulti (start=min, tr=tr, a=a)

    return output
}

Function Round2MOD4 (float x) 
{
    output     = (x<4) ? 4 : int (round (x/4)*4)

    return output
}

Function RMask1_16_8 (clip input, int "mthr", bool "tv_range")
{
    mthr          = Default (mthr, 150)
    tv_range      = Default (tv_range, True)

    inputlow      = input.Round8 (tv_range=tv_range).Grayscale ()
    prewittm      = inputlow.mt_edge ("prewitt", mthr, 255, 0, 0)
    fmask         = mt_hysteresis (prewittm.RemoveGrain (4), prewittm)
    omask         = fmask.mt_expand ().mt_inflate ()
    imask         = fmask.mt_inflate ().mt_inpand ()

    output        = omask.mt_lutxy (imask, "x 255 y - * 255 /").Grayscale ()

    return output
}

Function RMask2_16_8 (clip input, bool "tv_range")
{
    tv_range      = Default (tv_range, True)

    w             = input.width ()
    h             = input.height ()/2
    inputlow      = input.dither_resize16 (Round2MOD4 (w/2), Round2MOD4 (h/2), kernel="bicubic").Round8 (tv_range=tv_range).Grayscale ()
    mask_f        = mt_lutxy (inputlow.mt_expand(), inputlow.mt_inpand(), "x y - 4 *").RemoveGrain (20).BicubicResize(w, h, b=1.0, c=0)

    output        = mask_f.mt_lut("255 255 48 - 255 192 - - / x 48 - *").Grayscale ()

    return output
}

Function ComplexProtectMask16_8 (clip input, bool "tv_range")
{
    tv_range  = Default (tv_range, True)

    input.Round8 (tv_range=tv_range).Grayscale ()
    dif_med   = mt_makediff (mt_luts (last, "med", pixels=mt_circle (3), expr="y"))
    c_mask    = mt_lutsx (dif_med, dif_med, dif_med, "std", pixels=mt_circle (3), expr="y 2 ^")

    output    = mt_logic (c_mask.mt_expand ().mt_inflate (),
              \           c_mask.mt_expand_multi (sw=4, sh=4).mt_inpand_multi (sw=4, sh=4).mt_lut ("x 99 / 255 *"),
              \           "max").RemoveGrain (20).mt_lut ("x 5 195 / 255 * -").mt_lut ("x 5 195 / 255 * -").Grayscale ()

    return output
}

Function Ring16 (clip input)
{
    Blur   = input.Dither_removegrain16 (20, 20, 20)
    Dif    = Dither_sub16 (input, Blur, dif=true, y=3, u=3, v=3)

    output = input.Dither_add16 (Dif, dif=true, y=3, u=3, v=3)

    return output
}
