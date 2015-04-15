Function GenLimitClip16 (clip input, bool "CM", float "str", clip "original", int "repmode")
{
    CM         = Default (CM, True)
    str        = Default (str, 3.00)
    original   = Default (original, input)
    repmode    = Default (repmode, 1)

    Sharp      = CM ? input.CMSharp16(str=str) : input.ShrinkSharp16 (original=original, str=str)
    Rep        = Sharp.Dither_repair16 (input, mode=repmode)
    Limit      = input.SharpLimit16 (Rep, str=1.00)

    return Limit
}

Function CMSharp16 (clip input, float "str")
{
    str        = Default (str, 1.00)
    w          = input.width ()
    h          = input.height ()/2

    Upsample   = input.EDIResize16 (w*2, h*2, edimode="nnedi3", noring=true, pscrn=2, nsize=1)
    CBlurU     = Upsample.CBlur16 ().CBlur16 ().CBlur16 ()
    CDif       = Dither_sub16 (CBlurU, Upsample, dif=True, y=3, u=1, v=1).
               \ Dither_resize16 (w, h, kernel="cubic", a1=-1, a2=0)
    CBlur      = input.Dither_add16 (CDif, dif=True, y=3, u=1, v=1)
    MBlur      = input.Dither_median16 (1, 1, 0, y=3, u=1, v=1)
    Blur       = Dither_min_dif16 (CBlur, MBlur, input)
    Dif        = Dither_sub16 (input, Blur, dif=True, y=3, u=1, v=1)
    Sharp      = Dither_add16 (input, Dif, dif=True, y=3, u=1, v=1)
    LSharp     = input.SharpLimit16 (sharp=Sharp, str=str)

    return LSharp
}

Function CBlur16 (clip input)
{
    w        = input.Width ()
    h        = input.Height ()/2

    Blur     = input.Dither_resize16 (w*4, h*4, kernel="cubic", a1=1, a2=0)
    Sharp    = input.Dither_resize16 (w*4, h*4, kernel="cubic", a1=-1, a2=0)
    Dif      = Dither_sub16 (Blur, Sharp, dif=True, y=3, u=1, v=1).Dither_resize16 (w, h, kernel="cubic", a1=-1, a2=0)

    output   = input.Dither_add16  (Dif, dif=True, y=3, u=1, v=1)

    return output
}

Function HaloCancelation16 (clip sharp, clip "source", clip "minblur", clip "detect", int "a1", int "a2", int "a3", int "radius", int "mthr")
{
    source   = Default (source, UnDefined ())
    minblur  = Default (minblur, UnDefined ())
    detect   = Default (detect, UnDefined ())
    a1       = Default (a1, 16)
    a2       = Default (a2, 96)
    a3       = Default (a3, 128)
    radius   = Default (radius, 4)
    mthr     = Default (mthr, 60)

    detect.Ditherpost (mode=-1)
    EM       = TEMMod (ThreshY=0, type=1).mt_lut ("x "+String (a1)+" "+String (a3)+" / 255 * - 4 *")
    EEM      = EM.mt_expand ().mt_lut ("x "+String (a2)+" "+String (a3)+" / 255 * - 4 *")
    RM       = mt_lutxy (EEM, EM, "x y -").mt_xxflate_multi (mode="inflate", radius=radius).
             \ mt_lut ("x "+String (a1)+" "+String (a3)+" / 255 * - 4 *")
    RMask1   = mt_logic (sharp.RMask1_16_8 (mthr=mthr), source.RMask1_16_8 (mthr=mthr), "max")
    RMask2   = mt_logic (sharp.RMask2_16_8 (), source.RMask2_16_8 (), "max")
    Mask     = mt_logic (RM, RMask1, "min").mt_logic (RMask2, "min")
    dr       = minblur.Dither_limit_dif16 (sharp, thr=12.0, elast=3.00, y=3, u=-1, v=-1)

    return Dither_Merge16_8 (sharp, dr, Mask, luma=True, y=3, u=-1, v=-1)
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

Function MBlur16 (clip input, clip "blur", clip "superclip", clip "vclip", int "pel", int "tr", int "thsad", int "thscd1", int "thscd2", int "repmode")
{
    blur       = Default (blur, UnDefined ())
    superclip  = Default (superclip, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    thscd1     = Default (thscd1, 248)
    thscd2     = Default (thscd2, 130)
    repmode    = Default (repmode, 1)

    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = input.Ditherpost (mode=-1).ConvertToYV12 ().MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=superclip.ConvertToYV12 (), sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = blur.Ditherpost (mode=-1).ConvertToYV12 ().MDegrainN (supercomp, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=thscd1, thSCD2=thscd2, plane=0, limit=255, lsb=True).ConvertToY8 ()
    rep        = comp.Dither_repair16 (blur, mode=repmode, modeu=-1, modev=-1)

    return rep
}

Function Deconv16 (clip input, float "wn", int "x", int "y", int "lx", int "ty", int "rx", int "by", int "elx", int "ety", float "fr", float "scale",
         \         bool "dif")
{
    w          = input.width ()
    h          = input.height ()/2
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

    Upsample   = input.EDIResize16 (w*2, h*2, edimode="nnedi3", noring=true, pscrn=2, nsize=1).YTo420_16 ()
    DeconvU    = Upsample.DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale).
                         \DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale)
    UDif       = Dither_sub16 (DeconvU, Upsample, dif=True, y=3, u=1, v=1).
               \ Dither_resize16 (w, h, kernel="cubic", a1=-1, a2=0).
               \ Dither_lut16 ("x 32768 - 0.64 * 32768 +", y=3, u=1, v=1).
               \ ConvertToY8 ()
    DeconvL    = input.YTo420_16 ().
               \ DeconvKernel16 (wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, fr=fr, scale=scale).
               \ ConvertToY8 ()
    LDif       = Dither_sub16 (DeconvL, input, dif=True, y=3, u=1, v=1).
               \ Dither_lut16 ("x 32768 - 0.36 * 32768 +", y=3, u=1, v=1)
    MDif       = Dither_add16 (LDif, UDif, dif=True, y=3, u=1, v=1)
    Sharp      = input.Dither_add16 (MDif, dif=True, y=3, u=1, v=1)

    output     = dif ? MDif : Sharp

    return output
}

