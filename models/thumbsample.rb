class Thumbsample
THUMBSAMPLE = <<EOC
%PDF-1.4
3 0 obj <<
CCCCC
endobj
2 0 obj <<
/Type /Page
/Contents 3 0 R
/Resources 1 0 R
/MediaBox [0 0 WWWWW HHHHH]
/Parent 7 0 R
>> endobj
1 0 obj <<
/Font << /F27 6 0 R >>
/ProcSet [ /PDF /Text ]
>> endobj
8 0 obj <<
/Type /Encoding
/Differences [ 0 /.notdef 1/dotaccent/fi/fl/fraction/hungarumlaut/Lslash/lslash/ogonek/ring 10/.notdef 11/breve/minus 13/.notdef 14/Zcaron/zcaron/caron/dotlessi/dotlessj/ff/ffi/ffl/notequal/infinity/lessequal/greaterequal/partialdiff/summation/product/pi/grave/quotesingle/space/exclam/quotedbl/numbersign/dollar/percent/ampersand/quoteright/parenleft/parenright/asterisk/plus/comma/hyphen/period/slash/zero/one/two/three/four/five/six/seven/eight/nine/colon/semicolon/less/equal/greater/question/at/A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z/bracketleft/backslash/bracketright/asciicircum/underscore/quoteleft/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z/braceleft/bar/braceright/asciitilde 127/.notdef 128/Euro/integral/quotesinglbase/florin/quotedblbase/ellipsis/dagger/daggerdbl/circumflex/perthousand/Scaron/guilsinglleft/OE/Omega/radical/approxequal 144/.notdef 147/quotedblleft/quotedblright/bullet/endash/emdash/tilde/trademark/scaron/guilsinglright/oe/Delta/lozenge/Ydieresis 160/.notdef 161/exclamdown/cent/sterling/currency/yen/brokenbar/section/dieresis/copyright/ordfeminine/guillemotleft/logicalnot/hyphen/registered/macron/degree/plusminus/twosuperior/threesuperior/acute/mu/paragraph/periodcentered/cedilla/onesuperior/ordmasculine/guillemotright/onequarter/onehalf/threequarters/questiondown/Agrave/Aacute/Acircumflex/Atilde/Adieresis/Aring/AE/Ccedilla/Egrave/Eacute/Ecircumflex/Edieresis/Igrave/Iacute/Icircumflex/Idieresis/Eth/Ntilde/Ograve/Oacute/Ocircumflex/Otilde/Odieresis/multiply/Oslash/Ugrave/Uacute/Ucircumflex/Udieresis/Yacute/Thorn/germandbls/agrave/aacute/acircumflex/atilde/adieresis/aring/ae/ccedilla/egrave/eacute/ecircumflex/edieresis/igrave/iacute/icircumflex/idieresis/eth/ntilde/ograve/oacute/ocircumflex/otilde/odieresis/divide/oslash/ugrave/uacute/ucircumflex/udieresis/yacute/thorn/ydieresis]
>> endobj
6 0 obj <<
/Type /Font
/Subtype /Type1
/Encoding 8 0 R
/FirstChar 33
/LastChar 255
/Widths 9 0 R
/BaseFont /Courier
/FontDescriptor 4 0 R
>> endobj
4 0 obj <<
/Ascent 625
/CapHeight 557
/Descent -147
/FontName /Courier
/ItalicAngle -0
/StemV 200
/XHeight 426
/FontBBox [0 -147 1000 557]
/Flags 34
>> endobj
9 0 obj
[
  600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 
  600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 600 
]
endobj
7 0 obj <<
/Type /Pages
/Count 1
/Kids [2 0 R]
>> endobj
10 0 obj <<
/Type /Catalog
/Pages 7 0 R
>> endobj
11 0 obj <<
/Producer (CeltxStamp v1.0)
/Creator (shinyford)
/CreationDate (D:20090702093501-07'00')
>> endobj
xref
0 12
0000000005 65535 f 
0000000257 00000 n 
0000000153 00000 n 
0000000009 00000 n 
0000002359 00000 n 
0000000000 00000 f 
0000002211 00000 n 
0000002632 00000 n 
0000000325 00000 n 
0000002518 00000 n 
0000002689 00000 n 
0000002739 00000 n 
trailer
<<
/Size 12
/Root 10 0 R
/Info 11 0 R
>>
startxref
2942
%%EOF
EOC

  class << self
    
    def create(w, h, text)
      text = text.gsub('F1.0', 'F27')
      THUMBSAMPLE.sub('CCCCC') { |m| "/Length #{text.size}\n>>\nstream\n#{text}\nendstream\n" }.sub('WWWWW', w.to_s).sub('HHHHH', h.to_s)
    end
    
  end

end