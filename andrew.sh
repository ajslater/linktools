#! /bin/bash

#    ANDREW's Not a DVD Ripping and Encoding Wizard - Version 1.2
#    Copyright (C) 2004, 2005  Alessandro Di Rubbo
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA



# ANDREW bash script
# Create Matroska or Ogg Media files from DVDs.


#- Index
#---1) Preliminary operations
#-------1a) Assignments depending on installation
#-------1b) Assignments not depending on installation
#-------1c) V, h, C, invalid and argument missing options consequences
#-------1d) Dependencies control
#-------1e) Other options consequences
#-------1f) Configuration file (creation,) reading and control
#-------1g) DVD insertion control
#-------1h) Working environment settings
#---2) Questions and answers
#-------2a) Functions declaration
#-------2b) Functions call
#---3) Encoding
#-------3a) Functions declaration
#-------3b) Functions call



#---1) Preliminary operations


#-------1a) Assignments depending on installation

export TEXTDOMAIN=andrew
export TEXTDOMAINDIR=/usr/local/share/locale
DOC_DIR=/usr/local/share/doc/andrew-1.2


#-------1b) Assignments not depending on installation

export LC_ALL=
export LC_NUMERIC=POSIX

LOCALE_LANG=$( echo $LANG | cut -d _ -f 1)

if [ "$LOCALE_LANG" = POSIX ] || [ "$LOCALE_LANG" = C ]; then
  LOCALE_LANG=en
fi

. gettext.sh

E_SUCCESS=0
E_BAD_USAGE=64
E_MISSING_DEP=69
E_INTERRUPT=70

KILLER=$(gettext "You have killed ANDREW.")
TRY_HELP=$(gettext "Try 'andrew.sh -h' for more information.")
INTERLACED=$(gettext "Interlaced")
PROGRESSIVE=$(gettext "Progressive")
TELECINE=$(gettext "Telecine")
ANSWER_1=$(gettext "Start to encode")
ANSWER_2=$(gettext "Start to encode and halt the system when the job ends")
ANSWER_3=$(gettext "Change some of my choices")

trap 'echo $KILLER 1>&2; exit $E_INTERRUPT' SIGINT SIGTERM


#-------1c) V, h, C, invalid and argument missing options consequences

LANG_LIST="ab	abk	Abkhazian	-
aa	aar	Afar	-
af	afr	Afrikaans	-
ak	aka	Akan	-
sq	sqi	Albanian	Shqip
am	amh	Amharic	\u12a0\u121b\u122d\u129b
ar	ara	Arabic	\u0627\u0644\u0639\u0631\u0628\u064a\u0629
an	arg	Aragonese	Aragon\u00e9s
hy	hye	Armenian	\u0540\u0561\u0575\u0565\u0580\u0567\u0576
as	asm	Assamese	-
av	ava	Avaric	-
ae	ave	Avestan	-
ay	aym	Aymara	-
az	aze	Azerbaijani	Az\u0259rbaycan T\u00fcrkc\u0259si
bm	bam	Bambara	-
ba	bak	Bashkir	-
eu	eus	Basque	Euskara
be	bel	Belarusian	\u0411\u0435\u043b\u0430\u0440\u0443\u0441\u043a\u0430\u044f
bn	ben	Bengali	-
bh	bih	Bihari	-
bi	bis	Bislama	-
nb	nob	Bokmal	Bokm\u00e5l
bs	bos	Bosnian	Bosanski
br	bre	Breton	Brezhoneg
bg	bul	Bulgarian	\u0411\u044a\u043b\u0433\u0430\u0440\u0441\u043a\u0438
my	mya	Burmese	-
ca	cat	Catalan	Catal\u00e0
ch	cha	Chamorro	-
ce	che	Chechen	-
ny	nya	Chichewa	-
zh	zho	Chinese	\u7e41\u4f53\u4e2d\u6587/\u4e2d\u6587
cv	chv	Chuvash	-
kw	cor	Cornish	Kernowek
co	cos	Corsican	Corsu
cr	cre	Cree	-
hr	hrv	Croatian	Hrvatski
cs	ces	Czech	\u010cesk\u00fd
da	dan	Danish	Dansk
dv	div	Divehi	-
nl	nld	Dutch	Nederlands
dz	dzo	Dzongkha	-
en	eng	English	-
eo	epo	Esperanto	-
et	est	Estonian	Eesti
ee	ewe	Ewe	-
fo	fao	Faroese	F\u00f8royskt
fj	fij	Fijian	-
fi	fin	Finnish	Suomi
fr	fra	French	Fran\u00e7ais
fy	fry	Frisian	Frysk
ff	ful	Fulah	-
gl	glg	Gallegan	Galego
lg	lug	Ganda	-
ka	kat	Georgian	Kartuli
de	deu	German	Deutsch
el	ell	Greek	\u0395\u03bb\u03bb\u03b7\u03bd\u03b9\u03ba\u03ac
gn	grn	Guanari	Ava\u00f1e'\u1ebd
gu	guj	Gujarati	-
ht	hat	Haitian	Krey\u00f2l
ha	hau	Hausa	-
he	heb	Hebrew	\u05e2\u05d1\u05e8\u05d9\u05ea
hz	her	Herero	-
hi	hin	Hindi	\u0939\u093f\u0928\u094d\u0926\u0940
ho	hmo	HiriMotu	Hiri Motu
hu	hun	Hungarian	Magyar
is	isl	Icelandic	\u00cdslenska
io	ido	Ido	-
ig	ibo	Igbo	-
id	ind	Indonesian	-
ia	ina	Interlingua	-
ie	ile	Interlingue	-
iu	iku	Inuktitut	-
ik	ipk	Inupiat	-
ga	gle	Irish	Gaeilge
it	ita	Italian	Italiano
ja	jpn	Japanese	\u65e5\u672c\u8a9e
jv	jav	Javanese	Basa Jawa
kl	kal	Kalaallisut	-
kn	kan	Kannada	-
kr	kau	Kanuri	-
ks	kas	Kashmiri	-
kk	kaz	Kazakh	\u041a\u0430\u0437\u0430\u043a
km	khm	Khmer	-
ki	kik	Kikuyu	K\u0129k\u0169y\u0169
rw	kin	Kinyarwanda	-
ky	kir	Kirghiz	\u041a\u044b\u0440\u0433\u044b\u0437 \u0422\u0438\u043b\u0438
kv	kom	Komi	-
kg	kon	Kongo	-
ko	kor	Korean	\ud55c\uad6d\ub9d0
kj	kua	Kuanyama	-
ku	kur	Kurdish	-
lo	lao	Lao	\u0e9e\u0eb2\u0eaa\u0eb2\u0ea5\u0eb2\u0ea7
la	lat	Latin	Lingua Latina
lv	lav	Latvian	Latvie\u0161u
lb	ltz	Letzebuergesch	L\u00ebtzebuergesch
li	lim	Limburgan	Limburgs
ln	lin	Lingala	-
lt	lit	Lithuanian	Lietuvi\u0173
lu	lub	Luba-Katanga	-
mk	mkd	Macedonian	\u041c\u0430\u043a\u0435\u0434\u043e\u043d\u0441\u043a\u0438
mg	mlg	Malagasy	-
ms	msa	Malay	-
ml	mal	Malayalam	\u0d2e\u0d32\u0d2f\u0d3e\u0d33\u0d02
mt	mlt	Maltese	Malti
gv	glv	Manx	Gaelg Vanninagh
mi	mri	Maori	Reo M\u00e4ori
mr	mar	Marathi	-
mh	mah	Marshallese	-
mo	mol	Moldavian	Limba Moldoveneasc\u0103
mn	mon	Mongolian	\u041c\u043e\u043d\u0433\u043e\u043b
na	nau	Nauru	-
nv	nav	Navajo	-
ng	ndo	Ndonga	-
ne	nep	Nepali	-
se	sme	NorthernSami	Davvis\u00e1megiella
nd	nde	NorthNdebele	North Ndebele
no	nor	Norwegian	Norsk
nn	nno	Nynorsk	-
oc	oci	Occitan	Proven\u00e7al
oj	oji	Ojibwa	-
cu	chu	OldChurchSlavonic	Old Church Slavonic
or	ori	Oriya	-
om	orm	Oromo	-
os	oss	Ossetian	-
pi	pli	Pali	P\u0101li
pa	pan	Panjabi	\u067e\u0646\u062c\u0627\u0628\u06cc
fa	fas	Persian	\u0641\u0627\u0631\u0633\u06cc
pl	pol	Polish	Polski
pt	por	Portuguese	Portugu\u00eas
ps	pus	Pushto	\u067e\u069a\u062a\u0648
qu	que	Quechua	Runa Simi
rm	roh	Raeto-Romance	-
ro	ron	Romanian	Rom\u00e2n\u0103
rn	run	Rundi	-
ru	rus	Russian	\u0420\u0443\u0441\u0441\u043a\u0438\u0439
sm	smo	Samoan	-
sg	sag	Sango	-
sa	san	Sanskrit	\u0938\u0902\u0938\u094d\u0915\u0943\u0924\u092e
sc	srd	Sardinian	Sardu
gd	gla	ScottishGaelic	G\u00e0idhlig
sr	srp	Serbian	Srpski
sn	sna	Shona	-
ii	iii	SichuanYi	Sichuan Yi
sd	snd	Sindhi	-
si	sin	Sinhalese	-
sk	slk	Slovak	-
sl	slv	Slovenian	Slovensko
so	som	Somali	-
st	sot	SouthernSotho	Southern Sotho
nr	nbl	SouthNdebele	South Ndebele
es	spa	Spanish	Castellano
su	sun	Sundanese	Basa Sunda
sw	swa	Swahili	-
ss	ssw	Swati	Si Swati
sv	swe	Swedish	Svenska
tl	tgl	Tagalog	-
ty	tah	Tahitian	-
tg	tgk	Tajik	\u0422\u043e\u04b7\u0438\u043a\u04e3
ta	tam	Tamil	-
tt	tat	Tatar	Tatar Tele
te	tel	Telugu	-
th	tha	Thai	\u0e44\u0e17\u0e22
bo	bod	Tibetan	-
ti	tir	Tigrinya	\u1275\u130d\u122a\u129b
to	ton	Tonga	-
ts	tso	Tsonga	-
tn	tsn	Tswana	-
tr	tur	Turkish	T\u00fcrk\u00e7e
tk	tuk	Turkmen	\u0422\u0443\u0440\u043a\u043c\u0435\u043d
tw	twi	Twi	-
ug	uig	Uighur	\u7dad\u543e\u723e/\u7ef4\u543e\u5c14
uk	ukr	Ukrainian	\u0423\u043a\u0440\u0430\u0457\u043d\u0441\u044c\u043a\u0430
ur	urd	Urdu	\u0627\u0631\u062f\u0648
uz	uzb	Uzbek	\u0423\u0437\u0431\u0435\u0446\u044c\u043a\u0430
ve	ven	Venda	-
vi	vie	Vietnamese	Ti\u1ebfng Vi\u1ec7t
vo	vol	Volapuk	Volap\u00fck
wa	wln	Walloon	Walon
cy	cym	Welsh	Cymraeg
wo	wol	Wolof	-
xh	xho	Xhosa	isiXhosa
yi	yid	Yiddish	\u05d9\u05d9\u05b4\u05d3\u05d9\u05e9
yo	yor	Yoruba	Yor\u00f9b\u00e1
za	zha	Zhuang	\u58ee\u8bed
zu	zul	Zulu	Isi-Zulu"

while getopts "VhCi:o:c:m:s:a:q:g:t:l:T:L:S:v:f:x:k:r:b:z:d:" OPT; do

  case $OPT in
    V ) echo "ANDREW 1.2"
    gettext "Written by Alessandro Di Rubbo."
    echo -e "\n\nCopyright (C) 2004, 2005 Alessandro Di Rubbo"
    gettext "This is free software; see the source for copying conditions. There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE." | fmt -w $(tput cols)
    exit $E_SUCCESS;;
  
    h ) echo -e $(gettext "Usage")": andrew.sh ["$(gettext "OPTION")"]...
"$(gettext "Create Matroska or Ogg Media files from DVDs.")"

  -d "$(gettext "FILE")"\t"$(gettext "alternative configuration file")"
  -i "$(gettext "DEVICE")"\t"$(gettext "DVD reading device or directory containing a DVD mirror")"
  -o "$(gettext "DIRECTORY")"\t"$(gettext "destination directory for Matroska or Ogg Media files")"
  -c mkv|ogm\t"$(gettext "container format")"
  -m cd|mb\t"$(gettext "file creation mode")"
  -s 1-1024\t"$(gettext "size of a part in MiB")"
  -a ac3|ogg\t"$(gettext "audio encoding")"
  -q 0-9\t"$(gettext "Vorbis audio encoding quality")"
  -g 0-60|norm\t"$(gettext "Vorbis audio volume gain")"
  -t 1-8\t"$(gettext "maximum number of audio tracks")"
  -l en,...|all\t"$(gettext "audio track languages")"
  -T 0-32\t"$(gettext "maximum number of VobSub subtitle tracks")"
  -L en,...|all\t"$(gettext "VobSub subtitle track languages")"
  -S "$(gettext "DIRECTORY")"\t"$(gettext "SRT subtitle file directory")"
  -v ffmpeg|xvid\t"$(gettext "video encoding")"
  -f "$(gettext "OPTION")"\t"$(gettext "FFmpeg video encoding options")"
  -x "$(gettext "OPTION")"\t"$(gettext "XviD video encoding options")"
  -k 0-10\t"$(gettext "key frame interval in seconds")"
  -r 512-576\t"$(gettext "rescaling minimum horizontal resolution in pixels")"
  -b 10-30\t"$(gettext "bit rate in bit per 100 pixels")"
  -z 0-1\t"$(gettext "FFmpeg video resolution optimization")"
  -C\t\t"$(gettext "list language codes and exit")"
  -h\t\t"$(gettext "display this help and exit")"
  -V\t\t"$(gettext "output version information and exit")"

"$(gettext "Report bugs to <liquidgnome@bluebottle.com>.")
    exit $E_SUCCESS;;

    C ) echo -e "639-1\t639-2/T\t"$(gettext "ENGLISH NAME")
    echo "$(echo "$LANG_LIST" | cut -f 1-3)"; exit $E_SUCCESS;;

    * ) if [ "$OPT" = "?" ]; then
       echo $TRY_HELP 1>&2
       exit $E_BAD_USAGE
    fi;;
  esac
done

OPTIND=


#-------1d) Dependencies control

