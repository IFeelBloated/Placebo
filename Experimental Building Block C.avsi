Function DenoiseComp16 (clip input, clip "superclip", clip "vclip", int "pel", int "tr", int "thsad", bool "tv_range")
{
    superclip  = Default (superclip, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    tv_range   = Default (tv_range, True)

    a          = input.TComp (tr=tr)
    superclip  = superclip.TComp (tr=tr)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = a.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=true, hpad=16, vpad=16, pelclip=superclip.Round8 (tv_range=tv_range), sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = a.Round8 (tv_range=tv_range).MCompensate (supercomp, vmulti, tr=tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=10000, thSCD2=255)

    return comp
}

Function CompDfttest16 (clip comp, clip "repclip", int "tr",
         \              string "sstring", int "sbsize", int "repmode", int "repmodeu", int "repmodev",
         \              bool "tv_range")
{
#   r          = "0.0:8.0 0.48:4.0 0.64:0.5 1.0:0.25"
#   g          = "0.0:4.0 0.48:2.0 0.64:0.5 1.0:0.25"
#   b          = "0.0:16.0 0.48:8.0 0.64:0.5 1.0:0.25"

    repclip    = Default (repclip, UnDefined ())
    tr         = Default (tr, 6)
    sstring    = Default (sstring, "0.0:4.0 0.48:2.0 0.64:0.5 1.0:0.25")
    sbsize     = Default (sbsize, 65)
    repmode    = Default (repmode, 13)
    repmodeu   = Default (repmodeu, repmode)
    repmodev   = Default (repmodev, repmode)
    tv_range   = Default (tv_range, True)

    NR         = comp.Convert8to16 (tv_range=tv_range).Dfttest (lsb_in=true, lsb=true, sstring=sstring, sbsize=sbsize, sosize=0, smode=0, tosize=0, tbsize=tr*2+1, tmode=0, y=true, u=true, v=true)
                                                     \.SelectEvery (tr*2+1, tr).TTrim (tr=tr)
    Rep        = NR.Dither_repair16 (repclip, mode=repmode, modeu=repmodeu, modev=repmodev)

    return Rep
}

Function MBlur16 (clip input, clip "blur", clip "superclip", clip "vclip", int "pel", int "tr", int "thsad", int "repmode", int "repmodeu", int "repmodev", bool "tv_range")
{
    blur       = Default (blur, UnDefined ())
    superclip  = Default (superclip, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    repmode    = Default (repmode, 1)
    repmodeu   = Default (repmodeu, repmode)
    repmodev   = Default (repmodev, repmode)
    tv_range   = Default (tv_range, True)

    a          = input.TComp (tr=tr)
    blur       = blur.TComp (tr=tr)
    superclip  = superclip.TComp (tr=tr)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = a.Round8 (tv_range=tv_range).MSuper (pel=pel, chroma=true, hpad=16, vpad=16, pelclip=superclip.Round8 (tv_range=tv_range), sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = blur.Round8 (tv_range=tv_range).MDegrainN (supercomp, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=10000, thSCD2=255, lsb=true)
    rep        = comp.Dither_repair16 (blur, mode=repmode, modeu=repmodeu, modev=repmodev).TTrim (tr=tr)

    return rep
}
