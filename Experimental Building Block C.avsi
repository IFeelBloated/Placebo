Function DenoiseComp16 (clip input, clip "superclip", clip "vclip", int "pel", int "tr", int "thsad")
{
    superclip  = Default (superclip, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)

    a          = input.TComp (tr=tr).YTo420_16 ()
    superclip  = superclip.TComp (tr=tr).ConvertToYV12 ()
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = a.Round8 (False).MSuper (pel=pel, chroma=true, hpad=0, vpad=0, pelclip=superclip, sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = a.Round8 (False).MCompensate (supercomp, vmulti, tr=tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=10000, thSCD2=255)

    return comp.ConvertToY8 ()
}

Function CompDfttest16 (clip comp, clip "repclip", int "tr", string "sstring", int "sbsize", int "repmode")
{
#   r          = "0.0:8.0 0.48:4.0 0.64:0.5 1.0:0.25"
#   g          = "0.0:4.0 0.48:2.0 0.64:0.5 1.0:0.25"
#   b          = "0.0:16.0 0.48:8.0 0.64:0.5 1.0:0.25"

    repclip    = Default (repclip, UnDefined ())
    tr         = Default (tr, 6)
    sstring    = Default (sstring, "0.0:4.0 0.48:2.0 0.64:0.5 1.0:0.25")
    sbsize     = Default (sbsize, 65)
    repmode    = Default (repmode, 13)

    NR         = comp.Convert8to16 (False).YTo420_16 ().Dfttest (lsb_in=true, lsb=true, sstring=sstring, sbsize=sbsize, sosize=0, smode=0, tosize=0, tbsize=tr*2+1, tmode=0, y=true, u=False, v=False)
                                                     \.SelectEvery (tr*2+1, tr).TTrim (tr=tr)
    Rep        = NR.Dither_repair16 (repclip, mode=repmode, modeu=-1, modev=-1)

    return Rep
}

Function MBlur16 (clip input, clip "blur", clip "superclip", clip "vclip", int "pel", int "tr", int "thsad", int "repmode")
{
    blur       = Default (blur, UnDefined ())
    superclip  = Default (superclip, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 400)
    repmode    = Default (repmode, 1)

    a          = input.TComp (tr=tr).YTo420_16 ()
    blur       = blur.TComp (tr=tr).YTo420_16 ()
    superclip  = superclip.TComp (tr=tr).ConvertToYV12 ()
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = a.Round8 (False).MSuper (pel=pel, chroma=true, hpad=0, vpad=0, pelclip=superclip, sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = blur.Round8 (False).MDegrainN (supercomp, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=10000, thSCD2=255, lsb=true, plane=0)
    rep        = comp.Dither_repair16 (blur, mode=repmode, modeu=-1, modev=-1).TTrim (tr=tr)

    return rep
}