DEP_NAMES=( bc mplayer mencoder oggenc lsdvd dvdxchap ogmmerge mkvmerge mkvextract )
DEP_PACKAGES=( bc mplayer mplayer vorbis-tools lsdvd ogmtools ogmtools mkvtoolnix mkvtoolnix )
DEP_WWWS=( http://www.gnu.org/software/bc http://www.mplayerhq.hu/homepage/design7/news.html http://www.mplayerhq.hu/homepage/design7/news.html http://www.vorbis.com http://untrepid.com/acidrip/lsdvd.html http://www.bunkus.org/videotools/ogmtools http://www.bunkus.org/videotools/ogmtools http://www.bunkus.org/videotools/mkvtoolnix http://www.bunkus.org/videotools/mkvtoolnix )

DEP_N=-1

for DEP_EL in ${DEP_NAMES[*]}; do
  DEP_N=$(( DEP_N+1 ))
  DEP_PATH=$(type -P $DEP_EL)

  if [ ! -x "$DEP_PATH" ]; then
    DEP_MISSING[$DEP_N]=$DEP_N
  fi
done

if [ -n "${DEP_MISSING[*]}" ]; then
  echo -e "$0: "$(ngettext "missing or non executable program" "missing or non executable programs" ${#DEP_MISSING[*]}):

  for DEP_EL in ${DEP_MISSING[*]}; do
    echo "  ${DEP_NAMES[$DEP_EL]} => ${DEP_PACKAGES[$DEP_EL]} @ ${DEP_WWWS[$DEP_EL]}"
  done
  
  exit $E_MISSING_DEP
fi 1>&2


#-------1e) Other options consequences

ILLEGAL_LAVCOPTS="acodec
abitrate
aspect
autoaspect
bit_exac
keyint
ildc
ildme
lmin
lmax
mbqmin
mbqmax
qpel
threads
vbitrate
vcodec
vqmax
vqmin
vqscale
vpass
vratetol
vrc_maxrate
vrc_minrate
vrc_override"

ILLEGAL_XVIDENCOPTS="4mv
aspect
autoaspect
bitrate
container_frame_overhead
fixed_quant
interlacing
max_bquant
max_iquant
max_key_interval
max_pquant
min_bquant
min_iquant
min_key_interval
min_pquant
mod_quant
mpeg_quant
pass
qpel
quant_inter_matrix
quant_intra_matrix
quant_range"

while getopts ":i:o:c:m:s:a:q:g:t:l:T:L:S:v:f:x:k:r:b:z:d:" OPT; do

  case $OPT in
    i ) if [ -r "$OPTARG" ] && ([ -b "$OPTARG" ] || [ -d "$OPTARG" ]); then
      readonly DVD_DEVICE=$(readlink -f "$OPTARG")

    else
      echo -e "$0: "$(gettext "invalid DVD source")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    o ) if [ -w "$OPTARG" ] && [ -d "$OPTARG" ]; then
      readonly DESTINATION_DIR=$(readlink -f "$OPTARG")

    else
      echo -e "$0: "$(gettext "invalid destination directory")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    c ) if [ "$OPTARG" = mkv ] || [ "$OPTARG" = ogm ]; then
      readonly PREF_CONTAINER_FORMAT=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid container format")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    m ) if [ "$OPTARG" = cd ] || [ "$OPTARG" = mb ]; then
      readonly PREF_MODE=$OPTARG

    else
      echo -e "$0: "$(gettext "invalid file creation mode")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
   
    s ) if [ -n "$(echo "$OPTARG" | grep '^[1-9][0-9]*$')" ] && (( OPTARG < 1024 )); then
      readonly PART_MB=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid size of a part")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
    
    a ) if [ "$OPTARG" = "ogg" ] || [ "$OPTARG" = "ac3" ]; then
      readonly PREF_AUDIO_ENCODING=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid audio encoding")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    g ) if [ "$OPTARG" = norm ] || ([ -n "$(echo "$OPTARG" | grep '^[0-9]\+$')" ] && (( OPTARG < 60 ))); then
      readonly OGG_VOLUME=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid Vorbis audio volume gain")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    q ) if [ -n "$(echo "$OPTARG" | grep -e '^[0-9]\+$' -e '^[0-9]\+\.[0-9]*$')" ] && [ $(echo "$OPTARG<=9" | bc) = 1 ]; then
      readonly PREF_OGG_QUALITY=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid Vorbis audio encoding quality")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
      
    t ) if [ -n "$(echo $OPTARG | grep '^[1-8]$')" ]; then
      readonly PREF_AUDIO_TRACKS=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid maximum number of audio tracks")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
    
    l ) if [ "$OPTARG" = all ]; then
      readonly PREF_AUDIO_LANG_COMA=$OPTARG

    else
      PREF_AUDIO_LANG_COMA=$( echo $( for LANG_EL in $(echo $OPTARG | tr , " "); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done ) | tr " " , )

      if [ "$OPTARG" = "$PREF_AUDIO_LANG_COMA" ] && [ -n "$PREF_AUDIO_LANG_COMA" ]; then
        readonly PREF_AUDIO_LANG_COMA

      else
        echo -e "$0: "$(gettext "invalid audio track languages")": $OPTARG\n"$TRY_HELP 1>&2
        exit $E_BAD_USAGE
      fi
    fi;;

    T ) if [ -n "$(echo "$OPTARG" | grep '^[0-9]\+$')" ] && (( OPTARG <= 32 )); then
      readonly PREF_VOBSUB_TRACKS=$OPTARG

    else
      echo -e "$0: "$(gettext "invalid maximum number of VobSub subtitle tracks")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    L ) if [ "$OPTARG" = all ]; then
      readonly PREF_VOBSUB_LANG_COMA=$OPTARG

    else
      PREF_VOBSUB_LANG_COMA=$( echo $( for LANG_EL in $(echo $OPTARG | tr , " "); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done ) | tr " " , )

      if [ "$OPTARG" = "$PREF_VOBSUB_LANG_COMA" ] && [ -n "$PREF_VOBSUB_LANG_COMA" ]; then
        readonly PREF_VOBSUB_LANG_COMA

      else
        echo -e "$0: "$(gettext "invalid VobSub subtitle track languages")": $OPTARG\n"$TRY_HELP 1>&2
        exit $E_BAD_USAGE
      fi
    fi;;

    S )  if [ -r "$OPTARG" ] && [ -d "$OPTARG" ]; then
      SRT_LANG_alpha2=( $(for LANG_EL in $(ls "$OPTARG" |sed -n "s/\(.*\)\.srt/\1/p"); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done) )
      
      for LANG_N in $(seq 0 $(( ${#SRT_LANG_alpha2[*]}-1 ))); do
        
        if ! iconv -f UTF-8 -t UTF-8 "$OPTARG/${SRT_LANG_alpha2[$LANG_N]}.srt" &> /dev/null || [ -z "$(mkvmerge "$OPTARG/${SRT_LANG_alpha2[$LANG_N]}.srt" -o /dev/null | grep SRT)" ]; then
          unset SRT_LANG_alpha2[$LANG_N]
        fi
      done

      if [ -n "${SRT_LANG_alpha2[*]}" ]; then
        SRT_DIR=$(readlink -f "$OPTARG")

      else
        echo -e "$0: "$(gettext "invalid SRT subtitle file directory")": $OPTARG\n"$TRY_HELP 1>&2
        exit $E_BAD_USAGE
      fi

    else
      echo -e "$0: "$(gettext "invalid SRT subtitle file directory")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    v ) if [ "$OPTARG" = "ffmpeg" ] || [ "$OPTARG" = "xvid" ]; then
      readonly VIDEO_ENCODING=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid video encoding")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    f ) if [ "$OPTARG" = "mbd=2:trell:cbp:v4mv:precmp=3:cmp=3:subcmp=3:vlelim=-4:vcelim=9" ] || ([ -z "$( echo "$OPTARG" | grep -F "$ILLEGAL_LAVCOPTS")" ] && [ -z "$(mencoder -ovc lavc -lavcopts $OPTARG 2>&1 | grep -e "Unknown suboption" -e "option must be")" ]); then
      readonly LAVCOPTS=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid FFmpeg video encoding options")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    x ) if [ "$OPTARG" = "vhq=4:trellis:hq_ac:chroma_me:chroma_opt" ] || ([ -z "$( echo "$OPTARG" | grep -F "$ILLEGAL_XVIDENCOPTS")" ] && [ -z "$(mencoder -ovc xvid -xvidencopts $OPTARG 2>&1 | grep -e "Unknown suboption" -e "option must be")" ]); then
      readonly XVIDENCOPTS=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid XviD video encoding options")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    k ) if [ -n "$(echo "$OPTARG" | grep '^[0-9]\+$')" ] && (( OPTARG <= 10 )); then
      readonly KEYINT_SEC=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid key frame interval")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
    
    r ) if [ -n "$(echo "$OPTARG" | grep '^5[1-7][0-8]$')" ] && (( OPTARG%16 == 0 )); then
      readonly MIN_SCALE_H=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid minimum horizontal resolution")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
    
    b ) if [ -n "$(echo "$OPTARG" | grep '^0\.[0-9]\+$')" ] && [ $(echo "0.1<=$OPTARG && $OPTARG<=0.3" | bc) = 1 ]; then
      readonly BPP=$OPTARG
       
    else
      echo -e "$0: "$(gettext "invalid bit rate")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;
   
    z ) if [ "$OPTARG" = 0 ] || [ "$OPTARG" = 1 ]; then
      readonly RES_OPTIMIZATION=$OPTARG
      
    else
      echo -e "$0: "$(gettext "invalid FFmpeg video resolution optimization")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

    d ) if [ -r "$OPTARG" ] && [ -f "$OPTARG" ]; then
      ALT_CONF_FILE="$OPT_ARG"
     
    else
      echo -e "$0: "$(gettext "invalid alternative configuration file")": $OPTARG\n"$TRY_HELP 1>&2
      exit $E_BAD_USAGE
    fi;;

  esac
done

OPTIND=


#-------1f) Configuration file (creation,) reading and control

clear
echo -e "\033[1mANDREW 1.2\033[0m, Copyright (C) 2004, 2005 Alessandro Di Rubbo"
echo -e $(gettext "ANDREW comes with ABSOLUTELY NO WARRANTY; for details type 'w'. This is free software, and you are welcome to redistribute it under certain conditions; type 'c' for details. (Furthermore type 'h' for help or 'q' to quit)")"\n" | fmt -w $(tput cols)

if [ ! -r $HOME/.andrew.conf ]; then
  echo -e "# "$(gettext "ANDREW configuration file")"
\n\n#-"$(gettext "Index")"
#---1) "$(gettext "Environment")"\n#---2) "$(gettext "File")"\n#---3) "$(gettext "Audio")"\n#---4) "$(gettext "VobSub subtitles")"\n#---5) "$(gettext "Video")"
\n\n\n#---1) "$(gettext "Environment")"
\n\n# "$(gettext "DVD reading device or directory containing a DVD mirror")"\nDVD_DEVICE=/dev/dvd
\n# "$(gettext "destination directory for Matroska or Ogg Media files")"\nDESTINATION_DIR=$HOME
\n\n\n#---2) "$(gettext "File")"
\n\n# "$(gettext "container format")"\n# mkv/ogm\nPREF_CONTAINER_FORMAT=mkv
\n# "$(gettext "file creation mode")"\n# cd/mb\nPREF_MODE=cd
\n# "$(gettext "size of a part in MiB")"\n# 1-1024\nPART_MB=700
\n\n\n#---3) "$(gettext "Audio")"
\n\n# "$(gettext "audio encoding")"\n# ac3/ogg\nPREF_AUDIO_ENCODING=ogg
\n# "$(gettext "Vorbis audio encoding quality")"\n# 0-9 ("$(gettext "9 allows the best quality")")\nPREF_OGG_QUALITY=2
\n# "$(gettext "Vorbis audio volume gain")"\n# 0-60/norm ("$(gettext "0 disables the filters, 1-60 increases the volume of 1-60 dB, norm normalises the volume")")\nOGG_VOLUME=norm
\n# "$(gettext "maximum number of audio tracks")"\n# 1-8\nPREF_AUDIO_TRACKS=1
\n# "$(gettext "audio track languages")"\n# en,it,.../all ("$(gettext "all encodes all DVD audio tracks")")\nPREF_AUDIO_LANG_COMA=$LOCALE_LANG,en
\n\n\n#---4) "$(gettext "VobSub subtitles")"
\n\n# "$(gettext "maximum number of VobSub subtitle tracks")"\n# 0-32 ("$(gettext "0 excludes the VobSub subtitles")")\nPREF_VOBSUB_TRACKS=0
\n# "$(gettext "VobSub subtitle track languages")"\n# en,it,.../all ("$(gettext "all encodes all DVD subtitle tracks")")\nPREF_VOBSUB_LANG_COMA=$LOCALE_LANG,en
\n\n\n#---5) "$(gettext "Video")"
\n\n# "$(gettext "video encoding")"\n# ffmpeg/xvid\nVIDEO_ENCODING=ffmpeg
\n# "$(gettext "FFmpeg video encoding options")"\nLAVCOPTS=mbd=2:trell:cbp:v4mv:precmp=3:cmp=3:subcmp=3:vlelim=-4:vcelim=9
\n# "$(gettext "XviD video encoding options")"\nXVIDENCOPTS=vhq=4:trellis:hq_ac:chroma_me:chroma_opt
\n# "$(gettext "key frame interval in seconds")"\n# 0-10 ("$(gettext "0 makes every frame a key frame")")\nKEYINT_SEC=10
\n# "$(gettext "rescaling minimum horizontal resolution in pixels")"\n# 512/528/544/560/576\nMIN_SCALE_H=528
\n# "$(gettext "bit rate in bit per pixel")"\n# 0.1-0.3\nBPP=0.25
\n# "$(gettext "FFmpeg video resolution optimization")"\n# 0-1 ("$(gettext "0 disables, 1 enables the optimization")")\nRES_OPTIMIZATION=1" > $HOME/.andrew.conf

 echo -e "\a\033[33;42;1m ! \033[0;1m \c"
 echo -e "\b \b "$(gettext "A file named .andrew.conf has been created in your home directory: configure your default options and press 'enter' to continue")"\033[34;1m" | fmt -t -w $(tput cols)
 read
 echo -e "\033[0m\c"

 case $REPLY in
   w ) less -p"NO WARRANTY" -G $DOC_DIR/COPYING;;

   c ) less -p"You may copy" -G $DOC_DIR/COPYING;;

   q ) exit $E_SUCCESS;;
 esac

  echo
fi

CONF_FILE_VAR_NAMES=( DVD_DEVICE DESTINATION_DIR PREF_CONTAINER_FORMAT PREF_MODE PART_MB PREF_AUDIO_ENCODING PREF_OGG_QUALITY OGG_VOLUME PREF_AUDIO_TRACKS PREF_AUDIO_LANG_COMA PREF_VOBSUB_TRACKS PREF_VOBSUB_LANG_COMA VIDEO_ENCODING LAVCOPTS XVIDENCOPTS KEYINT_SEC MIN_SCALE_H BPP RES_OPTIMIZATION )

for VAR_NAME in ${CONF_FILE_VAR_NAMES[*]}; do 
  export "$(grep "^$VAR_NAME=" $HOME/.andrew.conf)" &> /dev/null
done

if [ -n "$ALT_CONF_FILE" ]; then
  for VAR_NAME in ${CONF_FILE_VAR_NAMES[*]}; do 
    export "$(grep "^$VAR_NAME=" $ALT_CONF_FILE)" &> /dev/null
  done
fi

if [ ! -r "$DVD_DEVICE" ] || ([ ! -b "$DVD_DEVICE" ] && [ ! -d "$DVD_DEVICE" ]); then
  DVD_DEVICE=/dev/dvd
  DEFAULT_SET[0]="DVD_DEVICE=$DVD_DEVICE"
else
  declare DVD_DEVICE=$(readlink -f "$DVD_DEVICE") &> /dev/null
fi

if [ ! -w "$DESTINATION_DIR" ] || [ ! -d "$DESTINATION_DIR" ]; then
  DESTINATION_DIR=$HOME
  DEFAULT_SET[1]="DESTINATION_DIR=$DESTINATION_DIR"
else
  declare DESTINATION_DIR=$(readlink -f "$DESTINATION_DIR") &> /dev/null
fi

if [ "$PREF_CONTAINER_FORMAT" != mkv ] && [ "$PREF_CONTAINER_FORMAT" != ogm ]; then
  PREF_CONTAINER_FORMAT=mkv
  DEFAULT_SET[2]="PREF_CONTAINER_FORMAT=$PREF_CONTAINER_FORMAT"
fi

if [ "$PREF_MODE" != cd ] && [ "$PREF_MODE" != mb ]; then
  PREF_MODE=cd
  DEFAULT_SET[3]="PREF_MODE=$PREF_MODE"
fi

if [ -z "$(echo "$PART_MB" | grep '^[1-9][0-9]*$')" ] || (( PART_MB > 1024 )); then
  PART_MB=700
  DEFAULT_SET[4]="PART_MB=$PART_MB"
fi

if [ "$PREF_AUDIO_ENCODING" = ogg ]; then
  SOURCE_AUDIO_ENCODING=( lpcm ac3 mpeg2 )

