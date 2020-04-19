
    opcode Scale, k, kkkkk
kIn, kOutMin, kOutMax, kInMin, kInMax xin
kY = (((kIn - kInMin) * (kOutMax - kOutMin)) / (kInMax - kInMin)) + kOutMin
xout(kY)
    endop

    opcode TimesComplex, kk, kkkk
/*
PRODOTTO TRA NUMERI COMPLESSI
(a + ib) * (c + id) = (ac - bd) + i(bc + ad)
*/

ka, kib, kc, kid xin

kRealPart = (ka * kc) - (kib * kid)
kImagPart = (kib * kc) + (ka * kid)

xout(kRealPart, kImagPart)
    endop

;--------------------------------------

    opcode XY, k[]k[]i, Siii
SfileName, iw, ih, inumFunFile xin

/*
SfileName = file .txt contenente le coordinate
iw, ih = width and height area
*/

iFunc = ftgen(inumFunFile, 0, 0, -23, SfileName)

iN = ftlen(iFunc)
inCount = iN/2

kX[] init inCount
kY[] init inCount
kXY[] init iN

    copyf2array(kXY, iFunc)

kp init 0
kd init 1
ki init 0
until (ki == (inCount - 1)) do
    kX[ki] = kXY[kp] - kXY[0]
    kX[ki] = Scale(kX[ki], -1, 1, -iw, iw)
    kY[ki] = kXY[kd] - kXY[1]
    kY[ki] = Scale(kY[ki], 1, -1, -ih, ih)

    printf("x = %f --- y = %f\n", 1, kX[0], kY[0])

    kp += 2
    kd += 2
    ki += 1
od

xout(kX, kY, inCount)
    endop


    opcode DFT_xy, k[]k[]k[]k[]k[], Siii
SfileName, iw, ih, inumFunFile xin

kX[], kY[], iLen XY SfileName, iw, ih, inumFunFile

iN = iLen

kRePart[] init iLen
kImPart[] init iLen
kFrq[] init iLen
kMag[] init iLen
kPh[] init iLen

printf("\n", 1)
printf("\n", 1)

kk init 0
until (kk == iN) do
    kRe = 0
    kIm = 0
    kn = 0
    until (kn == iN) do
        kPhi = (2 * $M_PI * kk * kn)/iN
        kRe_a = kX[kn]
        kIm_ib = kY[kn]
        kRe_c = cos(kPhi)
        kIm_id = -sin(kPhi)
        kReal, kImag TimesComplex kRe_a, kIm_ib, kRe_c, kIm_id
        kRe += kReal
        kIm += kImag
        kn += 1
    od

    kFreq = kk
    kAmp = sqrt((kRe^2) + (kIm^2))
    kPhase = taninv2(kIm, kRe)

        kRePart[kk] = kRe
        kImPart[kk] = kIm
        kFrq[kk] = kFreq
        kMag[kk] = kAmp
        kPh[kk] = kPhase

    printf("\tAPPLICO DFT...\n", 1)
    printf("\n", 1)
    printf("\n", 1)
    printf("\t[Re = %f] \t[Im = %f] \t[Frequenza = %d] \t[Ampiezza = %f] \t[Phase = %f]\r", kk + 1, kRe, kIm, kFreq, kAmp, kPhase)
    kk += 1

od

printf("\n", 1)
printf("\n", 1)

xout(kRePart, kImPart, kFrq, kMag, kPh)
    endop


    opcode IDFT, k[]k[]k[], k[]k[]
kMag[], kPhase[] xin

iN = lenarray:i(kMag)
i2pi = 2 * $M_PI

kx[] init iN
kR[] init iN
kI[] init iN

printf("\n", 1)
printf("\n", 1)


kn init 0
until (kn == iN) do
    kRe = 0
    kIm = 0
    kk = 0
    until (kk == iN) do
        kRe += (kMag[kk] * cos(((i2pi * kk * kn)/iN) + kPhase[kk]))
        kIm += (kMag[kk] * sin(((i2pi * kk * kn)/iN) + kPhase[kk]))
        ;printf("[%d] = %f\n", kn + 1, kn, kx[kn])
        kk += 1
    od
    kx[kn] = (1/iN) * (kRe + kIm)
    kR[kn] = kRe/iN
    kI[kn] = kIm/iN

    printf("\tAPPLICO IDFT...\n", 1)
    printf("\n", 1)
    printf("\n", 1)
    printf("\t[Osc = %f]\r", kn + 1, kx[kn])
    kn += 1
od

printf("\n", 1)
printf("\n", 1)

xout(kR, kI, kx)
    endop

    opcode DFT_draw, i, k[]k[]
kRe[], kIm[] xin

iN = lenarray:i(kRe)

iw = 2048
ih = 1024

imgNew = imagecreate(iw, ih)

kj init 0
while (kj <= iN - 1) do

    kX_re = kRe[kj]
    kw_re = Scale(kX_re, 0, 1, -1, 1)

    kY_im = kIm[kj]
    kh_im = Scale(kY_im, 0, 1, -1, 1)

        imagesetpixel(imgNew, kw_re, kh_im, 1, 1, 1)
        imagesetpixel(imgNew, kw_re, kh_im, 1, 1, 1)

    kj += 1
od

xout(imgNew)
    endop
