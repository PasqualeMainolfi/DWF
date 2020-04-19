<CsoundSynthesizer>
<CsOptions>
-n ;-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

#include "DrawWithFourier.udo"


gimg init 0

  instr 1

iw = 64
ih = 64

kRe[], kIm[], kF[], kMag[], kPhase[] DFT_xy "heart.txt", iw, ih, 10
kRe_Idft[], kIm_Idft[], kIdft[] IDFT kMag, kPhase

gimg = DFT_draw(kRe_Idft, kIm_Idft)

  endin

  instr 2
imagesave(gimg, "DrawWithDFT.png")
  endin


</CsInstruments>
<CsScore>

i 1 0 3
i 2 4 1

</CsScore>
</CsoundSynthesizer>