elif [ "$PREF_AUDIO_ENCODING" = ac3 ]; then
  SOURCE_AUDIO_ENCODING=( ac3 lpcm mpeg2 )

else
  PREF_AUDIO_ENCODING=ogg
  DEFAULT_SET[5]="PREF_AUDIO_ENCODING=$PREF_AUDIO_ENCODING"
fi

if [ -z "$(echo "$PREF_OGG_QUALITY" | grep -e '^[0-9]\+$' -e '^[0-9]\+\.[0-9]*$')" ] || [ $(echo "$PREF_OGG_QUALITY>9" | bc) = 1 ]; then
  PREF_OGG_QUALITY=2
  DEFAULT_SET[6]="PREF_OGG_QUALITY=$PREF_OGG_QUALITY"
fi

if [ "$OGG_VOLUME" != norm ] && ([ -z "$(echo "$OGG_VOLUME" | grep '^[0-9]\+$')" ] || (( OGG_VOLUME > 60 ))); then
  OGG_VOLUME=norm
  DEFAULT_SET[7]="OGG_VOLUME=$OGG_VOLUME"
fi

if [ -z "$(echo "$PREF_AUDIO_TRACKS" | grep '^[1-8]$')" ]; then
  PREF_AUDIO_TRACKS=1
  DEFAULT_SET[8]="PREF_AUDIO_TRACKS=$PREF_AUDIO_TRACKS"
fi

if [ "$PREF_AUDIO_LANG_COMA" != all ] && ([ "$PREF_AUDIO_LANG_COMA" != "$( echo $( for LANG_EL in $(echo $PREF_AUDIO_LANG_COMA | tr , " "); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done ) | tr " " , )" ] || [ -z "$PREF_AUDIO_LANG_COMA" ]); then
  PREF_AUDIO_LANG_COMA="$LOCALE_LANG,en"
  DEFAULT_SET[9]="PREF_AUDIO_LANG_COMA=$PREF_AUDIO_LANG_COMA"
fi

if [ -z "$(echo "$PREF_VOBSUB_TRACKS" | grep '^[0-9]\+$')" ] || (( PREF_VOBSUB_TRACKS > 32 )); then
  PREF_VOBSUB_TRACKS=0
  DEFAULT_SET[10]="PREF_VOBSUB_TRACKS=$PREF_VOBSUB_TRACKS"
fi

if [ "$PREF_VOBSUB_LANG_COMA" != all ] && ([ "$PREF_VOBSUB_LANG_COMA" != "$( echo $( for LANG_EL in $(echo $PREF_VOBSUB_LANG_COMA | tr , " "); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done ) | tr " " , )" ] || [ -z "$PREF_VOBSUB_LANG_COMA" ]); then
  PREF_VOBSUB_LANG_COMA="$LOCALE_LANG,en"
  DEFAULT_SET[11]="PREF_VOBSUB_LANG_COMA=$PREF_VOBSUB_LANG_COMA"
fi

if [ "$VIDEO_ENCODING" = ffmpeg ]; then
  VIDEO_ENC_NAME=FFmpeg

elif [ "$VIDEO_ENCODING" = xvid ]; then
  VIDEO_ENC_NAME=XviD

else
  VIDEO_ENCODING=ffmpeg
  DEFAULT_SET[12]="VIDEO_ENCODING=$VIDEO_ENCODING"
fi

if ([ "$LAVCOPTS" != "mbd=2:trell:cbp:v4mv:precmp=3:cmp=3:subcmp=3:vlelim=-4:vcelim=9" ] && [ -n "$LAVCOPTS" ]) && ([ -n "$(echo "$LAVCOPTS" | grep -F "$ILLEGAL_LAVCOPTS")" ] || [ -n "$(mencoder -ovc lavc -lavcopts $LAVCOPTS 2>&1 | grep -e "Unknown suboption" -e "option must be")" ]); then

  LAVCOPTS=mbd=2:trell:cbp:v4mv:precmp=3:cmp=3:subcmp=3:vlelim=-4:vcelim=9
  DEFAULT_SET[13]="LAVCOPTS=$LAVCOPTS"
fi

if ([ "$XVIDENCOPTS" != "vhq=4:trellis:hq_ac:chroma_me:chroma_opt" ] && [ -n "$XVIDENCOPTS" ]) && ([ -n "$(echo "$XVIDENCOPTS" | grep -F "$ILLEGAL_XVIDENCOPTS")" ] || [ -n "$(mencoder -ovc xvid -xvidencopts $XVIDENCOPTS 2>&1 | grep -e "Unknown suboption" -e "option must be")" ]); then

  XVIDENCOPTS=vhq=4:trellis:hq_ac:chroma_me:chroma_opt
  DEFAULT_SET[14]="XVIDENCOPTS=$XVIDENCOPTS"
fi

if [ -z "$(echo "$KEYINT_SEC" | grep '^[0-9]\+$')" ] || (( KEYINT_SEC > 10 )); then
  KEYINT_SEC=10
  DEFAULT_SET[15]="KEYINT_SEC=$KEYINT_SEC"
fi

if [ -z "$(echo "$MIN_SCALE_H" | grep '^5[1-7][0-8]$')" ]  || (( MIN_SCALE_H%16 != 0 )); then
  MIN_SCALE_H=528
  DEFAULT_SET[16]="MIN_SCALE_H=$MIN_SCALE_H"
fi

if [ -z "$(echo "$BPP" | grep '^0\.[0-9]\+$')" ] || [ $(echo "0.1<=$BPP && $BPP<=0.3" | bc) = 0 ]; then
  BPP=0.25
  DEFAULT_SET[17]="BPP=$BPP"
fi

if [ "$RES_OPTIMIZATION" != 0 ] && [ "$RES_OPTIMIZATION" != 1 ]; then
  RES_OPTIMIZATION=1
  DEFAULT_SET[18]="RES_OPTIMIZATION=$RES_OPTIMIZATION"
fi

if [ -n "${DEFAULT_SET[*]}" ]; then
  echo -e "\a\033[33;41;1m ! \033[0;1m \c"
  echo -e "\b \b "$(ngettext "The following parameter in your configuration file was incorrect and has been turned into the internal default" "The following parameters in your configuration file were incorrect and have been turned into the internal defaults" ${#DEFAULT_SET[@]})":\033[0m" | fmt -t -w $(tput cols)
    
  for DEFAULT_EL in "${DEFAULT_SET[@]}"; do
    echo "   $DEFAULT_EL"
  done

  echo
fi


#-------1g) DVD insertion control

DvdInfo () {

LSDVD_INFO=$(lsdvd -vas "$DVD_DEVICE" 2> /dev/null)

if [ "$?" != 0 ]; then

  if [ -b "$DVD_DEVICE" ]; then
    echo -e "\a\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "There is no DVD in \$DVD_DEVICE: insert one and press 'enter' to continue")"\033[34;1m" | fmt -t -w $(tput cols)

  else
  echo -e "\a\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "There is no DVD mirror in \$DVD_DEVICE: copy all the needed files into VIDEO_TS subdirectory and press 'enter' to continue")"\033[34;1m" | fmt -t -w $(tput cols)
  fi

  read
  echo -e "\033[0m\c"

  case $REPLY in
    w ) less -p"NO WARRANTY" -G $DOC_DIR/COPYING;;

    c ) less -p"You may copy" -G $DOC_DIR/COPYING;;

    q ) exit $E_SUCCESS;;
  esac

 DvdInfo
fi

DVD_TITLES=$(echo "$LSDVD_INFO" | grep -c "^Title:")
TITLE_CHAPTERS=( "" $(echo "$LSDVD_INFO" | sed -n "s/.*Chapters: \([0-9]\{2\}\).*/\1/p" | sed 's/^0\([0-9]$\)/\1/') )
}

DvdInfo


#-------1h) Working environment settings

if [ -w "$PWD" ]; then
  WORKING_DIR="$PWD"
else
  WORKING_DIR="$HOME"
fi

mkdir -p "$WORKING_DIR/andrew_tmp"
mkfifo "$WORKING_DIR/andrew_tmp/check_fifo" &> /dev/null

if [ "$?" = 0 ]; then
  NAMED_PIPES=yes
fi

rm -f "$WORKING_DIR/andrew_tmp/check_fifo" 
rmdir "$WORKING_DIR/andrew_tmp" &> /dev/null



#---2) Questions and answers


#-------2a) Functions declaration

NameInput () {

echo -e $(gettext "What is its name?")"\033[34;1m"  | fmt -w $(tput cols)
read NAME
echo -e "\033[0m\c"

if [ "$NAME" = w ]; then
  less -p"NO WARRANTY" -G $DOC_DIR/COPYING
  echo
  NameInput

elif [ "$NAME" = c ]; then
  less -p"You may copy" -G $DOC_DIR/COPYING
  echo
  NameInput

elif [ "$NAME" = h ]; then
  echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
  echo -e "\b \b "$(gettext "Press 'enter' if you want to assign automatically a name or, if you are changing some of your choices, to confirm your previous choice; movie names will be included in Matroska or Ogg Media file names.")"\033[0m\n" | fmt -t -w $(tput cols)
  NameInput

elif [ "$NAME" = q ]; then
  exit $E_SUCCESS

elif [ -z "$NAME" ]; then

  if [ -z "$OLD_NAME" ]; then
    NAME=$(echo "$LSDVD_INFO" | sed -e "/Disc Title:/y/_/ /" -n -e "s/Disc Title: \(.*\)/\1/p")
    OLD_NAME="$NAME"
    
  else
    NAME="$OLD_NAME"
  fi
  
elif [ -n "$(echo "$NAME" | grep  "[:*/*\*?*|*<*>*=*\"*]" )" ]; then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You've typed one or more of the following characters (not allowed in NTFS and FAT32 filesystems)")": |/\\<>?=\\033[0m" | fmt -t -w $(tput cols)
  NameInput

elif (( $(echo "$NAME" | wc -c) > 155 )); then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You've typed more than 155 bytes")"\033[0m" | fmt -t -w $(tput cols)
  NameInput

else
  OLD_NAME="$NAME"
  echo
fi
}


TitleInput () {

if [ "$DVD_TITLES" = 1 ]; then
  TITLE=1
  echo

else
  echo -e $(gettext "Which DVD title is it in? And which are the first and the last chapter?")" (\c"

  for TITLE_N in $(seq 1 $DVD_TITLES); do
    echo -e "$TITLE_N [1-${TITLE_CHAPTERS[$TITLE_N]} [1-${TITLE_CHAPTERS[$TITLE_N]}]]\c"

    if [ "$TITLE_N" != "$DVD_TITLES" ]; then
     echo -e "|\c"

    else
      echo -e ")\c"
    fi
  done

  echo -e "\033[34;1m"  | fmt -w $(tput cols)

  read TITLE FIRST_CHAPTER LAST_CHAPTER
  echo -e "\033[0m\c"
fi

if [ "$TITLE" = w ]; then
  less -p"NO WARRANTY" -G $DOC_DIR/COPYING
  echo
  TitleInput

elif [ "$TITLE" = c ]; then
  less -p"You may copy" -G $DOC_DIR/COPYING
  echo
  TitleInput

elif [ "$TITLE" = h ]; then
  echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
  echo -e "\b \b "$(gettext "Allowed answers are specified in brackets. You can specify three integers separated by spaces: title, first and last chapter; or two integers separated by one space: title and first chapter (the last chapter will be the last chapter of the title you specified); or just one integer: title (the first and the last chapters will be the first and the last chapters of the title you specified)."; gettext "Lastly you can press 'enter' either to encode the movie in the longest DVD title, from its first to its last chapter, or, if you are changing some of your choices, to confirm your previous choice.")"\033[0m\n" | fmt -t -w $(tput cols)
  TitleInput

elif [ "$TITLE" = q ]; then
  exit $E_SUCCESS

elif [ -z "$TITLE" ]; then
 
  if [ -z "$OLD_TITLE" ]; then
    TITLE=$(echo "$LSDVD_INFO" | sed -n 's/Longest track: 0*\([0-9]\)/\1/p')
    TITLE_CHAPS=${TITLE_CHAPTERS[$TITLE]}
    FIRST_CHAPTER=1
    LAST_CHAPTER=$TITLE_CHAPS
    
  else
    TITLE=$OLD_TITLE
    FIRST_CHAPTER=$OLD_FIRST_CHAPTER
    LAST_CHAPTER=$OLD_LAST_CHAPTER
  fi

elif [ -z "$(echo "$TITLE" | grep '^[1-9][0-9]*$')" ]; then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
  TitleInput

elif (( TITLE > DVD_TITLES )); then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "Your DVD doesn't contain so many titles")"\033[0m" | fmt -t -w $(tput cols)
  TitleInput

else
  TITLE_CHAPS=${TITLE_CHAPTERS[$TITLE]}

  if [ -z "$FIRST_CHAPTER" ]; then
    FIRST_CHAPTER=1
    LAST_CHAPTER=$TITLE_CHAPS
    echo
    
  elif [ -z "$(echo "$FIRST_CHAPTER" | grep '^[1-9][0-9]*$')" ]; then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
    TitleInput
    
  elif (( FIRST_CHAPTER > $TITLE_CHAPS )); then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "The title you've typed does not contain chapters beyond chapter number \$TITLE_CHAPS")"\033[0m" | fmt -t -w $(tput cols)
    TitleInput
    
  else
      
    if [ -z "$LAST_CHAPTER" ]; then
      LAST_CHAPTER=$TITLE_CHAPS
      echo
      
    elif [ -z "$(echo "$LAST_CHAPTER" | grep '^[1-9][0-9]*$')" ]; then
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
      TitleInput
      
    elif (( LAST_CHAPTER > $TITLE_CHAPS )); then
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "The title you've typed does not contain chapters beyond chapter number \$TITLE_CHAPS")"\033[0m" | fmt -t -w $(tput cols)
      TitleInput

    elif (( LAST_CHAPTER < FIRST_CHAPTER )); then
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "The last chapter number is higher than the first chapter one")"\033[0m" | fmt -t -w $(tput cols)
      TitleInput
      
    else
      echo
    fi
  fi
fi
}


TitleCalculi () {

if [ "$TITLE" != "$OLD_TITLE" ]; then
  DVDXCHAP_INFO=$(dvdxchap -t $TITLE "$DVD_DEVICE" 2> /dev/null)
  TITLE_SEC=$(echo "$LSDVD_INFO" | sed -n "s/Title: $(printf %02d $TITLE).*Length: \([0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\).*/\1/p" | sed 's/:/*3600\+/' | sed 's/:/*60\+/' | bc)
fi

if [ "$TITLE" != "$OLD_TITLE" ] || [ "$FIRST_CHAPTER" != "$OLD_FIRST_CHAPTER" ] || [ "$LAST_CHAPTER" != "$OLD_LAST_CHAPTER" ]; then
  CHAPTERS_NUM=$(( 1+LAST_CHAPTER-FIRST_CHAPTER ))

  FIRST_SEC=$(echo "$DVDXCHAP_INFO" | grep -v "NAME" | cut -d = -f 2 | head -n $FIRST_CHAPTER | tail -n 1 | sed 's/:/*3600\+/' | sed 's/:/*60\+/' | bc)

  if [ "$LAST_CHAPTER" != "$TITLE_CHAPS" ]; then
    LAST_SEC=$(echo "$DVDXCHAP_INFO" | grep -v "NAME" | cut -d = -f 2 | head -n $(( $LAST_CHAPTER+1 )) | tail -n 1 | sed 's/:/*3600\+/' | sed 's/:/*60\+/' | bc )

  else
    LAST_SEC=$TITLE_SEC
  fi

  SEC=$( printf %.f $(echo "$LAST_SEC-$FIRST_SEC" | bc) )

  case $(echo "$LSDVD_INFO" | sed -n "s/.*Format: \(.*\), Aspect.*/\1/p" | head -n $TITLE | tail -n 1) in
    PAL ) VIDEO_FORMATS=( PAL "PAL-$INTERLACED" );;
    NTSC ) VIDEO_FORMATS=( "NTSC-$PROGRESSIVE" "NTSC-$TELECINE" "NTSC-$INTERLACED" "NTSC-$PROGRESSIVE/$TELECINE" "NTSC-$PROGRESSIVE\(/$INTERLACED\)" "NTSC-\($PROGRESSIVE/\)$INTERLACED" );;
  esac
fi
}


VideoFormatInput () {

 echo $(gettext "Which is the video format?")" (1-${#VIDEO_FORMATS[*]})" | fmt -w $(tput cols)
  select VIDEO_FORMAT in ${VIDEO_FORMATS[*]}; do
    case $REPLY in
      w ) less -p"NO WARRANTY" -G $DOC_DIR/COPYING    
      VideoFormatInput
      break;;

      c ) less -p"You may copy" -G $DOC_DIR/COPYING
      VideoFormatInput
      break;;

      h ) echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
      echo -e "\b \b "$(eval_gettext "Allowed answers are specified in brackets. Usually both PAL and NTSC DVDs of TV series or documentaries are interlaced: invoke 'mplayer -dvd-device \$DVD_DEVICE dvd://\$TITLE -speed 0.1' and verify that images are resolved into horizontal lines."; eval_gettext "NTSC DVDs of cinema movies can be either progressive or telecine. Playing progressive DVDs in MPlayer, MPlayer will print the following line as soon as the movie begins to play: 'demux_mpg: 24fps progressive NTSC content detected, switching framerate'. Watching telecine DVDs, you will see interlacing artifacts that seem to blink: invoke 'mplayer -dvd-device \$DVD_DEVICE dvd://\$TITLE -speed 0.1' and verify that the pattern of interlaced-looking and progressive-looking frames you see is PPPII,PPPII,PPPII,...."; eval_gettext "Some NTSC DVDs could be mixed: invoke 'mplayer -dvd-device \$DVD_DEVICE dvd://\$TITLE -speed 0.1' and verify that MPlayer output switches back and forth between '30fps NTSC' and '24fps progressive NTSC'; if '30fps NTSC' sections are telecine your movie is progressive/telecine, otherwise it's progressive/interlaced. In the second case you can choose to treat it as progressive video, if it is mostly progressive and you never intend to watch it on TVs, or as interlaced video.")"\033[0m\n" | fmt -t -w $(tput cols)
      VideoFormatInput
      break;;
     
      q ) exit $E_SUCCESS;;
      
      [1-${#VIDEO_FORMATS[*]}] ) case $VIDEO_FORMAT in
        "PAL" | "PAL-$INTERLACED" ) FPS=25;;

        "NTSC-$PROGRESSIVE" | "NTSC-$TELECINE" | "NTSC-$PROGRESSIVE/$TELECINE" | "NTSC-$PROGRESSIVE(/$INTERLACED)" ) FPS=23.976;;

        "NTSC-$INTERLACED" | "NTSC-($PROGRESSIVE/)$INTERLACED" ) FPS=29.97;;
      esac
      echo
      break;;

      * ) echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed any of available options")"\033[0m" | fmt -t -w $(tput cols)
      VideoFormatInput
      break;;
    esac
  done
}