Function DeconvKernel16 (clip input, float "wn", int "x", int "y", int "lx", int "ty", int "rx", int "by", int "elx", int "ety", float "fr", float "scale")
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

    input8   = input.Ditherpost (mode=-1).AssumeFieldBased ()
    color    = input8.FQRestore (line=False, wn=wn, x=0, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, oval=False, fr=fr, scale=scale).AssumeFrameBased ().Dither_convert_8_to_16 ()
    deconv   = input8.FQRestore (line=False, wn=wn, x=x, y=y, lx=lx, ty=ty, rx=rx, by=by, elx=elx, ety=ety, oval=False, fr=fr, scale=scale).AssumeFrameBased ().Dither_convert_8_to_16 ()
    colordif = Dither_sub16 (input, color, dif=True, y=3, u=1, v=1)
    fixed    = Dither_add16 (deconv, colordif, dif=True, y=3, u=1, v=1)

    return fixed
}

Function SpatialNR (clip input, clip "NLM", clip "DFT", int "bot", int "lp", int "repmode")
{
   bot     = Default (bot, 4)
   lp      = Default (lp, 12)
   repmode = Default (repmode, 17)

   Gauss   = input.Gauss16 (p=bot)
   DFTL    = DFT.Gauss16 (p=lp)
   NLML    = NLM.Gauss16 (p=lp)
   NLMH    = Dither_sub16 (NLM, NLML, dif=True)
   MergeNR = Dither_add16 (DFTL, NLMH, dif=True)
   Min     = Dither_min_dif16 (MergeNR, Gauss, input)

   return Min.Dither_repair16 (MergeNR, repmode, -1, -1)
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

Function ShrinkSharp16 (clip input, clip "original", float "str")
{
    original = Default (original, input)
    str      = Default (str, 1.00)

    ECleanse = input.EdgeCleanse16 (original=original)
    EShrink  = ECleanse.EdgeShrink16 (str=str*3)

    return EShrink
}

Function EdgeCleanse16 (clip input, clip "original", int "radius", int "mthr")
{
    original  = Default (original, UnDefined ())
    radius    = Default (radius, 1)
    mthr      = Default (mthr, 150)

    ring      = Defined (original) ? original.Ring16 () : input.Ring16 ()
    soft      = Defined (original) ? original : input
    EBlur     = input.MinBlur16 (radius)
    Mask      = mt_lutxy (mt_logic (mt_logic (input.RMask1_16_8 (mthr), ring.RMask1_16_8 (mthr), "max"), input.RMask2_16_8 (), "and"), soft.MinBlur_SBR16 ().ComplexProtectMask16_8 (), "x y -")

    output    = Dither_merge16_8 (input, EBlur, Mask, luma=True, y=3, u=1, v=1)

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

    Blur      = input.Dither_Median16 (rx=0, ry=1, rt=0).Dither_Repair16 (input, 16, -1, -1)
    Dif       = Dither_sub16 (blur, input, dif=true, y=3, u=1, v=1).Dither_lut16 ("x 32768 - "+String (str)+" * 32768 +", y=3, u=1, v=1).Dither_removegrain16 (11, -1, -1)
    BlurD     = Dif.SBR16 ()
    BlankD    = Dif.Dither_lut16 ("x", y=-32768, u=-32768, v=-32768)
    MaxD      = Dither_max_dif16 (Dif, BlurD, BlankD, y=3, u=1, v=1)
    CDMask    = Dither_sub16 (MaxD, BlurD, dif=true, y=3, u=1, v=1).Dither_lut16 ("x 32768 = 0 65535 ?", y=3, u=1, v=1)
    FDif      = Dither_merge16 (BlurD, BlankD, CDMask, luma=False, y=3, u=1, v=1)
    
    output    = input.Dither_add16 (FDif, dif=true, y=3, u=1, v=1)

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

Function Ring16 (clip input)
{
    Blur   = input.Dither_removegrain16 (20, -1, -1)
    Dif    = Dither_sub16 (input, Blur, dif=true, y=3, u=1, v=1)

    output = input.Dither_add16 (Dif, dif=true, y=3, u=1, v=1)

    return output
}

Function RMask1_16_8 (clip input, int "mthr")
{
    mthr          = Default (mthr, 150)

    inputlow      = input.Ditherpost (mode=-1)
    prewittm      = inputlow.mt_edge ("prewitt", mthr, 255, 0, 0)
    fmask         = mt_hysteresis (prewittm.RemoveGrain (4, -1, -1), prewittm)
    omask         = fmask.mt_expand ().mt_inflate ()
    imask         = fmask.mt_inflate ().mt_inpand ()

    output        = omask.mt_lutxy (imask, "x 255 y - * 255 /")

    return output
}

Function RMask2_16_8 (clip input)
{
    w             = input.width ()
    h             = input.height ()/2
    inputlow      = input.dither_resize16 (Round2MOD4 (w/2), Round2MOD4 (h/2), kernel="cubic").Ditherpost (mode=-1)
    mask_f        = mt_lutxy (inputlow.mt_expand(), inputlow.mt_inpand(), "x y - 4 *").RemoveGrain (20, -1, -1).BicubicResize(w, h, b=1.0, c=0)

    output        = mask_f.mt_lut("255 255 48 - 255 192 - - / x 48 - *")

    return output
}

Function ComplexProtectMask16_8 (clip input)
{
    input.Ditherpost (mode=-1)
    dif_med   = mt_makediff (mt_luts (last, "med", pixels=mt_circle (3), expr="y"))
    c_mask    = mt_lutsx (dif_med, dif_med, dif_med, "std", pixels=mt_circle (3), expr="y 2 ^")

    output    = mt_logic (c_mask.mt_expand ().mt_inflate (),
              \           c_mask.mt_expand_multi (sw=4, sh=4).mt_inpand_multi (sw=4, sh=4).mt_lut ("x 99 / 255 *"),
              \           "max").RemoveGrain (20, -1, -1).mt_lut ("x 5 195 / 255 * -").mt_lut ("x 5 195 / 255 * -")

    return output
}

Function Round2MOD4 (float x) 
{
    output     = (x<4) ? 4 : int (round (x/4)*4)

    return output
}

Function MinBlur_SBR16 (clip input)
{
    rg11D    = Dither_sub16 (input, input.SBR16 (), dif=True, y=3, u=1, v=1)
    rg4D     = Dither_sub16 (input, input.Dither_median16 (1, 1, 0, y=3, u=1, v=1), dif=True, y=3, u=1, v=1)
    DD       = Dither_diff_compromise16 (RG11D, RG4D)

    output   = input.Dither_sub16 (DD, dif=True, y=3, u=1, v=1)

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

Function MinBlur16 (clip input, int "radius")
{
    radius   = Default (radius, 1)
    
    RG11     = (radius==1) ? input.Dither_removegrain16 (11, -1, -1)
    \        : (radius==2) ? input.Dither_removegrain16 (11, -1, -1).Dither_removegrain16 (20, -1, -1)
    \        : (radius==3) ? input.Dither_removegrain16 (11, -1, -1).Dither_removegrain16 (20, -1, -1).Dither_removegrain16 (20, -1, -1)
    \        : Assert (1>2, "radius must be 1-3!")

    RG4      = (radius==1) ? input.Dither_median16 (1, 1, 0, y=3, u=1, v=1)
    \        : (radius==2) ? input.Dither_median16 (2, 2, 0, y=3, u=1, v=1)
    \        : (radius==3) ? input.Dither_median16 (3, 3, 0, y=3, u=1, v=1)
    \        : Assert (1>2, "radius must be 1-3!")

    output   = Dither_min_dif16 (RG11, RG4, input)
    
    return output
}

Function Gauss16 (clip input, int "p")
{
    p          = Default (p, 12)
    w          = input.width ()
    h          = input.height ()/2

    Upsample   = input.Dither_resize16 (w * 2, h * 2, kernel="gauss", a1=100)
    Gauss      = Upsample.Dither_resize16 (w, h, kernel="gauss", a1=p)

    return Gauss
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

Function DifCleanse16 (clip spatial, clip "dif", clip "superdif", clip "vclip", clip "repclip", int "pel", int "tr", int "thsad", int "thscd1", int "thscd2", int "repmode")
{
    dif        = Default (dif, UnDefined ())
    superdif   = Default (superdif, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    repclip    = Default (repclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 4800)
    thscd1     = Default (thscd1, 248)
    thscd2     = Default (thscd2, 130)
    repmode    = Default (repmode, 13)

    difL       = dif.Ditherpost (mode=-1).ConvertToYV12 ()
    bdif       = difL.mt_lut ("128", y=3, u=3, v=3)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = difL.MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=superdif.ConvertToYV12 (), sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = bdif.MDeGrainN (supercomp, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=thscd1, thSCD2=thscd2, plane=0, limit=255, lsb=True)
    NR         = Dither_add16 (spatial, comp.ConvertToY8 (), dif=True)
    rep        = NR.Dither_repair16 (repclip, mode=repmode, modeu=-1, modev=-1)

    return Dither_sub16 (rep, spatial, dif=True)
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

Function GenSuperclip16 (clip input, int "pel", bool "dither")
{
    pel        = Default (pel, 4)
    dither     = Default (dither, True)
    w          = input.width ()
    h          = input.height ()/2

    Upsample   = (pel==2) ? input.EDIResize16 (w*2, h*2, src_left=0.25, src_top=0.25, edimode="nnedi3", noring=true, pscrn=2, nsize=1)
             \ : (pel==4) ? input.EDIResize16 (w*4, h*4, src_left=0.375, src_top=0.375, edimode="nnedi3", noring=true, pscrn=2, nsize=1)
             \ : Assert (1>2,"Invalid pel value !")

    return dither ? Upsample.Ditherpost (mode=6) : Upsample.Ditherpost (mode=-1)
}

Function EDIResize16 (clip input, int "target_width", int "target_height", float "src_left", float "src_top",
         \            float "src_width", float "src_height",
         \            string "edimode", string "kernel_d", string "kernel_u", float "f_d", float "f_u", int "taps",
         \            float "a1", float "a2", float "a3", bool "invks_d", bool "invks_u", int "invkstaps", bool "noring",
         \            float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \            bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", bool "mclip", 
         \            int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads",
         \            int "repmode", int "repmodeu", int "repmodev",
         \            float "ratiothr", float "lthr", float "elast",
         \            string "output", bool "tv_range", string "cplace", string "matrix", string "curve", float "gcor", bool "sigmoid", float "gthr", float "cont")
{
    sCSP   = input.GetCSP ()
    Assert (sCSP=="Y8" || sCSP=="YV12" || sCSP=="YV16" || sCSP=="YV24", "EDIResize16: Only Support Planar YUV Colorspaces (Y8, YV12, YV16, YV24)")
    sw     = input.Width ()
    sh     = input.Height ()/2
    swc    = sCSP=="YV24" ? sw   : sw/2
    shc    = sCSP=="YV12" ? sh/2 : sh
    HD     = (sw > 1024 || sh > 576) ? True : False

    ow         = Default (target_width, sw)
    oh         = Default (target_height, sh)
    src_left   = Default (src_left, 0)
    src_top    = Default (src_top, 0)
    src_width  = Default (src_width, sw)
    src_height = Default (src_height, sh)
    ratiothr   = Default (ratiothr, 1.000)
    lthr       = Default (lthr, 1.0)
    elast      = Default (elast, 1.5)
    alpha      = Default (alpha, 0.2)
    beta       = Default (beta, 0.125)
    gamma      = Default (gamma, 60.0)
    nrad       = Default (nrad, 3)
    mdis       = Default (mdis, 40)
    hp         = Default (hp, False)
    ucubic     = Default (ucubic, True)
    cost3      = Default (cost3, True)
    vcheck     = Default (vcheck, 2)
    vthresh0   = Default (vthresh0, 32.0)
    vthresh1   = Default (vthresh1, 64.0)
    vthresh2   = Default (vthresh2, 4.0)
    sclip      = Default (sclip, UnDefined())
    mclip      = Default (mclip, False)
    nsize      = Default (nsize, 2)
    nns        = Default (nns, 4)
    qual       = Default (qual, 2)
    etype      = Default (etype, 0)
    pscrn      = Default (pscrn, 0)
    threads    = Default (threads, 0)
    repmode    = Default (repmode, 13)
    repmodeu   = Default (repmodeu, repmode)
    repmodev   = Default (repmodev, repmode)
    edimode    = Default (edimode, "eedi3")
    kernel_d   = Default (kernel_d, "Spline")
    kernel_u   = Default (kernel_u, "Spline")
    f_d        = Default (f_d, 1.0)
    f_u        = Default (f_u, 1.0)
    taps       = Default (taps, 32)
    a1         = Default (a1, UnDefined ())
    a2         = Default (a2, UnDefined ())
    a3         = Default (a3, UnDefined ())
    invks_d    = Default (invks_d, False) 
    invks_u    = Default (invks_u, False)
    invkstaps  = Default (invkstaps, 64)
    noring     = Default (noring, False)
    tv_range   = Default (tv_range, True)
    output     = Default (output, sCSP)
    cplace     = Default (cplace, "MPEG2")
    matrix     = Default (matrix, HD ? "709" : "601")
    curve      = Default (curve, "linear")
    gcor       = Default (gcor, 1.0)
    sigmoid    = Default (sigmoid, True)
    gthr       = Default (gthr, UnDefined())
    cont       = Default (cont, UnDefined())

    IsY8   = sCSP == "Y8" || output == "Y8"
    sCSP   = IsY8 ? "YV24" : sCSP
    
    IsRGB  = LeftStr (output, 3) == "RGB"
    oCSP   = IsRGB || IsY8 ? "YV24" : output

    Y      = 3
    U      = IsY8 ? 1 : 3
    V      = IsY8 ? 1 : 3
    Yt     = Y == 3 || Y == 4
    Ut     = U == 3 || U == 4
    Vt     = V == 3 || V == 4
    Y31    = Yt ? 3 : 1
    U31    = Ut ? 3 : 1
    V31    = Vt ? 3 : 1
    Y32    = Yt ? 3 : Y
    U32    = Ut ? 3 : U
    V32    = Vt ? 3 : V
    Y21    = Yt ? 2 : Y
    U21    = Ut ? 2 : U
    V21    = Vt ? 2 : V
    Y321   = Y > 1 ? 3 : Y
    U321   = U > 1 ? 3 : U
    V321   = V > 1 ? 3 : V

    curve      = Yt ? curve : "linear"

    owc    = oCSP=="YV24" ? ow : ow/2
    ohc    = oCSP=="YV12" ? oh/2 : oh
    Assert (!(output=="YV16" && ow!=owc*2), "EDIResize16: Width of YV16 Output Clip Must Be MOD2!")
    Assert (!(output=="YV12" && ow!=owc*2), "EDIResize16: Width of YV12 Output Clip Must Be MOD2!")
    Assert (!(output=="YV12" && oh!=ohc*2), "EDIResize16: Height of YV12 Output Clip Must Be MOD2!")

    prel        = int(src_left/2) * 2
    pret        = int(src_top /2) * 2
    prer        = int((src_width > 0 ? -sw+src_left+src_width : src_width )/2) * 2
    preb        = int((src_height> 0 ? -sh+src_top+src_height : src_height)/2) * 2
    prew        = sw - prel + prer
    preh        = sh - pret + preb
    
    sCSP=="YV24" ? \
    Eval ("""
        swmod2      = sw  /2*2 == sw
        pwmod2      = prew/2*2 == prew
        wpre        = prew < sw
        prel        = wpre ?          prel            :          0
        prer        = wpre ? pwmod2 ? prer : prer + 1 : swmod2 ? 0 : 1
        prew        = sw - prel + prer
        wpre        = prew < sw || !swmod2
    """) : \
    Eval ("""
        swmod4      = sw  /4*4 == sw
        pwmod4      = prew/4*4 == prew
        wpre        = prew < sw
        prel        = wpre ?          prel            :          0
        prer        = wpre ? pwmod4 ? prer : prer + 2 : swmod4 ? 0 : 2
        prew        = sw - prel + prer
        wpre        = prew < sw || !swmod4
    """)
    
    sCSP=="YV12" ? \
    Eval ("""
        shmod4      = sh  /4*4 == sh
        phmod4      = preh/4*4 == preh
        hpre        = preh < sh
        pret        = hpre ?          pret            :          0
        preb        = hpre ? phmod4 ? preb : preb + 2 : shmod4 ? 0 : 2
        preh        = sh - pret + preb
        hpre        = preh < sh || !shmod4
    """) : \
    Eval ("""
        shmod2      = sh  /2*2 == sh
        phmod2      = preh/2*2 == preh
        hpre        = preh < sh
        pret        = hpre ?          pret            :          0
        preb        = hpre ? phmod2 ? preb : preb + 1 : shmod2 ? 0 : 1
        preh        = sh - pret + preb
        hpre        = preh < sh || !shmod2
    """)
    
    src_width   = src_width <=0 ? +sw-src_left+src_width : src_width
    src_height  = src_height<=0 ? +sh-src_top+src_height : src_height
    src_left    = wpre ? src_left-prel : src_left
    src_top     = hpre ? src_top -pret : src_top
    
    src_leftc   = sCSP=="YV24" ? src_left      : src_left  /2.
    src_topc    = sCSP=="YV12" ? src_top   /2. : src_top
    src_widthc  = sCSP=="YV24" ? src_width     : src_width /2.
    src_heightc = sCSP=="YV12" ? src_height/2. : src_height

    yhratio  = float (ow) / float(src_width)
    yvratio  = float (oh) / float(src_height)
    chratio  = float (owc) / float(src_widthc)
    cvratio  = float (ohc) / float(src_heightc)

    enable   = yhratio!=1 || yvratio!=1 || chratio!=1 || cvratio!=1 ||
    \          src_width  !=int (src_width) || src_height !=int (src_height) || src_widthc !=int (src_widthc) || src_heightc!=int (src_heightc) ||
    \          src_left   !=int (src_left) || src_top    !=int (src_top) || src_leftc  !=int (src_leftc) || src_topc   !=int (src_topc)

    yhct     = yhratio>ratiothr ? Ceil (log (yhratio/ratiothr) / log (2)) : 0
    yhrf     = int (Pow (2, yhct))
    yrhratio = yhratio/yhrf
    yvct     = yvratio>ratiothr ? Ceil (log (yvratio/ratiothr) / log (2)) : 0
    yvrf     = int (Pow (2, yvct))
    yrvratio = yvratio/yvrf
    
    chct     = chratio>ratiothr ? Ceil (log (chratio/ratiothr) / log (2)) : 0
    chrf     = int (Pow (2, chct))
    crhratio = chratio/chrf
    cvct     = cvratio>ratiothr ? Ceil (log (cvratio/ratiothr) / log (2)) : 0
    cvrf     = int (Pow (2, cvct))
    crvratio = cvratio/cvrf

    noneediy  = yhct<=0 && yvct<=0
    noneedic  = chct<=0 && cvct<=0
    noneedi   = noneediy || noneedic
    
    Yedit     = Yt&&!noneediy
    Uedit     = Ut&&!noneedic
    Vedit     = Vt&&!noneedic
    Yedi31    = Yedit ? 3 : 1
    Uedi31    = Uedit ? 3 : 1
    Vedi31    = Vedit ? 3 : 1
    Yedi      = Yt&&noneediy ? 2 : Y
    Uedi      = Ut&&noneedic ? 2 : U
    Vedi      = Vt&&noneedic ? 2 : V

    edit      = Yedit || Uedit || Vedit
    mixed     = !edit || !enable ? False : True

    yhshift   = yhrf>=2 ? 0.5 : 0      
    yvshift   = yvrf>=2 ? 0.5 : 0       
    yhfix     = -yhshift               
    yvfix     = -yvshift               
    
    chshift   = oCSP=="YV24" ? sCSP=="YV24" ?                  chrf>=2 ? 0.50         :  0
    \                                      : cplace=="MPEG1" ? chrf>=2 ? 0.50         :  0
    \                                                        : chrf>=2 ? 0.50-chrf/4. : -0.25
    \                       : sCSP=="YV24" ? cplace=="MPEG1" ? chrf>=2 ? 0.50         :  0
    \                                                        : chrf>=2 ? 0.75         :  0.25
    \                                      : cplace=="MPEG1" ? chrf>=2 ? 0.50         :  0
    \                                                        : chrf>=2 ? 0.75-chrf/4. :  0
	
    cvshift   = cvrf>=2 ? 0.5 : 0       
    chfix     = -chshift                
    cvfix     = -cvshift               
    
    cphfixe   = oCSP=="YV24" ?                  0
    \                       : cplace=="MPEG1" ? 0
    \                                         : 0.25-0.25/crhratio
    
    cphfix    = oCSP=="YV24" ? sCSP=="YV24" ?                  0
    \                                      : cplace=="MPEG1" ? 0
    \                                                        : 0.25
    \                       : sCSP=="YV24" ? cplace=="MPEG1" ? 0
    \                                                        : -0.5
    \                                      : cplace=="MPEG1" ? 0
    \                                                        : 0.25-0.25/chratio

    input  = wpre || hpre ? input.Dither_resize16 (wpre?prew:sw, hpre?preh:sh, wpre?prel:0, hpre?pret:0,
                                  \                wpre?prew:sw, hpre?preh:sh, kernel="point")
    \                     : input
    input8 = input.Round8 (tv_range=tv_range)

    !(enable && edit) ? NOP() : \
    yhct==chct && yvct==cvct && sCSP=="YV12" ? \
    Eval ("""
         edgeedi   = input8.EDICore (vct=yvct, hct=yhct, vfield=1, hfield=1, Y=Yt, U=Ut, V=Vt,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip,
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads, 
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev, edimode=edimode)
    	 edgeedi16 = edgeedi.Convert8To16 (tv_range=tv_range)
    	 edgeediY  = edgeedi16.ConvertToY8 ()
     	 edgeediU  = edgeedi16.UToY8 ()
    	 edgeediV  = edgeedi16.VToY8 ()
    """) : \
    Eval ("""
         edgeediY  = !Yedit ? NOP ()
         \                          : input8.ConvertToYV12 ().EDICore (vct=yvct, hct=yhct, vfield=1, hfield=1, Y=Yt, U=False, V=False,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip,
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads, 
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev, edimode=edimode)
    	 \                                  .ConvertToY8 ().Convert8To16 (tv_range=tv_range)
    	 edgeediU  = !Uedit ? NOP()
    	 \                          : input8.UToY ().EDICore (vct=cvct, hct=chct, vfield=1, hfield=1, Y=Ut, U=False, V=False,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip,
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads, 
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev, edimode=edimode)
    	 \                                  .ConvertToY8 ().Convert8To16 (tv_range=tv_range)
    	 edgeediV  = !Vedit ? NOP()
    	 \                          : input8.VToY ().EDICore (vct=cvct, hct=chct, vfield=1, hfield=1, Y=Vt, U=False, V=False,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip,
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads, 
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev, edimode=edimode)
    	 \                                  .ConvertToY8 ().Convert8To16 (tv_range=tv_range)
    """)

        resste   = "Dither_resize16"
	yrh      = yrhratio>ratiothr
	yrv      = yrvratio>ratiothr
	crh      = crhratio>ratiothr
	crv      = crvratio>ratiothr

    !(enable && edit) ? NOP() : \
    Eval ("""
         edgeediY = !Yedit ? NOP()
         \                 : curve=="linear" ? edgeediY
         \                                   : edgeediY.Dither_y_gamma_to_linear (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                                        \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
         edgeY    = !Yedit ? input.BlankClip (width=ow, height=oh *2, pixel_type="Y8", color_yuv=$008080)
    	 \                 : edgeediY.""" + resste + """ (ow, oh, src_left=src_left*yhrf+yhfix, src_top=src_top*yvrf+yvfix,
         \                                                src_width=src_width*yhrf, src_height=src_height*yvrf,
         \                                                kernelh=yrh ? kernel_u : kernel_d, kernelv=yrv? kernel_u : kernel_d,
	 \                                                fh=yrh ? f_u : f_d, fv=yrv ? f_u : f_d,
	 \                                                invksh=yrh ? invks_u : invks_d, invksv=yrv ? invks_u : invks_d,
	 \                                                taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                                y=Y31, u=1, v=1)
         edgeY   = !Yedit ? edgeY
         \                : curve=="linear" ? edgeY
         \                                  : edgeY.Dither_y_linear_to_gamma (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                                    \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
    	 edgeU   = !Uedit ? input.BlankClip (width=owc, height=ohc*2, pixel_type="Y8", color_yuv=$008080)
    	 \                : edgeediU.""" + resste + """ (owc, ohc, src_left=src_leftc*chrf+chfix+cphfixe, src_top=src_topc*cvrf+cvfix,
         \                                               src_width=src_widthc*chrf, src_height=src_heightc*cvrf,
         \                                               kernelh=crh ? kernel_u : kernel_d, kernelv=crv ? kernel_u : kernel_d,
	 \                                               fh=crh ? f_u : f_d, fv=crv ? f_u : f_d,
	 \                                               invksh=crh ? invks_u : invks_d, invksv=crv ? invks_u : invks_d,
	 \                                               taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                               y=U31, u=1, v=1)
    	 edgeV   = !Vedit ? input.BlankClip (width=owc, height=ohc*2, pixel_type="Y8", color_yuv=$008080)
    	 \                : edgeediV.""" + resste + """ (owc, ohc, src_left=src_leftc*chrf+chfix+cphfixe, src_top=src_topc*cvrf+cvfix,
         \                                               src_width=src_widthc*chrf, src_height=src_heightc*cvrf,
         \                                               kernelh=crh ? kernel_u : kernel_d, kernelv=crv ? kernel_u : kernel_d,
	 \                                               fh=crh ? f_u : f_d, fv=crv ? f_u : f_d,
	 \                                               invksh=crh ? invks_u : invks_d, invksv=crv ? invks_u : invks_d,
	 \                                               taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                               y=V31, u=1, v=1)
    	 edge16  = IsY8 ? edgeY : YToUV (edgeU, edgeV, edgeY)
    """)

        resstf   = noring ? "Dither_resize16nr" : "Dither_resize16"
	yh       = yhratio>ratiothr
	yv       = yvratio>ratiothr
	ch       = chratio>ratiothr
	cv       = cvratio>ratiothr

    !(enable && (mixed || !(Yedit && Uedit && Vedit))) ? NOP() : \
    yhratio==chratio && yvratio==cvratio && (!mixed || (Yedit && Uedit && Vedit)) ? \
    Eval("""
         flat16  = curve=="linear" ? input
         \                         : input.Dither_y_gamma_to_linear (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                             \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
         flat16  =                   flat16.""" + resstf + """
	 \                                           (ow, oh, src_left=src_left, src_top=src_top,
         \                                            src_width=src_width, src_height=src_height, cplace=cplace,
         \                                            kernelh=yh ? kernel_u : kernel_d, kernelv=yv ? kernel_u : kernel_d,
	 \                                            fh=yh ? f_u : f_d, fv=yv ? f_u : f_d,
	 \                                            invksh=yh ? invks_u : invks_d, invksv=yv ? invks_u : invks_d,
	 \                                            taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                            y=Y32, u=U32, v=V32)
         flat16  = curve=="linear" ? flat16
         \                         : flat16.Dither_y_linear_to_gamma (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                            \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
    """) : \
    Eval("""
         flatY   = curve=="linear" ? input.ConvertToY8 () :
	 \         (mixed || !Yedit) && Yt ? input.ConvertToY8 ().Dither_y_gamma_to_linear (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                                                    \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
         \                                 : input.ConvertToY8 ()
         flatY   = (mixed || !Yedit) && Yt ? flatY.""" + resstf + """
	 \                                           (ow, oh, src_left=src_left, src_top=src_top,
         \                                            src_width=src_width, src_height=src_height,
         \                                            kernelh=yh ? kernel_u : kernel_d, kernelv=yv ? kernel_u : kernel_d,
	 \                                            fh=yh ? f_u : f_d, fv=yv ? f_u : f_d,
	 \                                            invksh=yh ? invks_u : invks_d, invksv=yv ? invks_u : invks_d,
	 \                                            taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                            y=Y32, u=1, v=1)
         \                                 : input.BlankClip (width=ow, height=oh *2, pixel_type="Y8", color_yuv=$008080)
         flatY   = curve=="linear" ? flatY :
         \         (mixed || !Yedit) && Yt ? flatY.Dither_y_linear_to_gamma (tv_range_in=tv_range, tv_range_out=tv_range, curve=curve, u=1, v=1, 
                                                   \                         gcor=gcor, sigmoid=sigmoid, thr=gthr, cont=cont)
         \                                 : flatY
         flatU   = (mixed || !Uedit) && Ut ? input.UToY8 ().""" + resstf + """
	 \                                           (owc, ohc, src_left=src_leftc+cphfix, src_top=src_topc,
         \                                            src_width=src_widthc, src_height=src_heightc,
         \                                            kernelh=ch ? kernel_u : kernel_d, kernelv=cv ? kernel_u : kernel_d,
	 \                                            fh=ch ? f_u : f_d, fv=cv ? f_u : f_d,
	 \                                            invksh=ch ? invks_u : invks_d, invksv=cv ? invks_u : invks_d,
	 \                                            taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                            y=U32, u=1, v=1)
         \                                 : input.BlankClip (width=owc, height=ohc*2, pixel_type="Y8", color_yuv=$008080)
         flatV   = (mixed || !Vedit) && Vt ? input.VToY8 ().""" + resstf + """
	 \                                           (owc, ohc, src_left=src_leftc+cphfix, src_top=src_topc,
         \                                            src_width=src_widthc, src_height=src_heightc,
         \                                            kernelh=ch ? kernel_u : kernel_d, kernelv=cv ? kernel_u : kernel_d,
	 \                                            fh=ch ? f_u : f_d, fv=cv ? f_u : f_d,
	 \                                            invksh=ch ? invks_u : invks_d, invksv=cv ? invks_u : invks_d,
	 \                                            taps=taps, a1=a1, a2=a2, a3=a3, invkstaps=invkstaps,
	 \                                            y=V32, u=1, v=1)
         \                                 : input.BlankClip (width=owc, height=ohc*2, pixel_type="Y8", color_yuv=$008080)
    	 flat16  = IsY8 ? flatY : YToUV (flatU, flatV, flatY)
    """)
    enable ? \
    Eval("""
         merge16  = !edit ? flat16
         \                : mixed ? Dither_limit_dif16 (flat16, edge16, thr=lthr, elast=elast, y=Yedi, u=Uedi, v=Vedi)
         \                        : Yedit==Uedit && Uedit==Vedit || IsY8 ? edge16
         \                                                               : mt_lutxy (edge16, flat16, Y=Yt ? Yedit ? 2 : 4 : 1, U=Ut ? Uedit ? 2 : 4 : 1, V=Vt ? Vedit ? 2 : 4 :1)
         merge16  = IsY8 ? output=="Y8" ? merge16.ConvertToY8 () : Eval ("merge16.ConvertTo"+oCSP).Dither_lut16 (Y=2, U=-32768, V=-32768) : merge16
         final    = IsRGB ? merge16.Dither_convert_yuv_to_rgb (matrix=matrix, tv_range=tv_range, lsb_in=True, mode=-1, output=output)
         \                : merge16
    """) : \
    Eval("""
         shift16  = input.Dither_resize16 (ow, oh, src_left, src_top, src_width, src_height, kernel="point", y=Y, u=U, v=V)
         shift16  = IsY8 ? output=="Y8" ? merge16.ConvertToY8 () : Eval ("shift16.ConvertTo"+oCSP).Dither_lut16 (Y=2, U=-32768, V=-32768) : shift16
         final    = IsRGB ? shift16.Dither_convert_yuv_to_rgb (matrix=matrix, tv_range=tv_range, lsb_in=True, mode=-1, output=output)
         \                : shift16
    """)
  
    return final
}

Function EDICore (clip input, int "vct", int "hct", int "vfield", int "hfield", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", bool "mclip", 
         \        int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads",
         \        int "repmode", int "repmodeu", int "repmodev",
         \        string "edimode", bool "honly")
{
    vct      = Default(vct,      1      )
    hct      = Default(hct,      1      )
    vfield   = Default(vfield,   1      )
    hfield   = Default(hfield,   1      )
    Y        = Default(Y,        True   )
    U        = Default(U,        False  )
    V        = Default(V,        False  )
    honly    = Default(honly,    False  )

    alpha      = Default (alpha, 0.2)
    beta       = Default (beta, 0.125)
    gamma      = Default (gamma, 60.0)
    nrad       = Default (nrad, 3)
    mdis       = Default (mdis, 40)
    hp         = Default (hp, False)
    ucubic     = Default (ucubic, True)
    cost3      = Default (cost3, True)
    vcheck     = Default (vcheck, 2)
    vthresh0   = Default (vthresh0, 32.0)
    vthresh1   = Default (vthresh1, 64.0)
    vthresh2   = Default (vthresh2, 4.0)
    sclip      = Default (sclip, UnDefined())
    mclip      = Default (mclip, False)
    nsize      = Default (nsize, 2)
    nns        = Default (nns, 4)
    qual       = Default (qual, 2)
    etype      = Default (etype, 0)
    pscrn      = Default (pscrn, 0)
    threads    = Default (threads, 0)
    repmode    = Default (repmode, 13)
    repmodeu   = Default (repmodeu, repmode)
    repmodev   = Default (repmodev, repmode)
    edimode    = Default (edimode, "eedi3")
    
    
    input
    
    hct >= 1 ? \
    Eval("""
        (honly) ? last
        \       : Eval(" try { fturnright(chroma=U||V, mt=threads!=1) } catch(error_msg) { TurnRight() } ")
        eedim = mclip ? GenEMask () : UnDefined ()
        (edimode=="eedi3") ? eedi3_dh (field=hfield, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=eedim, threads=threads)
                         \ : (edimode=="nnedi3") ? nnedi3_dh (field=hfield, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=eedim, threads=threads)
                                               \ : (edimode=="eedi3+nnedi3") ? hedi_dh (field=hfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads)
                                                                           \ : (edimode=="eedi3_repaired") ? eedi3_dh_r (field=hfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                         \ : (edimode=="nnedi3_repaired") ? nnedi3_dh_r (field=hfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                                                        \ : (edimode=="eedi3+nnedi3_repaired") ? hedi_dh_r (field=hfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                                                                                             \ : Assert (1>2,"EDIResize16: Invalid edimode !")
        
    	hct    = hct - 1
        honly  = hct >= 1
        hfield = 0
        
    	(honly) ? last
        \       : Eval(" try { fturnleft (chroma=U||V, mt=threads!=1) } catch(error_msg) { TurnLeft () } ")
    """) : NOP()
    
    vct >= 1 && !honly ? \
    Eval("""
        eedim = mclip ? GenEMask () : UnDefined ()
        (edimode=="eedi3") ? eedi3_dh (field=vfield, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=eedim, threads=threads)
                         \ : (edimode=="nnedi3") ? nnedi3_dh (field=vfield, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=eedim, threads=threads)
                                               \ : (edimode=="eedi3+nnedi3") ? hedi_dh (field=vfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads)
                                                                           \ : (edimode=="eedi3_repaired") ? eedi3_dh_r (field=vfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                         \ : (edimode=="nnedi3_repaired") ? nnedi3_dh_r (field=vfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                                                        \ : (edimode=="eedi3+nnedi3_repaired") ? hedi_dh_r (field=vfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, sclip=sclip, mclip=eedim, 
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads,
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev)
                                                                                                                                                                             \ : Assert (1>2,"EDIResize16: Invalid edimode !")
        
    	vct    = vct - 1
        vfield = 0
    """) : NOP()
    
    
    return Y||U||V ? vct <= 0 && hct <= 0 ? last
    \                                     : last.EDICore (vct=vct, hct=hct, vfield=vfield, hfield=hfield, Y=Y, U=U, V=V,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip,
             \      nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads, 
             \      repmode=repmode, repmodeu=repmodeu, repmodev=repmodev, edimode=edimode, honly=honly)
    \              : input
}

Function hedi_dh_r (clip input, int "field", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", 
         \        int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads",
         \        int "repmode", int "repmodeu", int "repmodev")
{
    nnedi3=input.nnedi3_dh (field=field, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    dh=input.eedi3_dh (field=field, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=nnedi3, mclip=mclip, threads=threads).repair (nnedi3, mode=repmode, modeu=repmodeu, modev=repmodev)
    return dh
}

Function nnedi3_dh_r (clip input, int "field", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", 
         \        int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads",
         \        int "repmode", int "repmodeu", int "repmodev")
{
    eedi3=input.eedi3_dh (field=field, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    dh=input.nnedi3_dh (field=field, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads).repair (eedi3, mode=repmode, modeu=repmodeu, modev=repmodev)
    return dh
}

Function eedi3_dh_r (clip input, int "field", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", 
         \        int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads",
         \        int "repmode", int "repmodeu", int "repmodev")
{
    nnedi3=input.nnedi3_dh (field=field, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    dh=input.eedi3_dh (field=field, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads).repair (nnedi3, mode=repmode, modeu=repmodeu, modev=repmodev)
    return dh
}

Function hedi_dh (clip input, int "field", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", 
         \        int "nsize", int "nns", int "qual", int "etype", int "pscrn", int "threads")
{
    nnedi3=input.nnedi3_dh (field=field, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn,
             \      alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    dh=input.eedi3_dh (field=field, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=nnedi3, mclip=mclip, threads=threads)
    return dh
}

Function nnedi3_dh (clip input, int "field", bool "Y", bool "U", bool "V", int "nsize", int "nns", int "qual", int "etype", int "pscrn",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", int "threads")
{
    nnedi3=input.nnedi3 (field=field, dh=true, Y=Y, U=U, V=V, nsize=nsize, nns=nns, qual=qual, etype=etype, pscrn=pscrn, threads=threads)
    eedi3=input.eedi3_dh (field=field, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    dh= (nsize==3 && nns==4 && qual==2) ? nnedi3.repair (eedi3, mode=16, modeu=16, modev=16)
        \          : nnedi3
    return dh
}

Function eedi3_dh (clip input, int "field", bool "Y", bool "U", bool "V",
         \        float "alpha", float "beta", float "gamma", int "nrad", int "mdis",
         \        bool "hp", bool "ucubic", bool "cost3", int "vcheck", float "vthresh0", float "vthresh1", float "vthresh2", clip "sclip", clip "mclip", int "threads")
{
    dh=input.eedi3 (field=field, dh=true, Y=Y, U=U, V=V, alpha=alpha, beta=beta, gamma=gamma, nrad=nrad, mdis=mdis, 
             \      hp=hp, ucubic=ucubic, cost3=cost3, vcheck=vcheck, vthresh0=vthresh0, vthresh1=vthresh1, vthresh2=vthresh2, 
             \      sclip=sclip, mclip=mclip, threads=threads)
    return dh
}

Function GenEMask (clip input)
{
    Mask = input.Grayscale ().mt_edge ("hprewitt", 0, 255).mt_lut ("x 5 195 / 255 * -").mt_lut ("x 5 195 / 255 * -").Grayscale ()

    return Mask
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

Function GetVectors (clip search, clip "supersearch", 
         \           int "tr", int "pel", int "dct", int "thsad", string "vccs")
{
    supersearch = Default (supersearch, UnDefined ())
    tr          = Default (tr, 6)
    pel         = Default (pel, 4)
    dct         = Default (dct, 5)
    thsad       = Default (thsad, 400)
    vccs        = Default (vccs, "RGB32")

    search      = search.YTo420_16 ()
    supersearch = supersearch.ConvertToYV12 ()

    supersoft   = search.Ditherpost (mode=6).MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=supersearch, sharp=2, rfilter=4, levels=0)
    supersharp  = search.Ditherpost (mode=6).MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=supersearch, sharp=2, rfilter=2, levels=0)
    vmulti      = supersoft.MAnalyse (multi=True, overlap=16, blksize=32, search=3, chroma=False, truemotion=True, delta=tr, trymany=True,
                           \          searchparam=16, pelsearch=16, dct=dct, levels=0, divide=2, badrange=-24)
    vmulti      = supersoft.MRecalculate (vmulti, overlap=8, blksize=16, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=2)
    vmulti      = supersharp.MRecalculate (vmulti, overlap=4, blksize=8, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=2)
    vmulti      = supersharp.MRecalculate (vmulti, overlap=2, blksize=4, thsad=thsad/2, chroma=False, truemotion=True, tr=tr, search=3, searchparam=16, dct=dct, smooth=1, divide=0)

    return vccs == "yv16" ? MStoreVect (vmulti, vccs="yuy2").converttoyv16 () : MStoreVect (vmulti, vccs=vccs)
}

Function YTo420_16 (clip c)
{
    output    = c.ConvertToYV12 ().Grayscale16 ()

    return output
}

Function Grayscale16 (clip input)
{
    MSB       = input.Dither_get_msb ().mt_lut ("x" ,y=3, u=-128, v=-128)
    LSB       = input.Dither_get_lsb ().mt_lut ("x" ,y=3, u=0, v=0)

    output    = StackVertical (MSB, LSB)

    return output
}

Function SharpLimit16 (clip input, clip "sharp", float "str")
{
    sharp    = Default (sharp, UnDefined ())
    str      = Default (str, 1.00)

    Sharpdif = Dither_sub16 (sharp, input, dif=True, y=3, u=1, v=1)
    Dif      = Dither_lut16 (Sharpdif, "x 256 / 128 - abs 4 / 1 4 / ^ 4 * "+String (str)+" * x 256 / 128 - x 256 / 128 - abs 1.001 + / * 128 + 256 *", y=3, u=1, v=1)

    output   = input.Dither_add16 (Dif, dif=True, y=3, u=1, v=1)

    return output
}

Function SharpCalmer16 (clip input, clip "dif", clip "limit", clip "superdif", clip "superlimit", clip "vclip", clip "repclip",
         \              int "pel", int "tr", int "thsad", int "thscd1", int "thscd2", int "repmode", float "str")
{
    dif        = Default (dif, UnDefined ())
    limit      = Default (limit, UnDefined ())
    superdif   = Default (superdif, UnDefined ())
    superlimit = Default (superlimit, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    repclip    = Default (repclip, dif)
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    thscd1     = Default (thscd1, 248)
    thscd2     = Default (thscd2, 130)
    repmode    = Default (repmode, 13)
    str        = Default (str, 1.00)

    a          = input.YTo420_16 ()
    dif        = dif.YTo420_16 ()
    limit      = limit.YTo420_16 ()
    superlimit = superlimit.ConvertToYV12 ()
    superdif   = superdif.ConvertToYV12 ()
    blankdif   = dif.Dither_get_msb ().Mt_lut ("x", y=-128, u=-128, v=-128)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    superdif   = dif.Ditherpost (mode=-1).MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=superdif, sharp=2, rfilter=2, levels=0)
    supercomp  = limit.Ditherpost (mode=-1).MSuper (pel=pel, chroma=False, hpad=32, vpad=32, pelclip=superlimit, sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)

    MDeG       = blankdif.MDegrainN (superdif, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=thscd1, thSCD2=thscd2, limit=255, limitc=255, plane=0, lsb=True).ConvertToY8 ()
    Repair     = MDeG.Dither_Repair16 (repclip, mode=repmode, modeu=-1, modev=-1)
    TAverage   = input.Dither_add16 (Repair, dif=True, y=3, u=1, v=1)

    comp       = a.Ditherpost (mode=-1).MCompensate (supercomp, vmulti, tr=tr, thSAD=thsad, thSAD2=thsad/2, thSCD1=thscd1, thSCD2=thscd2).ConvertToY8 ()
    max        = comp.MaxMulti (tr=tr).Dither_convert_8_to_16 ()
    min        = comp.MinMulti (tr=tr).Dither_convert_8_to_16 ()
    TLimit     = TAverage.Dither_clamp16 (max, min, 0, 0)

    SLimit     = input.SharpLimit16 (sharp=TLimit, str=str)

    return SLimit
}

Function MaxMulti (clip input, clip "start", int "a", int "tr")
{
    tr       = Default (tr, 3)
    start    = Default (start, Mt_logic (input.SelectEvery (tr*2+1, 0), input.SelectEvery (tr*2+1, 1), "max", y=3, u=1, v=1))
    a        = Default (a, 2)

    max      = Mt_logic (start, input.SelectEvery (tr*2+1, a), "max", y=3, u=1, v=1)
    a        = a+1

    output   = (a == tr*2+1) ? max : input.MaxMulti (start=max, tr=tr, a=a)

    return output
}

Function MinMulti (clip input, clip "start", int "a", int "tr")
{
    tr       = Default (tr, 3)
    start    = Default (start, Mt_logic (input.SelectEvery (tr*2+1, 0), input.SelectEvery (tr*2+1, 1), "min", y=3, u=1, v=1))
    a        = Default (a, 2)

    min      = Mt_logic (start, input.SelectEvery (tr*2+1, a), "min", y=3, u=1, v=1)
    a        = a+1

    output   = (a == tr*2+1) ? min : input.MinMulti (start=min, tr=tr, a=a)

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
