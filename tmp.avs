Y=RawReader ("rule6.rgb", "Y8", 736, 960, packing="8:0:8").converttoy8 ()
DFT=Y.YTo420_16().DFTTest (lsb_in=true, lsb=true, sstring="0.0:16.0 0.48:8.0 0.64:0.5 1.0:0.25", sbsize=33, sosize=0, smode=0, tosize=0, tbsize=1, tmode=0, y=true, u=False, v=False).converttoy8 ()
NLM=Y.nlmeanscl2 (a=10, b=0, s=4, lsb_inout=true, h=2.4, aa=1.6)
Gauss=Y.Gauss16 (p=4)
DFTL=DFT.Gauss16 ()
NLML=NLM.Gauss16 ()
NLMH=Dither_sub16 (NLM, NLML, dif=True)
MergeNR=Dither_add16 (DFTL, NLMH, dif=True)
Min=Dither_min_dif16 (MergeNR, Gauss, Y)
Spatial=Min.Dither_repair16 (MergeNR, 17, -1, -1)
Dif=Dither_sub16 (Y, spatial, dif=true)
SuperD=Dif.GenSuperclip16 (pel=4)
SuperV=Spatial.GenSuperclip16 (pel=4)
Vmulti=GetVectors (Spatial, SuperV)

DifCleanse16 (Spatial, Dif, SuperD, Vmulti, Y)

Function Gauss16 (clip input, int "p")
{
    p          = Default (p, 12)
    w          = input.width ()
    h          = input.height ()/2

    Upsample   = input.Dither_resize16 (w * 2, h * 2, kernel="gauss", a1=100)
    Gauss      = Upsample.Dither_resize16 (w, h, kernel="gauss", a1=p)

    return Gauss
}

Function GenSuperclip16 (clip input, int "pel")
{
    pel        = Default (pel, 4)
    w          = input.width ()
    h          = input.height ()/2

    Upsample   = (pel==2) ? input.EDIResize16 (w*2, h*2, src_left=0.25, src_top=0.25, edimode="nnedi3", noring=true, pscrn=2, nsize=1)
             \ : (pel==4) ? input.EDIResize16 (w*4, h*4, src_left=0.375, src_top=0.375, edimode="nnedi3", noring=true, pscrn=2, nsize=1)
             \ : Assert (1>2,"Invalid pel value !")

    return Upsample.Ditherpost (mode=6)
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

Function DifCleanse16 (clip spatial, clip "dif", clip "superdif", clip "vclip", clip "repclip", int "pel", int "tr", int "thsad", int "thscd1", int "thscd2", int "repmode")
{
    dif        = Default (dif, UnDefined ())
    superdif   = Default (superdif, UnDefined ())
    vclip      = Default (vclip, UnDefined ())
    repclip    = Default (repclip, UnDefined ())
    pel        = Default (pel, 4)
    tr         = Default (tr, 6)
    thsad      = Default (thsad, 2400)
    thscd1     = Default (thscd1, 248)
    thscd2     = Default (thscd2, 130)
    repmode    = Default (repmode, 13)

    a          = dif.YTo420_16 ()
    superclip  = superdif.ConvertToYV12 ()
    bdif       = a.Dither_lut16 ("x", y=-32768, u=-32768, v=-32768)
    vCSP       = vclip.GetCSP ()
    vclip      = vCSP=="yv16" ? vclip.converttoyuy2 () : vclip

    supercomp  = a.Ditherpost (mode=6).MSuper (pel=pel, chroma=true, hpad=32, vpad=32, pelclip=superclip, sharp=2, rfilter=2, levels=0)
    vmulti     = MRestoreVect (vclip)
    comp       = bdif.Ditherpost (mode=-1).MDeGrainN (supercomp, vmulti, tr, thSAD2=thsad/2, thSAD=thsad, thSCD1=thscd1, thSCD2=thscd2, plane=0, limit=255, lsb=True)
    NR         = Dither_add16 (spatial, comp.ConvertToY8 (), dif=True)
    rep        = NR.Dither_repair16 (repclip, mode=repmode, modeu=-1, modev=-1)

    return rep
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