CropCalculi () {

if [ "$TITLE" != "$OLD_TITLE" ]; then
  KROP=14
  unset CROP_SAMPLES_TOT
  CROP_MODE_NUM=-1

  while (( CROP_MODE_NUM < ${#CROP_SAMPLES_TOT[*]}/2  )) && (( KROP > 1 )); do
    KROP=$(( KROP-1 ))
    CROP_JUMP_SEC=$(( TITLE_SEC/KROP ))
    CROP_SAMPLES_PART=( $(mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -frames 12 -sstep $CROP_JUMP_SEC -really-quiet -ao null -vo null -vf cropdetect 2>&1 | sed -n "s/.*crop=\([0-9]\+\):\([0-9]\+\):\([0-9]\+\):\([0-9]\+\))/\1-4;\2-4;\3+2;\4+2/p") )

    for CROP_EL in ${CROP_SAMPLES_PART[*]}; do
      CROP_SAMPLES_TOT[${#CROP_SAMPLES_TOT[*]}]=$CROP_EL
    done

    CROP_MODE=$( echo ${CROP_SAMPLES_TOT[*]} | tr " " "\n" | sort | uniq -c | sort -rn | head -1 )

    if [ -n "$CROP_MODE" ]; then
      CROP_MODE_NUM=$(echo $CROP_MODE | cut -d " " -f 1)

    else
      CROP_MODE_NUM=0
    fi
  done

  CROP=$(echo $(echo $CROP_MODE | cut -d " " -f 2 | bc ) | tr " " :)
  MAX_SCALE_H=$(( $(echo "$CROP" | cut -d : -f 1)/16*16 ))
  MPLAYER_INFO=$(mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -frames 1 -v -quiet -ao null -vo null -vf crop=$CROP,scale=$MAX_SCALE_H:-2 2>&1 | grep -e "\[open\] audio" -e "\[open\] subtitle" -e "VO: \[null\] ")
  MAX_SCALE_V=$(( $(echo "$MPLAYER_INFO" | sed -n "s/.*[0-9]\{3\}x\(.*\) =>.*/\1/p")/16*16 ))
  ASPECT=$(echo "$MAX_SCALE_H/$MAX_SCALE_V" | bc -l)
  MAX_VIDEO_BITRATE=$(echo "(($BPP*$MAX_SCALE_H*$MAX_SCALE_V*$FPS)+($BPP*($MAX_SCALE_H+16)*$(( $(printf %.f $(echo "scale=1;($MAX_SCALE_H+16)/$ASPECT/16" | bc))*16 ))*$FPS))/(2*1000)" | bc)
  MIN_SCALE_V=$(( $(printf %.f $(echo "scale=1;$MIN_SCALE_H/$ASPECT/16" | bc))*16 ))
  MIN_VIDEO_BITRATE=$(echo "(($BPP*$MIN_SCALE_H*$MIN_SCALE_V*$FPS)+($BPP*($MIN_SCALE_H-16)*$(( $(printf %.f $(echo "scale=1;($MIN_SCALE_H-16)/$ASPECT/16" | bc))*16 ))*$FPS))/(2*1000)" | bc)
fi
}


SubAudioCalculi () {

if [ "$TITLE" != "$OLD_TITLE" ]; then
  TITLE_AUDIO_TRACKS=$(echo "$LSDVD_INFO" | sed -n "s/Title: $(printf %02d $TITLE).*Audio streams: \([0-9]\{2\}\).*/\1/p" | sed 's/^0\([0-9]$\)/\1/')
  TITLE_SUB_TRACKS=$(echo "$LSDVD_INFO" | sed -n "s/Title: $(printf %02d $TITLE).*Subpictures: \([0-9]\{2\}\).*/\1/p" | sed 's/^0\([0-9]$\)/\1/')
  TITLE_AUDIO_LANG=( $(for LANG_EL in $(echo "$LSDVD_INFO" | grep "Title: $(printf %02d $TITLE)" -A $(( 1+TITLE_AUDIO_TRACKS+TITLE_SUB_TRACKS )) | sed -n "s/.*Audio.*Language: \(.\{2\}\) .*/\1/p" | sort -u); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done) )
  
  if [ "$PREF_AUDIO_LANG_COMA" = all ]; then
    AUDIO_LANG_alpha2=( ${TITLE_AUDIO_LANG[*]} )

  else
    PREF_AUDIO_LANG=( $(echo $PREF_AUDIO_LANG_COMA | tr , " ") )

    unset AUDIO_LANG_alpha2
    AUDIO_LANG_alpha2_N=0
    PREF_AUDIO_LANG_N=0

    while (( ${#AUDIO_LANG_alpha2[*]} <=  ${#TITLE_AUDIO_LANG[*]} )) && (( ${#AUDIO_LANG_alpha2[*]} <  PREF_AUDIO_TRACKS )) && (( PREF_AUDIO_LANG_N <  ${#PREF_AUDIO_LANG[*]} )); do

      if [ -n "$( echo "${TITLE_AUDIO_LANG[*]}" | grep "${PREF_AUDIO_LANG[$PREF_AUDIO_LANG_N]}" )" ] && [ -z "$( echo "${AUDIO_LANG_alpha2[*]}" | grep "${PREF_AUDIO_LANG[$PREF_AUDIO_LANG_N]}" )" ]; then
        AUDIO_LANG_alpha2[$AUDIO_LANG_alpha2_N]=${PREF_AUDIO_LANG[$PREF_AUDIO_LANG_N]}
        AUDIO_LANG_alpha2_N=$(( AUDIO_LANG_alpha2_N+1 ))
      fi

      PREF_AUDIO_LANG_N=$(( PREF_AUDIO_LANG_N+1 ))
    done
    
    if [ "${#AUDIO_LANG_alpha2[*]}" = 0 ]; then
     AUDIO_LANG_alpha2[0]=${TITLE_AUDIO_LANG[0]}
    fi
  fi

  unset AUDIO_LANG_alpha3
  unset AUDIO_LANG_ALPHA3
  unset AUDIO_LANG_OGM
  unset AUDIO_LANG_DISPLAY
  unset AUDIO_C_S
  unset AUDIO_CHANNELS
  unset OGG_QUALITY
  unset AUDIO_STREAM
  unset AUDIO_ENCODING
  unset AUDIO_ENC
  unset AUDIO_DVD_ID
  unset AUDIO_BITRATE

  for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do
    AUDIO_LANG_alpha3[$LANG_N]=$( echo "$LANG_LIST" | grep -w "${AUDIO_LANG_alpha2[$LANG_N]}" | cut -f 2 )

    while [ -z "${AUDIO_LANG_alpha3[$LANG_N]}" ]; do
      AudioLanguageInput
    done

    AUDIO_LANG_ALPHA3[$LANG_N]=$(echo ${AUDIO_LANG_alpha3[$LANG_N]} | tr '[:lower:]' '[:upper:]')
    AUDIO_LANG_OGM[$LANG_N]=$( echo "$LANG_LIST" | grep -w "${AUDIO_LANG_alpha3[$LANG_N]}" | cut -f 3 )
    AUDIO_LANG_DISPLAY[$LANG_N]=$($(type -P printf) "$(echo "$LANG_LIST" | grep -w "${AUDIO_LANG_alpha3[$LANG_N]}" | cut -f 4)")

    if [ -z "${AUDIO_LANG_DISPLAY[$LANG_N]}" ] || [ -n "$(echo "${AUDIO_LANG_DISPLAY[$LANG_N]}" | grep -e "\\u" -e "-")" ]; then
      AUDIO_LANG_DISPLAY[$LANG_N]=${AUDIO_LANG_OGM[$LANG_N]}
    fi

    SOURCE_EL=-1

    while [ -z "${AUDIO_C_S[$LANG_N]}" ]; do
      SOURCE_EL=$(( SOURCE_EL+1))
      AUDIO_C_S[$LANG_N]=$(echo "$LSDVD_INFO" | grep -A $(( 1+TITLE_AUDIO_TRACKS )) "Title: $(printf %02d $TITLE)" | grep -v -e Comments1 -e Comments2 | sed -n "s/.*Audio: \([0-9]\), Language: ${AUDIO_LANG_alpha2[$LANG_N]}.*Format: ${SOURCE_AUDIO_ENCODING[$SOURCE_EL]}.*Channels: \([0-9]\).*/\2\t\1/p" | sort -rn | head -1)
    done

    AUDIO_CHANNELS[$LANG_N]=$(echo "${AUDIO_C_S[$LANG_N]}" | cut -f 1)

    if [ "${SOURCE_AUDIO_ENCODING[$SOURCE_EL]}" = ac3 ] && [ "${AUDIO_CHANNELS[$LANG_N]}" = 2 ] && [ $(echo "$PREF_OGG_QUALITY>6" | bc) = 1 ]; then
      OGG_QUALITY[$LANG_N]=6
    
    else
      OGG_QUALITY[$LANG_N]=$PREF_OGG_QUALITY
    fi

    AUDIO_STREAM[$LANG_N]=$(( $(echo "${AUDIO_C_S[$LANG_N]}" | cut -f 2)-1 ))


    if [ "$PREF_AUDIO_ENCODING" = ac3 ] && [ "$SOURCE_EL" = 0 ]; then
      AUDIO_ENCODING[$LANG_N]=AC-3

    else
      AUDIO_ENCODING[$LANG_N]=Vorbis
    fi

    if [ -z "$(echo "${AUDIO_ENC[*]}" | grep ${AUDIO_ENCODING[$LANG_N]})" ]; then
      AUDIO_ENC[$LANG_N]=${AUDIO_ENCODING[$LANG_N]}
    fi

    AUDIO_DVD_ID[$LANG_N]=$(echo "$MPLAYER_INFO" | sed -n "s/.*stream: ${AUDIO_STREAM[$LANG_N]}.*aid: \(.*\)/\1/p")

    if [ "${AUDIO_ENCODING[$LANG_N]}" = AC-3 ]; then
      AUDIO_BITRATE[$LANG_N]=$(printf %.f $(mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -frames 0 -v -quiet -ao null -aid ${AUDIO_DVD_ID[$LANG_N]} -vo null 2>&1 | sed -n "s/AC3:.*  \(.*\) kbit\/s/\1/p"))

    elif [ $(echo "${OGG_QUALITY[$LANG_N]}<4.5" | bc) = 1 ]; then
      AUDIO_BITRATE[$LANG_N]=$(echo "(64+16*$PREF_OGG_QUALITY)*75/100" | bc)

    elif [ ${OGG_QUALITY[$LANG_N]} = 9 ]; then
      AUDIO_BITRATE[$LANG_N]=240

    else
      AUDIO_BITRATE[$LANG_N]=$(echo "(128+32*($PREF_OGG_QUALITY-4))*75/100" | bc)
    fi
  done

  if [ "$PREF_VOBSUB_TRACKS" != 0 ] || [ "$PREF_VOBSUB_LANG_COMA" = all ]; then 
    TITLE_SUB_LANG=( $(for LANG_EL in $(echo "$LSDVD_INFO" | grep "Title: $(printf %02d $TITLE)" -A $(( 1+TITLE_AUDIO_TRACKS+TITLE_SUB_TRACKS )) | sed -n "s/.*Subtitle.*Language: \(.\{2\}\) .*/\1/p" | sort -u); do echo "$LANG_LIST" | cut -f 1 | sed -n "s/^\($LANG_EL\)$/\1/p" ; done) )

    for LANG_N in $(seq 0 $(( ${#TITLE_SUB_LANG[*]}-1 ))); do

      if [ -n "$(echo ${SRT_LANG_alpha2[*]} | grep ${TITLE_SUB_LANG[$LANG_N]})" ]; then
        unset TITLE_SUB_LANG[$LANG_N]
      fi
    done

    if [ "$PREF_VOBSUB_LANG_COMA" = all ]; then
      VOBSUB_LANG_alpha2=( ${TITLE_SUB_LANG[*]} )

    else
      PREF_VOBSUB_LANG=( $(echo $PREF_VOBSUB_LANG_COMA | tr , " ") )
      unset VOBSUB_LANG_alpha2
      VOBSUB_LANG_alpha2_N=0
      PREF_VOBSUB_LANG_N=0

      while (( ${#VOBSUB_LANG_alpha2[*]} <=  ${#TITLE_SUB_LANG[*]} )) && (( ${#VOBSUB_LANG_alpha2[*]} <  PREF_VOBSUB_TRACKS )) && (( PREF_VOBSUB_LANG_N <  ${#PREF_VOBSUB_LANG[*]} )); do

        if [ -n "$( echo "${TITLE_SUB_LANG[*]}" | grep "${PREF_VOBSUB_LANG[$PREF_VOBSUB_LANG_N]}" )" ] && [ -z "$( echo "${VOBSUB_LANG_alpha2[*]}" | grep "${PREF_VOBSUB_LANG[$PREF_VOBSUB_LANG_N]}" )" ]; then
          VOBSUB_LANG_alpha2[$VOBSUB_LANG_alpha2_N]=${PREF_VOBSUB_LANG[$PREF_VOBSUB_LANG_N]}
          VOBSUB_LANG_alpha2_N=$(( VOBSUB_LANG_alpha2_N+1 ))
        fi

        PREF_VOBSUB_LANG_N=$(( PREF_VOBSUB_LANG_N+1 ))
      done
    fi

    unset SUB_FORMAT
    unset SUB_DVD_ID

    for LANG_N in $(seq 0 $(( ${#VOBSUB_LANG_alpha2[*]}-1 ))); do
      SUB_FORMAT[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]=VobSub
      SUB_TEMP_DVD_ID=( $(echo "$MPLAYER_INFO" | sed -n "s/.*subtitle ( sid ): \([0-9]\+\) language: ${VOBSUB_LANG_alpha2[$LANG_N]}/\1/p") )

      if [ "${#SUB_TEMP_DVD_ID[*]}" = 1 ]; then
        SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]=${SUB_TEMP_DVD_ID[0]}

      else
        SubIdInput
      fi
    done
  fi

  for LANG_N in $(seq 0 $(( ${#SRT_LANG_alpha2[*]}-1 ))); do
    SUB_FORMAT[$LANG_N]=SRT
  done

  SUB_LANG_alpha2=( ${SRT_LANG_alpha2[*]} ${VOBSUB_LANG_alpha2[*]} )

  if [ -n "${SUB_LANG_alpha2[*]}" ]; then
    FILENAME_SPACE=" "

    unset SUB_LANG_alpha3
    unset SUB_LANG_OGM
    unset SUB_LANG_DISPLAY
    unset SUB_FMT

    for LANG_N in $(seq 0 $(( ${#SUB_LANG_alpha2[*]}-1 ))); do
      SUB_LANG_alpha3[$LANG_N]=$(echo "$LANG_LIST" | grep -w "${SUB_LANG_alpha2[$LANG_N]}" | cut -f 2)
      SUB_LANG_OGM[$LANG_N]=$(echo "$LANG_LIST" | grep -w "${SUB_LANG_alpha3[$LANG_N]}" | cut -f 3)
      SUB_LANG_DISPLAY[$LANG_N]=$($(type -P printf) "$(echo "$LANG_LIST" | grep -w "${SUB_LANG_alpha3[$LANG_N]}" | cut -f 4)")

      if [ -z "${SUB_LANG_DISPLAY[$LANG_N]}" ] || [ -n "$(echo "${SUB_LANG_DISPLAY[$LANG_N]}" | grep -e '\\u' -e "-")" ]; then
        SUB_LANG_DISPLAY[$LANG_N]=${SUB_LANG_OGM[$LANG_N]}
      fi

      if [ -z "$(echo "${SUB_FMT[*]}" | grep ${SUB_FORMAT[$LANG_N]})" ]; then
        SUB_FMT[$LANG_N]=${SUB_FORMAT[$LANG_N]}
      fi
    done
  fi

  if [ -n "${SUB_LANG_alpha2[*]}" ] || [ "$PREF_CONTAINER_FORMAT" = mkv ]; then
    CONTAINER_FMT_NAME=Matroska
    CONTAINER_FORMAT=mkv

  else
    CONTAINER_FMT_NAME="Ogg Media"
    CONTAINER_FORMAT=ogm
  fi
fi
}


AudioLanguageInput () {

  echo -e $(gettext "Which the language code of the first audio track?")"\033[34;1m"  | fmt -w $(tput cols)
  read AUDIO_LANG_alpha3[$LANG_N]
  echo -e "\033[0m\c"

  if [ "${AUDIO_LANG_alpha3[$LANG_N]}" = w ]; then
    less -p"NO WARRANTY" -G $DOC_DIR/COPYING
    echo
    AudioLanguageInput

  elif [ "${AUDIO_LANG_alpha3[$LANG_N]}" = c ]; then
    less -p"You may copy" -G $DOC_DIR/COPYING
    echo
    AudioLanguageInput

  elif [ "${AUDIO_LANG_alpha3[$LANG_N]}" = h ]; then
    echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
    echo -e "\b \b "$(gettext "Listen the first audio track of the title where your movie is, invoke 'andrew.sh -C' and choose the appropriate three small letter ISO 639-2/T code; press 'enter' if you want to assign automatically your local language. Language codes will be included in Matroska or Ogg Media file names and metainformations.")"\033[0m\n" | fmt -t -w $(tput cols)
    AudioLanguageInput

  elif [ "${AUDIO_LANG_alpha3[$LANG_N]}" = q ]; then
    exit $E_SUCCESS

  elif [ -z "${AUDIO_LANG_alpha3[$LANG_N]}" ]; then
    AUDIO_LANG_alpha3[$LANG_N]=$LOCALE_LANG

  elif [ -z $(echo "$LANG_LIST" | cut -f 2 | grep -w "${AUDIO_LANG_alpha3[$LANG_N]}") ]; then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a valid three small letter ISO 639-2/T code")"\033[0m" | fmt -t -w $(tput cols)
    AudioLanguageInput

  else
    echo
  fi
}


SubIdInput () {
LANG_EL=${VOBSUB_LANG_alpha2[$LANG_N]}

echo -e $(eval_gettext "Which is the '\$LANG_EL' subtitle track ID?")" ($(echo ${SUB_TEMP_DVD_ID[*]} | tr " " "|"))\033[34;1m"  | fmt -w $(tput cols)
read SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]
echo -e "\033[0m\c"

if [ "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" = w ]; then
  less -p"NO WARRANTY" -G $DOC_DIR/COPYING
  echo
  SubIdInput

elif [ "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" = c ]; then
  less -p"You may copy" -G $DOC_DIR/COPYING
  echo
  SubIdInput

elif [ "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" = h ]; then
  echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
  echo -e "\b \b "$(eval_gettext "Allowed answers are specified in brackets. Invoke recursively 'mplayer -dvd-device \$DVD_DEVICE dvd://\$TITLE -sid' followed by one of the IDs specified in brackets and choose which is the subtitle track you are interested in. Press 'enter' if you want to assign automatically the first ID of the list.")"\033[0m\n" | fmt -t -w $(tput cols)
  SubIdInput

elif [ "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" = q ]; then
  exit $E_SUCCESS

elif [ -z "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" ]; then
  SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]=${SUB_TEMP_DVD_ID[0]}

elif [ -z "$(echo "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}" | grep '^[1-9][0-9]*$')" ]; then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
  SubIdInput

elif [ -z "$(for TEMP_ID in ${SUB_TEMP_DVD_ID[*]}; do echo $TEMP_ID; done | grep -x "${SUB_DVD_ID[$(( LANG_N+${#SRT_LANG_alpha2[*]} ))]}")" ]; then
  echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "You haven't typed a valid ID for the '\$LANG_EL' subtitle track")"\033[0m" | fmt -t -w $(tput cols)
  SubIdInput

else
  echo
fi
}


PartCalculi () {

if [ "$TITLE" != "$OLD_TITLE" ] || [ "$FIRST_CHAPTER" != "$OLD_FIRST_CHAPTER" ] || [ "$LAST_CHAPTER" != "$OLD_LAST_CHAPTER" ]; then

  if [ -n "$(echo "${AUDIO_ENCODING[*]}" | grep "Vorbis")" ]; then
    PCM_MB=$(( SEC*1411*1000/(8*1024*1024) ))

  else
    PCM_MB=0
  fi

  AUDIO_BYTE=0
  AUDIO_OVERHEAD_BYTE=0
  AUDIO_OVERHEAD_BYTERATE=0

  for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do
    AUDIO_BYTE=$(( AUDIO_BYTE+SEC*AUDIO_BITRATE[$LANG_N]*1000/8 ))

    if [ "${AUDIO_ENCODING[$LANG_N]}" = AC-3 ]; then

      if [ "$CONTAINER_FORMAT" = mkv ]; then
        AUDIO_TRACK_OVERHEAD_BYTE=95
        AUDIO_TRACK_OVERHEAD_BYTERATE=312.45

      else
        AUDIO_TRACK_OVERHEAD_BYTE=0
        AUDIO_TRACK_OVERHEAD_BYTERATE=0.0131
      fi

    else
      AUDIO_TRACK_OVERHEAD_BYTE=0
      AUDIO_TRACK_OVERHEAD_BYTERATE=0
    fi

    AUDIO_OVERHEAD_BYTE=$(( AUDIO_OVERHEAD_BYTE+AUDIO_TRACK_OVERHEAD_BYTE ))
    AUDIO_OVERHEAD_BYTERATE=$(echo "$AUDIO_OVERHEAD_BYTERATE+$AUDIO_TRACK_OVERHEAD_BYTERATE" | bc)
  done
  
  if [ "$CONTAINER_FORMAT" = mkv ]; then
    OVERHEAD_BYTE=$(( 5420+$AUDIO_OVERHEAD_BYTE ))
    OVERHEAD_BYTERATE=$(echo "15.4+12.9*$FPS+$AUDIO_OVERHEAD_BYTERATE" | bc)
    OVERHEAD_CONSTANT=1

  else
    OVERHEAD_BYTE=$AUDIO_OVERHEAD_BYTE
    OVERHEAD_BYTERATE=$AUDIO_OVERHEAD_BYTERATE
    OVERHEAD_CONSTANT=$(echo "scale=5; 1.01018+$FPS/50000" | bc)
  fi

  SUB_BYTE=0

  for LANG_N in $(seq 0 $(( ${#SUB_LANG_alpha2[*]}-1 ))); do

    if [ "${SUB_FORMAT[$LANG_N]}" = VobSub ]; then
      SUB_BYTE=$(( SUB_BYTE+350*SEC ))

    else
      SUB_BYTE=$(( SUB_BYTE+12*SEC ))
    fi
  done

  MIN_PART_SEC=$(echo "(8*(1024*1024*$PART_MB-$OVERHEAD_BYTE)-8000000)/(1000*$MAX_VIDEO_BITRATE*$OVERHEAD_CONSTANT+8*($SUB_BYTE/$SEC+$AUDIO_BYTE/$SEC+$OVERHEAD_BYTERATE))" | bc)
  MIN_MB=$(echo "(($SEC*$MIN_VIDEO_BITRATE*$OVERHEAD_CONSTANT+8000)*1000/8+$SUB_BYTE+$AUDIO_BYTE+$OVERHEAD_BYTE+$SEC*$OVERHEAD_BYTERATE)/(1024*1024)+1" | bc)
  MIN_PARTS_NUM=$(( MIN_MB/PART_MB+1 ))

  MAX_PART_SEC=$(echo "(8*(1024*1024*$PART_MB-$OVERHEAD_BYTE)-8000000)/(1000*$MIN_VIDEO_BITRATE*$OVERHEAD_CONSTANT+8*($SUB_BYTE/$SEC+$AUDIO_BYTE/$SEC+$OVERHEAD_BYTERATE))" | bc)
  MAX_MB=$(echo "(($SEC*$MAX_VIDEO_BITRATE*$OVERHEAD_CONSTANT+8000)*1000/8+$SUB_BYTE+$AUDIO_BYTE+$OVERHEAD_BYTE+$SEC*$OVERHEAD_BYTERATE)/(1024*1024)+1" | bc)
  MAX_PARTS_NUM=$(( MAX_MB/PART_MB ))

  if (( MAX_PARTS_NUM > CHAPTERS_NUM )); then
    MAX_PARTS_NUM=$CHAPTERS_NUM
  fi

  if [ "$PREF_MODE" = cd ] && [ "$CHAPTERS_NUM" != 1 ] && (( MAX_MB >= PART_MB )) && (( MIN_PARTS_NUM <= MAX_PARTS_NUM )) ; then
    PARTS_NUM=$MIN_PARTS_NUM

    while (( MIN_PARTS_NUM <= MAX_PARTS_NUM && PARTS_NUM <= MAX_PARTS_NUM )); do
      SplittingCalculi
      PARTS_NUM=$(( PARTS_NUM+1 ))
    done
  fi
fi
}


SizeInput () {

if [ "$PREF_MODE" = mb ] || [ "$CHAPTERS_NUM" = 1 ] || (( MAX_MB < PART_MB )) || (( MIN_PARTS_NUM > MAX_PARTS_NUM )); then
  echo -e $(gettext "How many megabytes do you want to use?")" ($MIN_MB-$MAX_MB)\033[34;1m"  | fmt -w $(tput cols)
  read MB
  echo -e "\033[0m\c"

  if [ "$MB" = w ]; then
    less -p"NO WARRANTY" -G $DOC_DIR/COPYING
    echo
    SizeInput

  elif [ "$MB" = c ]; then
    less -p"You may copy" -G $DOC_DIR/COPYING
    echo
    SizeInput

  elif [ "$MB" = h ]; then
    echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
    echo -e "\b \b "$(gettext "Allowed answers are specified in brackets. Press 'enter' either to specify automatically the minimum allowed number of megabytes or, if you are changing some of your choices and your previous choice is still in the range of allowed answers, to confirm your previous choice.")"\033[0m\n" | fmt -t -w $(tput cols)
    SizeInput

  elif [ "$MB" = q ]; then
    exit $E_SUCCESS

  elif [ -z "$MB" ]; then
  
    if [ -n "$OLD_MB" ] && [ "$MODE" = mb ] && (( MIN_MB <= OLD_MB && OLD_MB <= MAX_MB )); then
      MB=$OLD_MB

    else
      MB=$MIN_MB
    fi

  elif [ -z "$(echo "$MB" | grep '^[1-9][0-9]*$')" ]; then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
    SizeInput

  elif (( MB > MAX_MB )); then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "The file size is too big for a MPEG-4 movie")"\033[0m" | fmt -t -w $(tput cols)
    SizeInput

  elif (( MB < MIN_MB )); then
    echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "The file size is not big enough for a good quality video encoding")"\033[0m" | fmt -t -w $(tput cols)
    SizeInput
  fi
  
  PARTS_NUM=1
  MODE=mb
  OLD_MB=$MB
  AUTO_PARTS_NUM=no
  
else

  if [ "$MIN_PARTS_NUM" = "$MAX_PARTS_NUM" ]; then
    AUTO_PARTS_NUM=yes
    PARTS_NUM=$MAX_PARTS_NUM
    
  else
    AUTO_PARTS_NUM=no
    echo -e $(gettext "How many parts do you want to split it into?")" ($MIN_PARTS_NUM-$MAX_PARTS_NUM)\033[34;1m"  | fmt -w $(tput cols)
    read PARTS_NUM
    echo -e "\033[0m\c"

    if [ "$PARTS_NUM" = w ]; then
      less -p"NO WARRANTY" -G $DOC_DIR/COPYING
      echo  
      SizeInput

    elif [ "$PARTS_NUM" = c ]; then
      less -p"You may copy" -G $DOC_DIR/COPYING
      echo
      SizeInput

    elif [ "$PARTS_NUM" = h ]; then
      echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
      echo -e "\b \b "$(gettext "Allowed answers are specified in brackets. The size of a part is that one you specified in the configuration file or with -s option. Press 'enter' either to specify automatically the minimum allowed number of parts or, if you are changing some of your choices and your previous choice is still in the range of allowed answers, to confirm your previous choice.")"\033[0m\n" | fmt -t -w $(tput cols)
      SizeInput

    elif [ "$PARTS_NUM" = q ]; then
      exit $E_SUCCESS

    elif [ -z "$PARTS_NUM" ]; then
      
      if [ -n "$OLD_PARTS_NUM" ] && [ "$MODE" = cd ] && (( MIN_PARTS_NUM <= OLD_PARTS_NUM && OLD_PARTS_NUM <= MAX_PARTS_NUM )); then
        PARTS_NUM=$OLD_PARTS_NUM

      else
        PARTS_NUM=$MIN_PARTS_NUM
      fi
   
    elif [ -z "$(echo "$PARTS_NUM" | grep '^[1-9][0-9]*$')" ]; then
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed a positive integer")"\033[0m" | fmt -t -w $(tput cols)
      SizeInput

    elif (( PARTS_NUM > MAX_PARTS_NUM )); then
       echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "The parts are too many for a MPEG-4 movie")"\033[0m" | fmt -t -w $(tput cols)
      SizeInput

    elif (( PARTS_NUM < MIN_PARTS_NUM )); then
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "The parts are not enough for a good quality video encoding")"\033[0m" | fmt -t -w $(tput cols)
      SizeInput
    fi
  fi

  MODE=cd
  MB=$(( PARTS_NUM*PART_MB ))
fi

if [ "$PARTS_NUM" != "$OLD_PARTS_NUM" ] || [ "$MB" != "$OLD_MB" ]; then
  FREE_SPACE_MB=$( df -mP "$WORKING_DIR" | sed -n "s/.*\ \([0-9]\+\)\ \+[0-9]*%.*/\1/p" )

  if [ "$NAMED_PIPES" = yes ]; then
    REQ_SPACE_MB=$(( MB+MB/PARTS_NUM+SEC*256*1000/(8*1024*1024)+3500*SEC/(PARTS_NUM*1024*1024) ))
  
  else

    if (( MB+MB/PARTS_NUM+SEC*256*1000/(8*1024*1024)+3500*SEC/(PARTS_NUM*1024*1024) < PCM_MB/PARTS_NUM+AUDIO_BYTE/(PARTS_NUM*1024*1024) )); then
      REQ_SPACE_MB=$(( $PCM_MB/PARTS_NUM+AUDIO_BYTE/(PARTS_NUM*1024*1024) ))

    else
      REQ_SPACE_MB=$(( MB+MB/PARTS_NUM+SEC*256*1000/(8*1024*1024)+3500*SEC/(PARTS_NUM*1024*1024) ))
    fi
  fi

  if (( REQ_SPACE_MB >= FREE_SPACE_MB )); then

    MISSING_SPACE_MB=$(( REQ_SPACE_MB-FREE_SPACE_MB+1 ))

    if [ "$AUTO_PARTS_NUM" = yes ]; then
      echo -e "\a\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "There isn't enough available disk space on this partition: press 'enter' after having removed \$MISSING_SPACE_MB MiB of data")"\033[0m" | fmt -t -w $(tput cols)
      read
      echo -e "\033[0m\c\c"

      case $REPLY in
        w ) less -p"NO WARRANTY" -G $DOC_DIR/COPYING;;

        c ) less -p"You may copy" -G $DOC_DIR/COPYING;;

        q ) exit $E_SUCCESS;;
      esac

    else
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(eval_gettext "There isn't enough available disk space on this partition: specify a smaller value or remove \$MISSING_SPACE_MB MiB of data")"\033[0m" | fmt -t -w $(tput cols)
    fi

  SizeInput

  else
    VIDEO_BITRATE=$( echo "(8*(1024*1024*$MB-$SUB_BYTE-$AUDIO_BYTE-$OVERHEAD_BYTE-$SEC*$OVERHEAD_BYTERATE)-8000000)/(1000*$SEC*$OVERHEAD_CONSTANT)"|bc )
    echo
  fi
  
else

  if [ "$TITLE" != "$OLD_TITLE" ] || [ "$FIRST_CHAPTER" != "$OLD_FIRST_CHAPTER" ] || [ "$LAST_CHAPTER" != "$OLD_LAST_CHAPTER" ]; then
    VIDEO_BITRATE=$( echo "(8*(1024*1024*$MB-$SUB_BYTE-$AUDIO_BYTE-$OVERHEAD_BYTE-$SEC*$OVERHEAD_BYTERATE)-8000000)/(1000*$SEC*$OVERHEAD_CONSTANT)"|bc )
  fi

  echo
fi
}


ScaleCalculi () {

if [ "$TITLE" != "$OLD_TITLE" ] || [ "$PARTS_NUM" != "$OLD_PARTS_NUM" ]; then
  SCALE_H=$(( $(printf %.f $(echo "scale=1;sqrt($VIDEO_BITRATE*1000*$ASPECT/($FPS*$BPP))/16" | bc))*16 ))
  
  if (( SCALE_H > MAX_SCALE_H )); then
    SCALE_H=$MAX_SCALE_H  
    
  elif (( SCALE_H < MIN_SCALE_H )); then
    SCALE_H=$MIN_SCALE_H
  fi
  
  SCALE_V=$(( $(printf %.f $(echo "scale=1;$SCALE_H/$ASPECT/16" | bc))*16 ))
  SCALE=$SCALE_H:$SCALE_V
fi
}


SplittingCalculi () {

unset PART_FIRST_CHAPTER
unset PART_LAST_CHAPTER
unset PART_FIRST_SEC
unset PART_LAST_SEC
unset PART_SEC

PART_LAST_CHAPTER[0]=$(( FIRST_CHAPTER-1 ))
PART_LAST_SEC[0]=$FIRST_SEC

if [ "$PARTS_NUM" != 1 ]; then
  for PART in $(seq 1 $(( PARTS_NUM-1 ))); do
    SPLIT_SEC=$(( PART*SEC/PARTS_NUM ))
    PART_LAST_CHAPTER[$PART]=${PART_LAST_CHAPTER[$(( PART-1 ))]}
    OLD_DIF=1
    NEW_DIF=0

    while (( NEW_DIF < OLD_DIF )); do
    
      if (( SPLIT_SEC > $(printf %.f ${PART_LAST_SEC[$PART]}) )); then
        OLD_DIF=$(( SPLIT_SEC-$(printf %.f ${PART_LAST_SEC[$PART]}) ))

      else
        OLD_DIF=$(( $(printf %.f ${PART_LAST_SEC[$PART]})-SPLIT_SEC ))
      fi

      PART_LAST_CHAPTER[$PART]=$(( ${PART_LAST_CHAPTER[$PART]}+1 ))

       if (( LAST_CHAPTER-${PART_LAST_CHAPTER[$PART]} < PARTS_NUM-PART )); then
         PART_LAST_CHAPTER[$PART]=$((  ${PART_LAST_CHAPTER[$PART]}-1  ))
         break
       fi

      PART_LAST_SEC[$PART]=$(echo "$DVDXCHAP_INFO" | grep -v "NAME" | cut -d = -f 2 | head -n $(( ${PART_LAST_CHAPTER[$PART]}+2 )) | tail -n 1 | sed 's/:/*3600\+/' | sed 's/:/*60\+/' | bc )
      PART_FIRST_SEC[$PART]=${PART_LAST_SEC[$(( PART-1 ))]}

      if (( SPLIT_SEC > $(printf %.f ${PART_LAST_SEC[$PART]}) )); then
        NEW_DIF=$(( SPLIT_SEC-$(printf %.f ${PART_LAST_SEC[$PART]}) ))

      else
        NEW_DIF=$(( $(printf %.f ${PART_LAST_SEC[$PART]})-SPLIT_SEC ))
      fi
    done

    PART_LAST_SEC[$PART]=$(echo "$DVDXCHAP_INFO" | grep -v "NAME" | cut -d = -f 2 | head -n $(( ${PART_LAST_CHAPTER[$PART]}+1 )) | tail -n 1 | sed 's/:/*3600\+/' | sed 's/:/*60\+/' | bc )
    PART_FIRST_CHAPTER[$(( PART+1 ))]=$(( ${PART_LAST_CHAPTER[$PART]}+1 ))
  done
fi

PART_FIRST_CHAPTER[1]=$FIRST_CHAPTER
PART_LAST_CHAPTER[$PARTS_NUM]=$LAST_CHAPTER
PART_FIRST_SEC[$PARTS_NUM]=${PART_LAST_SEC[$(( PARTS_NUM-1 ))]}
PART_LAST_SEC[$PARTS_NUM]=$LAST_SEC

for PART in $( seq 1 $PARTS_NUM ); do
  PART_SEC[$PART]=$(echo ${PART_LAST_SEC[$PART]}-${PART_LAST_SEC[$(( PART-1 ))]} | bc )

 if (( $(printf %.f ${PART_SEC[$PART]}) < MIN_PART_SEC || $(printf %.f ${PART_SEC[$PART]}) > MAX_PART_SEC )); then
   MAX_PARTS_NUM=$(( PARTS_NUM-1 ))
 fi
done
}


SummaryDisplayer () {

echo -e "\n\033[37;46;1m "$(gettext "Summary")" \033[0m\n
[File]\t"$(gettext "Format")": \033[1m$CONTAINER_FMT_NAME\033[0m
\t"$(gettext "Source")": "$(gettext "title")" \033[34;1m$TITLE\033[0m, "$(ngettext "chapter" "chapters" $CHAPTERS_NUM)" \c"

if [ "$PARTS_NUM" = 1 ]; then

    if [ "$CHAPTERS_NUM" = 1 ]; then
      echo -e "\033[34;1m${PART_FIRST_CHAPTER[$PART]}\033[0m"

    else
      echo -e "\033[34;1m${PART_FIRST_CHAPTER[$PART]}\033[0m-\033[34;1m${PART_LAST_CHAPTER[$PART]}\033[0m"
    fi

else
  
  for PART in $(seq 1 $PARTS_NUM); do

    if (( ${PART_LAST_CHAPTER[$PART]}-${PART_FIRST_CHAPTER[$PART]} != 0 )); then

      if [ "$PART" = 1 ]; then
        echo -e "\033[34;1m${PART_FIRST_CHAPTER[$PART]}\033[0m-${PART_LAST_CHAPTER[$PART]} \c"

      elif  [ "$PART" = "$PARTS_NUM" ]; then
        echo -e "${PART_FIRST_CHAPTER[$PART]}-\033[34;1m${PART_LAST_CHAPTER[$PART]}\033[0m \c"

      else
        echo -e "${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} \c"
      fi

    else

      if [ "$PART" = 1 ]; then
        echo -e "\033[34;1m${PART_FIRST_CHAPTER[$PART]}\033[0m \c"

      elif  [ "$PART" = "$PARTS_NUM" ]; then
        echo -e "\033[34;1m${PART_FIRST_CHAPTER[$PART]}\033[0m \c"

      else
        echo -e "${PART_FIRST_CHAPTER[$PART]} \c"
      fi
    fi
  done

  echo
fi

echo -e "\t"$(gettext "Name")": \033[34;1m$NAME\033[0m
\t\033[0m"$(gettext "Destination")": \033[1m$DESTINATION_DIR\033[0m
\tSize: \c"

if [ "$PARTS_NUM" = 1 ];   then
  echo -e "\033[34;1m$MB\033[0m MiB"

else
  echo -e "\033[1m$PART_MB\033[0m MiB X \033[34;1m$PARTS_NUM\033[0m"
fi

echo -e "\t"$(gettext "Length")": $(( SEC/3600 )) h $(( SEC%3600/60 )) min $(( SEC%60 )) s
[Video]\t"$(gettext "Encoding")": \033[1m$VIDEO_ENC_NAME\033[0m (MPEG-4)
\t"$(gettext "Bit rate")": \033[32;1m$VIDEO_BITRATE\033[0m kbit/s
\t"$(gettext "Resolution")": \033[32;1m$SCALE_H\033[0m X \033[32;1m$SCALE_V\033[0m pixels
\t"$(gettext "Source format")": \033[34;1m$VIDEO_FORMAT\033[0m
[Audio]\t"$(ngettext "Encoding" "Encodings" ${#AUDIO_ENC[*]})": \033[1m$(echo ${AUDIO_ENC[*]} | sed "s/ /, /g" )\033[0m
\t"$(gettext "Quality")": \c"

if [ "${AUDIO_ENC[0]}" = Vorbis ]; then
  echo -e "\033[1m${OGG_QUALITY[0]}\033[0m, 2 "$(ngettext "channel" "channels" ${AUDIO_CHANNELS[0]})", 44100 Hz\c"
  
  if [ "$OGG_VOLUME" = 0 ]; then
    echo

  elif [ "$OGG_VOLUME" = norm ]; then
    echo -e ", \033[1m"$(gettext "normalised")"\033[0m"

  else
    echo -e ", +\033[1m$OGG_VOLUME\033[0m dB"
  fi

else
  echo -e "${AUDIO_BITRATE[0]} kbit/s, ${AUDIO_CHANNELS[0]} "$(ngettext "channel" "channels" ${AUDIO_CHANNELS[0]})", 48000 Hz"
fi

echo -e "\t"$(ngettext "Language" "Languages" ${#AUDIO_LANG_DISPLAY[*]})": \033[1m$(echo ${AUDIO_LANG_DISPLAY[*]} | sed "s/ /, /g" )\033[0m
[Sub]\t"$(ngettext "Format" "Formats" ${#SUB_FMT[*]})": \c"

if [ -n "${SUB_LANG_alpha2[*]}" ]; then
  echo -e "\033[1m$(echo ${SUB_FMT[*]} | sed "s/ /, /g" )\033[0m"

else
  echo -e "\033[1m-\033[0m"
fi

echo -e "\t"$(ngettext "Language" "Languages" ${#SUB_LANG_DISPLAY[*]})": \c"

if [ -n "${SUB_LANG_alpha2[*]}" ]; then
  echo -e "\033[1m$(echo ${SUB_LANG_DISPLAY[*]} | sed "s/ /, /g" )\033[0m\n\n"

else
  echo -e "\033[1m-\033[0m\n\n"
fi
}


LastQuestion () {

echo $(gettext "What do you want to do?")" (1-3)" | fmt -w $(tput cols)

select LAST_ANSWER in "$ANSWER_1" "$ANSWER_2" "$ANSWER_3"; do

  case $REPLY in
    w ) less -p"NO WARRANTY" -G $DOC_DIR/COPYING    
    LastQuestion
    break;;

    c ) less -p"You may copy" -G $DOC_DIR/COPYING
    LastQuestion
    break;;

    h ) echo -e "\a\n\033[33;42;1m ! \033[0;1m \c"
    echo -e "\b \b "$(gettext "Allowed answers are specified in brackets. If you choose 'Start to encode and halt the system when the job ends' ANDREW will create a log file in your destination directory."; gettext "If you choose 'Change some of my choices' ANDREW will ask you the questions again: press 'enter' to confirm your previous choice; to change the choices you did in your configuration file, quit, modify your configuration file and invoke ANDREW again, otherwise invoke ANDREW with different options.")"\033[0m\n" | fmt -t -w $(tput cols)
    LastQuestion
    break;;
     
    q ) exit $E_SUCCESS;;

    1 ) OLD_TITLE=
    OLD_PARTS_NUM=
    echo
    break;;

    2 ) if [ -x "$(type -P shutdown)" ]; then
      HALT="shutdown -h now"
    elif [ -x "$(type -P halt)" ]; then
      HALT=halt
    else
      echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You aren't allowed to bring the system down")"\033[0m" | fmt -t -w $(tput cols)
      LastQuestion
      break
    fi
    OLD_TITLE=
    OLD_PARTS_NUM=
    echo
    break;;

    3 ) echo
    OLD_TITLE=$TITLE
    OLD_FIRST_CHAPTER=$FIRST_CHAPTER
    OLD_LAST_CHAPTER=$LAST_CHAPTER
    OLD_PARTS_NUM=$PARTS_NUM
    echo -e "\n\033[37;46;1m "$(gettext "About this movie")" \033[0m\n"
    NameInput
    TitleInput
    TitleCalculi
    VideoFormatInput
    CropCalculi
    SubAudioCalculi
    PartCalculi
    SizeInput
    ScaleCalculi
    SplittingCalculi
    SummaryDisplayer
    LastQuestion
    break;;

    * ) echo -e "\a\n\033[33;41;1m "$(gettext "ERROR")" \033[0;1m "$(gettext "You haven't typed any of available options")"\033[0m" | fmt -t -w $(tput cols)
    LastQuestion
    break;;
 esac
done
}


#-------2b) Functions call

echo -e "\n\033[37;46;1m "$(gettext "About this movie")" \033[0m\n"

NameInput
TitleInput
TitleCalculi
VideoFormatInput
CropCalculi
SubAudioCalculi
PartCalculi
SizeInput
ScaleCalculi
SplittingCalculi
SummaryDisplayer
LastQuestion



#---3) Encoding


#-------3a) Functions declaration

PreEncoding () {

for LANG_N in $(seq 0 $(( ${#SUB_LANG_alpha2[*]}-1 ))); do

  if [ "${SUB_FORMAT[$LANG_N]}" = VobSub ]; then
    echo -e "1\n00:00:00,000 --> 00:00:00,000\ndummy\n" > dummy_srt
    SUB_TRACKS[$LANG_N]="--language 0:${SUB_LANG_alpha3[$LANG_N]} sub_$LANG_N.idx"

  elif [ "${SUB_FORMAT[$LANG_N]}" = SRT ]; then
    sed -e "s/\r$//" -e "s/\r/\n/" "$SRT_DIR/${SUB_LANG_alpha2[$LANG_N]}.srt" > ${SUB_LANG_alpha2[$LANG_N]}.srt
    SUB_TRACKS[$LANG_N]="--language 0:${SUB_LANG_alpha3[$LANG_N]} --sub-charset 0:UTF-8 sub_$LANG_N"
  fi
done

for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do

  if [ "$OGG_VOLUME" = 0 ]; then
    AUDIO_FILTERS[$LANG_N]="-af resample=44100"

  elif [ "$OGG_VOLUME" = norm ]; then
    AUDIO_FILTERS[$LANG_N]="-af volnorm,resample=44100"

  else
    AUDIO_FILTERS[$LANG_N]="-af volume=$OGG_VOLUME,resample=44100"
  fi

  if [ "$CONTAINER_FORMAT" = mkv ]; then
    AUDIO_TRACKS[$LANG_N]="--language 0:${AUDIO_LANG_alpha3[$LANG_N]} audio_$LANG_N"

  else
    AUDIO_TRACKS[$LANG_N]="-c LANGUAGE=${AUDIO_LANG_OGM[$LANG_N]} audio_$LANG_N"
  fi
done

KEYINT_FRAMES=$(printf %.f $(echo "$KEYINT_SEC*$FPS" | bc))

case $VIDEO_FORMAT in
  "PAL" ) VIDEO_FILTERS="crop=$CROP";;

  "PAL-$INTERLACED" | "NTSC-$INTERLACED" | "NTSC-($PROGRESSIVE/)$INTERLACED" ) if [ "$VIDEO_ENCODING" = ffmpeg ]; then
    INTERLACING=":ildct:ilme"

  else
    INTERLACING=":interlacing"
  fi

  VIDEO_FILTERS="crop=$CROP";;
  
  "NTSC-$PROGRESSIVE" ) FRAMERATE_SHIFT="-ofps 23.976"
  VIDEO_FILTERS="crop=$CROP";;
 
  "NTSC-$TELECINE" ) FRAMERATE_SHIFT="-ofps 23.976"
  VIDEO_FILTERS="ivtc=1,crop=$CROP";;
  
  "NTSC-$PROGRESSIVE/$TELECINE" ) FRAMERATE_SHIFT="-ofps 23.976"
  VIDEO_FILTERS="softpulldown,ivtc=1,crop=$CROP";;
   
  "NTSC-$PROGRESSIVE(/$INTERLACED)" ) FRAMERATE_SHIFT="-ofps 23.976"
  VIDEO_FILTERS="crop=$CROP,pp=lb";;
esac

if [ "$PARTS_NUM" != 1 ]; then
  MB=$PART_MB
fi
}


ChapterIndexSplitter () {

TIME_SEC=$(echo "$DVDXCHAP_INFO" | grep -v "NAME" | cut -d = -f 2 | head -n ${PART_LAST_CHAPTER[$PART]} | tail -n $(( ${PART_LAST_CHAPTER[$PART]}-${PART_FIRST_CHAPTER[$PART]}+1 )) | sed -e 's/:/*3600\+/' -e 's/:/*60\+/' -e 's/\(.*\)/\1\-'${PART_LAST_SEC[$(( PART-1 ))]}'/' | bc )
TIME_HHMMSSMS=$(printf "%02d:%02d:%06.3f\n" $(echo "$TIME_SEC" | sed 's/\(.*\)/\1\/3600;\1%3600\/60;\1%60/' | bc))

for PART_CHAPTER in $(seq 1 $(( ${PART_LAST_CHAPTER[$PART]}-${PART_FIRST_CHAPTER[$PART]}+1 ))); do
  echo -e "CHAPTER"$(printf %02d $PART_CHAPTER)"="$(echo "$TIME_HHMMSSMS"  | head -n $PART_CHAPTER | tail -n 1)"\nCHAPTER"$(printf %02d $PART_CHAPTER)"NAME=Chapter "$(( PART_CHAPTER+${PART_LAST_CHAPTER[$(( PART-1 ))]}-${PART_FIRST_CHAPTER[1]}+1 ))
done > index
}


SubtitleRipper () {

for LANG_N in $(seq 0 $(( ${#SUB_LANG_alpha2[*]}-1 ))); do

  if [ "${SUB_FORMAT[$LANG_N]}" = VobSub ]; then
    echo -e "\n\n\033[37;46;1m "$(gettext "VobSub subtitle extraction")": ${SUB_LANG_DISPLAY[$LANG_N]} \033[0m\n"
    echo -e "mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -nosound -ovc copy -o /dev/null -vobsubout sub_$LANG_N -vobsuboutindex ${SUB_DVD_ID[$LANG_N]} -sid ${SUB_DVD_ID[$LANG_N]}\n"
    mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -nosound -ovc copy -o /dev/null -vobsubout sub_$LANG_N -vobsuboutindex ${SUB_DVD_ID[$LANG_N]} -sid ${SUB_DVD_ID[$LANG_N]}

  elif [ "${SUB_FORMAT[$LANG_N]}" = SRT ]; then
    echo -e "\n\n\033[37;46;1m "$(gettext "SRT subtitle splitting")": ${SUB_LANG_DISPLAY[$LANG_N]} \033[0m\n"
    gettext "Please wait..."

    SUB_FIRST_SEC=( 0 $(sed -n -e 's/^\([0-9]\{2\}\):\([0-9]\{2\}\):\([0-9]\{2\}\),\([0-9]\{3\}\)\ -->\ .*$/\1*3600+\2*60+\3.\4/p' ${SUB_LANG_alpha2[$LANG_N]}.srt | bc) 0 )
    SUB_LAST_SEC=( 0 $(sed -n -e 's/^.*\ -->\ \([0-9]\{2\}\):\([0-9]\{2\}\):\([0-9]\{2\}\),\([0-9]\{3\}\)$/\1*3600+\2*60+\3.\4/p' ${SUB_LANG_alpha2[$LANG_N]}.srt | bc) 0 )
    SUB_NUM=$(( ${#SUB_FIRST_SEC[*]}-2 ))

    if [ "$PART" = 1 ]; then
      echo -e "\n$(( $(sed -n 's/^\([0-9]\+\)$/\1/p' ${SUB_LANG_alpha2[$LANG_N]}.srt | tail -n 1)+1 ))" >> ${SUB_LANG_alpha2[$LANG_N]}.srt

      PART_FIRST_SUB_SEC[$LANG_N]=0
      PART_FIRST_SUB[$LANG_N]=0

      while [ "$(echo "${PART_FIRST_SEC[$PART]}<${PART_FIRST_SUB_SEC[$LANG_N]}" | bc)" = 0 ] && (( ${PART_FIRST_SUB[$LANG_N]}<=SUB_NUM )); do
        PART_FIRST_SUB[$LANG_N]=$(( ${PART_FIRST_SUB[$LANG_N]}+1 ))
        PART_FIRST_SUB_SEC[$LANG_N]=${SUB_FIRST_SEC[${PART_FIRST_SUB[$LANG_N]}]}
      done
    fi

    PART_LAST_SUB_SEC=${SUB_FIRST_SEC[${PART_FIRST_SUB[$LANG_N]}]}
    PART_LAST_SUB=$(( ${PART_FIRST_SUB[$LANG_N]} ))

    while [ $(echo "${PART_LAST_SEC[$PART]}<$PART_LAST_SUB_SEC" | bc) = 0 ] && (( PART_LAST_SUB<=SUB_NUM )); do
      PART_LAST_SUB=$(( PART_LAST_SUB+1 ))
      PART_LAST_SUB_SEC=${SUB_FIRST_SEC[$PART_LAST_SUB]}
    done

    PART_LAST_SUB=$(( PART_LAST_SUB-1 ))
    PART_LAST_SUB_SEC=${SUB_FIRST_SEC[$PART_LAST_SUB]}

    if (( PART_LAST_SUB>=${PART_FIRST_SUB[$LANG_N]} )); then
      PART_FIRST_SUB_HHMMSSMS=( 0 $(printf "%02d:%02d:%06.3f\n" $(for SEC in ${SUB_FIRST_SEC[*]:1}; do echo $SEC; done | sed -n ""${PART_FIRST_SUB[$LANG_N]}","$PART_LAST_SUB"s/\(.*\)/(\1-${PART_FIRST_SEC[$PART]})\/3600;(\1-${PART_FIRST_SEC[$PART]})%3600\/60;(\1-${PART_FIRST_SEC[$PART]})%60/p" | bc) | tr . ,) )
      PART_LAST_SUB_HHMMSSMS=( 0 $(printf "%02d:%02d:%06.3f\n" $(for SEC in ${SUB_LAST_SEC[*]:1}; do echo $SEC; done | sed -n ""${PART_FIRST_SUB[$LANG_N]}","$PART_LAST_SUB"s/\(.*\)/(\1-${PART_FIRST_SEC[$PART]})\/3600;(\1-${PART_FIRST_SEC[$PART]})%3600\/60;(\1-${PART_FIRST_SEC[$PART]})%60/p" | bc) | tr . ,) )

      for SUB_N in $(seq 1 $(( PART_LAST_SUB-${PART_FIRST_SUB[$LANG_N]}+1 ))); do
        PART_FIRST_SUB_LINE=$(( $(grep -xn $(( ${PART_FIRST_SUB[$LANG_N]}+SUB_N-1 )) ${SUB_LANG_alpha2[$LANG_N]}.srt | cut -d : -f 1)+2 ))
        PART_LAST_SUB_LINE=$(( $(grep -xn $(( ${PART_FIRST_SUB[$LANG_N]}+SUB_N )) ${SUB_LANG_alpha2[$LANG_N]}.srt | cut -d : -f 1)-1 ))

        echo "$SUB_N
${PART_FIRST_SUB_HHMMSSMS[$((SUB_N))]} --> ${PART_LAST_SUB_HHMMSSMS[$((SUB_N))]}
$(sed -n -e "$PART_FIRST_SUB_LINE,$PART_LAST_SUB_LINE"p ${SUB_LANG_alpha2[$LANG_N]}.srt)
"
      done > sub_$LANG_N

    else
      echo -e "1\n00:00:00,000 --> 00:00:00,000\n\n" > sub_$LANG_N
    fi

    if [ "$PART" != "$PARTS_NUM" ]; then
      PART_FIRST_SUB_SEC[$LANG_N]=$PART_LAST_SUB_SEC
      PART_FIRST_SUB[$LANG_N]=$(( PART_LAST_SUB+1 ))
    fi

    echo " $(gettext "Done.")"
  fi
done
}


AudioEncoder () {

for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do

  if [ "${AUDIO_ENCODING[$LANG_N]}" = Vorbis ]; then

    if [ "$NAMED_PIPES" = yes ]; then
      echo -e "\n\n\033[37;46;1m "$(gettext "Vorbis audio encoding")": ${AUDIO_LANG_DISPLAY[$LANG_N]} \033[0m\n"
      echo -e "mkfifo pcm_$LANG_N
oggenc -q ${OGG_QUALITY[$LANG_N]} -r pcm_$LANG_N -o audio_$LANG_N &
mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -vc null -vo null ${AUDIO_FILTERS[$LANG_N]} -really-quiet -ao pcm:nowaveheader:file=pcm_$LANG_N\n"
      mkfifo pcm_$LANG_N
      oggenc -q ${OGG_QUALITY[$LANG_N]} -r pcm_$LANG_N -o audio_$LANG_N &
      mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -vc null -vo null ${AUDIO_FILTERS[$LANG_N]} -really-quiet -ao pcm:nowaveheader:file=pcm_$LANG_N

    else
      echo -e "\n\n\033[37;46;1m "$(gettext "PCM audio encoding")": ${AUDIO_LANG_DISPLAY[$LANG_N]} \033[0m\n"
      echo -e "mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -vc null -vo null ${AUDIO_FILTERS[$LANG_N]} -ao pcm:nowaveheader:file=pcm_$LANG_N\n"
      mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -vc null -vo null ${AUDIO_FILTERS[$LANG_N]} -ao pcm:nowaveheader:file=pcm_$LANG_N

      echo -e "\n\n\033[37;46;1m "$(gettext "Vorbis audio encoding")": ${AUDIO_LANG_DISPLAY[$LANG_N]} \033[0m\n"
      echo -e "oggenc -q ${OGG_QUALITY[$LANG_N]} -r pcm_$LANG_N -o audio_$LANG_N\n"
      oggenc -q ${OGG_QUALITY[$LANG_N]} -r pcm_$LANG_N -o audio_$LANG_N
    fi

    rm -f pcm_$LANG_N
  
  else
    echo -e "\n\n\033[37;46;1m "$(gettext "AC-3 audio extraction")": ${AUDIO_LANG_DISPLAY[$LANG_N]} \033[0m\n"
    echo -e "mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -dumpaudio -dumpfile audio_$LANG_N\n"
    mplayer -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -aid ${AUDIO_DVD_ID[$LANG_N]} -dumpaudio -dumpfile audio_$LANG_N
  fi
done
}


VideoBitrateCalculi () {

SUB_BYTE=0

for LANG_N in $(seq 0 $(( ${#SUB_LANG_alpha2[*]}-1 ))); do
  if [ "${SUB_FORMAT[$LANG_N]}" = VobSub ]; then
    mkvmerge dummy_srt sub_$LANG_N.idx -o check_size_1 &> /dev/null
    mkvmerge dummy_srt sub_$LANG_N.idx sub_$LANG_N.idx -o check_size_2 &> /dev/null
    SUB_TRACK_BYTE=$(( $(stat -c %s check_size_2)-$(stat -c %s check_size_1) ))

  elif [ "${SUB_FORMAT[$LANG_N]}" = SRT ]; then

    mkvmerge sub_$LANG_N -o check_size_1 &> /dev/null
    mkvmerge sub_$LANG_N sub_$LANG_N -o check_size_2 &> /dev/null
    SUB_TRACK_BYTE=$(( $(stat -c %s check_size_2)-$(stat -c %s check_size_1) ))
  fi

  SUB_BYTE=$(( SUB_BYTE+SUB_TRACK_BYTE ))
  rm -f check_size_*
done

AUDIO_BYTE=0
AUDIO_OVERHEAD_BYTE=0

for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do

  if [ "${AUDIO_ENCODING[$LANG_N]}" = Vorbis ]; then
    AUDIO_TRACK_BYTE=$(ogginfo audio_$LANG_N | grep "Total" |cut -d " " -f 4)
      
    if [ "$CONTAINER_FORMAT" = mkv ]; then
      AUDIO_TRACK_OVERHEAD_BYTE=$(printf %.f $(echo "1.25*(${PART_SEC[$PART]}*64-$AUDIO_TRACK_BYTE*8/1000)+3950" | bc))

    else
      AUDIO_TRACK_OVERHEAD_BYTE=$(( $(stat -c %s audio_$LANG_N)-$AUDIO_TRACK_BYTE ))
    fi

  else
    AUDIO_TRACK_BYTE=$(stat -c %s audio_$LANG_N)

    if [ "$CONTAINER_FORMAT" = mkv ]; then
      AUDIO_TRACK_OVERHEAD_BYTE=$(printf %.f $(echo "${PART_SEC[$PART]}*312.45+95" | bc))

    else
       AUDIO_TRACK_OVERHEAD_BYTE=$(printf %.f $(echo "$AUDIO_TRACK_BYTE*0.0131" | bc))
    fi
  fi

  AUDIO_BYTE=$(( AUDIO_BYTE+AUDIO_TRACK_BYTE ))
  AUDIO_OVERHEAD_BYTE=$(( AUDIO_OVERHEAD_BYTE+AUDIO_TRACK_OVERHEAD_BYTE ))
done
 
if [ "$CONTAINER_FORMAT" = mkv ]; then
  OVERHEAD_BYTE=$(printf %.f $(echo "${PART_SEC[$PART]}*(15.4+12.9*$FPS)+5420+$AUDIO_OVERHEAD_BYTE" | bc))
  OVERHEAD_CONSTANT=1

else
  OVERHEAD_BYTE=$AUDIO_OVERHEAD_BYTE
  OVERHEAD_CONSTANT=$(echo "scale=5; 1.01018+$FPS/50000" | bc)
fi

VIDEO_BITRATE=$(echo "(8*(1024*1024*$MB-$AUDIO_BYTE-$OVERHEAD_BYTE)-8000000)/(1000*${PART_SEC[$PART]}*$OVERHEAD_CONSTANT)" | bc)
}


VideoEncoder () {

PASS=$1
echo -e "\n\n\033[37;46;1m "$(eval_gettext "\$VIDEO_ENC_NAME video encoding: pass \$PASS")" $REPEAT_LABEL\033[0m\n"

if [ "$VIDEO_ENCODING" = ffmpeg ]; then
  echo -e "mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -oac pcm -srate 8000 -ovc lavc -lavcopts vcodec=mpeg4:vpass=$1:vbitrate=$VIDEO_BITRATE:$LAVCOPTS:keyint=$KEYINT_FRAMES:autoaspect$INTERLACING -vf $VIDEO_FILTERS,scale=$SCALE $FRAMERATE_SHIFT -o video_$1\n"
  mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -oac pcm -srate 8000 -ovc lavc -lavcopts vcodec=mpeg4:vpass=$1:vbitrate=$VIDEO_BITRATE:$LAVCOPTS:keyint=$KEYINT_FRAMES:autoaspect$INTERLACING -vf $VIDEO_FILTERS,scale=$SCALE $FRAMERATE_SHIFT -o video_$1

else
  echo -e "mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -oac pcm -srate 8000 -ovc xvid -xvidencopts pass=$1:bitrate=$VIDEO_BITRATE:$XVIDENCOPTS:max_key_interval=$KEYINT_FRAMES:autoaspect$INTERLACING -vf $VIDEO_FILTERS,scale=$SCALE $FRAMERATE_SHIFT -o video_$1\n"
  mencoder -dvd-device "$DVD_DEVICE" dvd://$TITLE -chapter ${PART_FIRST_CHAPTER[$PART]}-${PART_LAST_CHAPTER[$PART]} -oac pcm -srate 8000 -ovc xvid -xvidencopts pass=$1:bitrate=$VIDEO_BITRATE:$XVIDENCOPTS:max_key_interval=$KEYINT_FRAMES:autoaspect$INTERLACING -vf $VIDEO_FILTERS,scale=$SCALE $FRAMERATE_SHIFT -o video_$1
fi
}


QuantizerCalculi () {

if [ "$VIDEO_ENCODING" = ffmpeg ]; then
  QUANT_MATRIX=$(cut -d " " -f 4 < divx2pass.log | cut -d : -f 2 | sort | uniq -c | sed -e "s/ *//" -e "s/ \+/\t/")
  QUANT_VALUE=( $(echo "$QUANT_MATRIX" | cut -f 2) )
  QUANT_WEIGHT=( $(echo "$QUANT_MATRIX" | cut -f 1) )
  QUANT_NUM=$(wc -l <divx2pass.log)

  QUANT_SUM=0

  for QUANT_N in $(seq 0 $(( ${#QUANT_VALUE[*]}-1 ))); do
    QUANT_SUM=$(( QUANT_SUM+${QUANT_VALUE[$QUANT_N]}*${QUANT_WEIGHT[$QUANT_N]} ))
  done

  QUANT_MEAN=$(( QUANT_SUM/QUANT_NUM ))
fi
}


ResolutionOptimiser () {

if [ "$VIDEO_ENCODING" = ffmpeg ]; then
  if [ "$RES_OPTIMIZATION" = 1 ]; then
    FIRST_PASS_BYTE=$(mplayer video_1 -frames 0 -v -vo null -ao null 2> /dev/null | sed -n "s/AVI video size=\(.*\) (.*audio.*/\1/p")
    TARGET_BYTE=$(echo "(1024*1024*$MB-$SUB_BYTE-$AUDIO_BYTE-$OVERHEAD_BYTE-8000000/8)/$OVERHEAD_CONSTANT" | bc)
    NEW_SCALE_H=$(( $(printf %.f $(echo "scale=1;$SCALE_H*sqrt(($TARGET_BYTE*270)/($FIRST_PASS_BYTE*$QUANT_MEAN))/16" | bc))*16 ))
    NEW_SCALE_V=$(( $(printf %.f $(echo "scale=1;$NEW_SCALE_H/$ASPECT/16" | bc))*16 ))

    if (( MIN_SCALE_V > NEW_SCALE_V )); then
      NEW_SCALE_H=$MIN_SCALE_H
      NEW_SCALE_V=$MIN_SCALE_V
      
    elif (( NEW_SCALE_V > MAX_SCALE_V )); then
      NEW_SCALE_H=$MAX_SCALE_H
      NEW_SCALE_V=$MAX_SCALE_V
    fi

    if [ "$SCALE_V" != "$NEW_SCALE_V" ]; then
      SCALE=$NEW_SCALE_H:$NEW_SCALE_V
      REPEAT_LABEL=$(echo "("$(gettext "repetition")") ")
      VideoEncoder 1
      QuantizerCalculi
      REPEAT_LABEL=
    fi
  fi
fi

rm -f video_1
}


TrackMerger () {

if [ -n "${SUB_LANG_alpha2[*]}" ]; then
  echo -e "\n\n\033[37;46;1m "$(eval_gettext "Index, subtitles, audio and video into a single \$CONTAINER_FMT_NAME file merging")" $REPEAT_LABEL\033[0m\n"

else
  echo -e "\n\n\033[37;46;1m "$(eval_gettext "Index, audio and video into a single \$CONTAINER_FMT_NAME file merging")" $REPEAT_LABEL\033[0m\n"
fi

if [ "$CONTAINER_FORMAT" = mkv ]; then
  echo -e "mkvmerge --title \"$NAME\" --chapters index ${SUB_TRACKS[*]} ${AUDIO_TRACKS[*]} -A video_2 -o \"$NAME\"[$VIDEO_ENC_NAME\ -\ \"${AUDIO_ENC[*]}\"\ -\ \"${AUDIO_LANG_ALPHA3[*]}\""$FILENAME_SPACE"\"${SUB_LANG_alpha3[*]}\"].mkv\n"
  mkvmerge --title "$NAME" --chapters index ${AUDIO_TRACKS[*]} ${SUB_TRACKS[*]} -A video_2 -o "$NAME"\ [$VIDEO_ENC_NAME\ -\ "${AUDIO_ENC[*]}"\ -\ "${AUDIO_LANG_ALPHA3[*]}""$FILENAME_SPACE""${SUB_LANG_alpha3[*]}"].mkv
  
else
  echo -e "ogmmerge ${AUDIO_TRACKS[*]} -c \"TITLE=$NAME\" -A video_2 index -o \"$NAME\"\ [$VIDEO_ENC_NAME\ -\ \"${AUDIO_ENC[*]}\"\ -\ \"${AUDIO_LANG_ALPHA3[*]}\""$FILENAME_SPACE"\"${SUB_LANG_alpha3[*]}\"].ogm\n"
  ogmmerge ${AUDIO_TRACKS[*]} -c "TITLE=$NAME" -A video_2 index -o "$NAME"\ [$VIDEO_ENC_NAME\ -\ "${AUDIO_ENC[*]}"\ -\ "${AUDIO_LANG_ALPHA3[*]}""$FILENAME_SPACE""${SUB_LANG_alpha3[*]}"].ogm

  if [ "$?" != 0 ]; then
    echo -e "\n\n\033[37;46;1m "$(gettext "Non AC-3 data removal")" \033[0m\n"

    for LANG_N in $(seq 0 $(( ${#AUDIO_LANG_alpha2[*]}-1 ))); do
      echo -e "mkvmerge audio_$LANG_N -o clean_$LANG_N\n"
      mkvmerge audio_$LANG_N -o clean_$LANG_N
      echo -e "\nmkvextract tracks clean_$LANG_N 1:audio_$LANG_N\n"
      mkvextract tracks clean_$LANG_N 1:audio_$LANG_N
      rm -f clean_$LANG_N
    done

    REPEAT_LABEL="($(gettext "repetition")) "
    TrackMerger
    REPEAT_LABEL=
  fi
fi

rm -f sub_*
}


JustStats () {

SUB_BYTE[$PART]=$SUB_BYTE
AUDIO_BYTE[$PART]=$AUDIO_BYTE
VIDEO_BYTE[$PART]=$(mplayer video_2 -frames 0 -v -vo null -ao null 2> /dev/null | sed -n "s/AVI video size=\(.*\) (.*audio.*/\1/p")
VIDEO_BITRATE[$PART]=$(echo "scale=1;8*${VIDEO_BYTE[$PART]}/(${PART_SEC[$PART]}*1000)" | bc)
SCALE[$PART]=$SCALE
MOVIE_BYTE[$PART]=$(stat -c %s "$NAME"*.*)
BPP[$PART]=$( printf %.2f $(echo "scale=3;${VIDEO_BITRATE[$PART]}*1000/($(echo ${SCALE[$PART]} | tr : "*")*$FPS)" | bc))
OVERHEAD[$PART]=$(printf %.4f $(echo "scale=5;${MOVIE_BYTE[$PART]}/(${VIDEO_BYTE[$PART]}+${AUDIO_BYTE[$PART]}+${SUB_BYTE[$PART]})-1" | bc))

if [ "$VIDEO_ENCODING" = ffmpeg ]; then
  QUAD=0

  for QUANT_N in $(seq 0 $(( ${#QUANT_VALUE[*]}-1 ))); do
    QUAD=$(( QUAD+(${QUANT_VALUE[$QUANT_N]}-$QUANT_MEAN)**2*${QUANT_WEIGHT[$QUANT_N]} ))
  done

  QUANT_STDEV[$PART]=+/-$(printf %.2f $(echo "scale=3;sqrt($QUAD/($QUANT_NUM-1))/100" | bc))
  QUANT_MEAN[$PART]=$(echo "scale=2;$QUANT_MEAN/100" | bc) 
  
else
  QUANT_MEAN[$PART]=-
fi
}


PostEncoding () {

echo -e "\n\n\033[37;46;1m "$(eval_ngettext "\$CONTAINER_FMT_NAME file to destination directory moving" "\$CONTAINER_FMT_NAME files to destination directory moving" $PARTS_NUM)" \033[0m\n"

if (( (MB*PARTS_NUM+1) < $(df -mP "$DESTINATION_DIR" | sed -n "s/.*\ \([0-9]\+\)\ \+[0-9]*%.*/\1/p") )); then
  mv --backup=t -f "$OLD_NAME"* psnr* "$DESTINATION_DIR" &> /dev/null
  echo -e "\a\033[33;42;1m ! \033[0;1m \c"
  echo -e "\b \b "$(eval_ngettext "Your \$CONTAINER_FMT_NAME file has been moved to \$DESTINATION_DIR" "Your \$CONTAINER_FMT_NAME files have been moved to \$DESTINATION_DIR" $PARTS_NUM)"\033[0m" | fmt -t -w $(tput cols)

else
  mv --backup=t -f "$OLD_NAME"* psnr* "$WORKING_DIR" &> /dev/null
  echo -e "\a\033[33;42;1m ! \033[0;1m \c"
  echo -e "\b \b "$(eval_ngettext "There wasn't enough available disk space on the partition where your destination directory is, so your \$CONTAINER_FMT_NAME file has been moved to \$WORKING_DIR" "There wasn't enough available disk space on the partition where your destination directory is, so your \$CONTAINER_FMT_NAME files have been moved to \$WORKING_DIR")"\033[0m" | fmt -t -w $(tput cols)
fi

echo
echo -e "\033[1m\nkbit/s\npixels\nbit/pixel\nquantizer\noverhead\033[0m" | pr -T --columns 6

for PART in $( seq 1 $PARTS_NUM ); do
  echo -e "\033[1m$PART[$PARTS_NUM]\n\033[0m${VIDEO_BITRATE[$PART]} \n$(echo ${SCALE[$PART]} | sed "s/:/*/")\n${BPP[$PART]}\n${QUANT_MEAN[$PART]}${QUANT_STDEV[$PART]}\n${OVERHEAD[$PART]}" | pr -T --columns 6
done
}


HaltTheSystem () {

if [ -n "$HALT" ]; then
  exec 4>&1
  exec > "$DESTINATION_DIR"/"$OLD_NAME"\ [$VIDEO_ENC_NAME\ -\ "${AUDIO_ENC[*]}"\ -\ "${AUDIO_LANG_ALPHA3[*]}""$FILENAME_SPACE""${SUB_LANG_alpha3[*]}"].log

  echo -e $(gettext "Beginning")"\n$START_TIME"  | pr -T --columns 4
  echo -e $(gettext "End")"\n$END_TIME"  | pr -T --columns 4
  echo
  echo -e "\nkbit/s\npixels\nbit/pixel\nquantizer\noverhead" | pr -T --columns 6

  for PART in $( seq 1 $PARTS_NUM ); do
    echo -e "$PART[$PARTS_NUM]\n${VIDEO_BITRATE[$PART]}\n$(echo ${SCALE[$PART]} | sed "s/:/*/")\n${BPP[$PART]}\n${QUANT_MEAN[$PART]}${QUANT_STDEV[$PART]}\n${OVERHEAD[$PART]}" | pr -T --columns 6
  done

  exec 1>&4 4>&-

  $HALT
fi
}


#-------3b) Functions call

START_TIME=$( date "+%X" )
echo -e "\n\n\033[37;46;1m $START_TIME - "$(gettext "Beginning")" \033[0m"

trap 'rm -f check_* index dummy_srt *.srt sub_* pcm_* audio_* video_* divx2pass.log xvid-twopass.stats; rmdir -p "$WORKING_DIR/andrew_tmp/$PROJECT_ID" &> /dev/null' EXIT

PROJECT_ID=1

while [ -d "$WORKING_DIR/andrew_tmp/$PROJECT_ID" ]; do
  PROJECT_ID=$(( PROJECT_ID+1 ))
done

mkdir -p "$WORKING_DIR/andrew_tmp/$PROJECT_ID"
cd "$WORKING_DIR/andrew_tmp/$PROJECT_ID"

PreEncoding

for PART in $( seq 1 $PARTS_NUM ); do

  if [ "$PARTS_NUM" != 1 ]; then
    echo -e "\n\n\n\033[37;46;1m "$(gettext "Part")" $PART \033[0m"
    NAME="$OLD_NAME - $PART[$PARTS_NUM]"
  fi
  
  ChapterIndexSplitter
  SubtitleRipper
  AudioEncoder
  VideoBitrateCalculi
  ScaleCalculi
  VideoEncoder 1
  QuantizerCalculi
  ResolutionOptimiser
  VideoEncoder 2
  TrackMerger
  JustStats
done

PostEncoding

END_TIME=$( date "+%X" )
echo -e "\n\n\n\033[37;46;1m $END_TIME - "$(gettext "End")" \033[0m\n"

HaltTheSystem
exit $E_SUCCESS
