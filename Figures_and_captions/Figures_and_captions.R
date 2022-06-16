# as used to prepare figures for Clip Clap paper

library(magick)
library(readr)

# where the info about images are collected
wd_info = "contextual_emecomm\\clipclap\\short_for_EMNLP\\figures"

# where the folders of images sets are collectes
wd_sets = "contextual_emecomm\\clipclap\\image set\\image-sets\\"

# where the figures are output (couples)
wd_out1 = "contextual_emecomm\\clipclap\\short_for_EMNLP\\figures\\couples"

# where the figures are output (series)
wd_out2 = "contextual_emecomm\\clipclap\\short_for_EMNLP\\figures\\series"

inputfile_couples = "temporary_figure_candidates.txt"
#
#   set graphical inputs
#

# file extension of the output
myfile_ext = ".jpg"

#
# pictures
#

# background
#bg_pic1 = image_blank(width = 800, height= 400, color = "transparent")
bg_pic1 = image_blank(width = 800, height= 400, color = "#DCDCDC")

bg_imstats = as.data.frame(image_info(bg_pic1))
bg_width = bg_imstats$width
bg_height = bg_imstats$height

# border
bordersize = 4
bordersquare = paste0(bordersize, "x", bordersize)
target_bordercol = "#00FF00"
distractor_bordercol = "transparent"

#
# spacing, insets
#

# offset 
myoffset_ima= 0.015

# spacing: horizontal
myhori_prop = 0.01

# spacing: vertical
myver_prop = 0.02

# spacing: captions
spacecap_prop = 0.8


#
# text captions
#

txt_size = 16
txt_color = "black"
bck_color = "white"
txt_font_neu = "mono"
txt_font_hum = "times"
txt_weight = 90

neuraltag = NULL
humantag = NULL


# import file with info 
setwd(wd_info)
infofile = as.data.frame(read_delim(inputfile_couples))

# only keep info for selected examples
num_examples = 10
sel_infofile = head(infofile, num_examples)

# choose random index of close distractor frame to compare
set.seed(147)

before_or_after= sample (c(1, -1), num_examples, T)
sel_infofile$distractor_frame = sel_infofile$target_num + before_or_after

# change 10s and -1s 
sel_infofile$distractor_frame = gsub(10, 8, sel_infofile$distractor_frame)
sel_infofile$distractor_frame = gsub(-1, 1, sel_infofile$distractor_frame)
sel_infofile$distractor_frame= as.integer(sel_infofile$distractor_frame)


for (i in c(1:length(sel_infofile$dirpath))){
  thepath = sel_infofile$dirpath
  used_set = paste0(wd_sets, thepath)
  print (used_set)
  setwd (used_set[i])
  image_names = dir()[grep(".jpg$", dir())]
  print (image_names)
  thefilename = paste0("example_couple_", i, myfile_ext)
  thetarget_i = sel_infofile$target_num[i]
  thedistractor_i = sel_infofile$distractor_frame[i]
    if (thetarget_i < thedistractor_i) {
      pic1 = image_names[thetarget_i]
      pic2 = image_names[thedistractor_i]
      print ("pic1 is target")
      target_is = "pic1"
    } else if (thetarget_i > thedistractor_i){
      pic1 = image_names[thedistractor_i]
      pic2 = image_names[thetarget_i]
      print("pic1 is not target")
      target_is = "pic2"
    }
  
  txt_caption1_raw = sel_infofile$neur_capt[i]
  txt_caption1_wrapped = strwrap(txt_caption1_raw, 50)
  caprows_cap1 = length(txt_caption1_wrapped)
  txt_caption1 = paste(strwrap(txt_caption1_raw, 50), collapse = " \n ")
  
  txt_caption2_raw = sel_infofile$hum_capt[i]
  txt_caption2_wrapped = strwrap(txt_caption2_raw, 80)
  caprows_cap2 = length(txt_caption2_wrapped)
  txt_caption2 = paste(strwrap(txt_caption2_raw, 80), collapse = " \n ")
  
  #}

# pictures
raw_pic1 = image_read(pic1)
resc_pic1 = image_resize(raw_pic1, 320)
resc_pic1 = image_resize(raw_pic1, 240)

raw_pic2 = image_read(pic2)
resc_pic2 = image_resize(raw_pic2, 320)
resc_pic2 = image_resize(raw_pic2, 240)


# add green border to target
if(target_is == "pic1"){
import_pic1 = image_border(resc_pic1, target_bordercol, bordersquare)
import_pic2 = image_border(resc_pic2, distractor_bordercol, bordersquare)
} else if (target_is == "pic2") {
  import_pic1 = image_border(resc_pic1, distractor_bordercol, bordersquare)
  import_pic2 = image_border(resc_pic2, target_bordercol, bordersquare)
}

pic1_stats = as.data.frame(image_info(import_pic1))
pic1_width = pic1_stats$width
pic1_height = pic1_stats$height



pic2_stats = as.data.frame(image_info(import_pic2))
pic2_width = pic2_stats$width
pic2_height = pic2_stats$height


# offset 
myinset_hori = floor(bg_width*myoffset_ima)
myinset_vert = floor(bg_width*myoffset_ima)

# spacing: horizontal
myhori_space = floor(bg_width*myhori_prop)

# spacing: vertical
myver_spacefig = floor(bg_height*myver_prop)
myver_spacecap = floor(myhori_space*spacecap_prop)

# position fig1
myoffset_fig1_hori=myinset_hori
myoffset_fig1_vert=myinset_hori

#position fig2
myoffset_fig2_hori = myinset_hori + pic1_width + myhori_space
myoffset_fig2_vert = myinset_vert 

# position: caption 1
myoffset_cap1_hori = myinset_hori
myoffset_cap1_vert = myinset_vert + pic1_height + myver_spacefig

# position: caption 2
myoffset_cap2_hori = myinset_hori
if (caprows_cap1 == 1){
myoffset_cap2_vert = myinset_vert + pic1_height + myver_spacefig + txt_size + myver_spacecap
} else if (caprows_cap1 == 2){
myoffset_cap2_vert = myinset_vert + pic1_height + myver_spacefig + txt_size*2 + myver_spacecap
} else if (caprows_cap1 == 3){
myoffset_cap2_vert = myinset_vert + pic1_height + myver_spacefig + txt_size*3 + myver_spacecap
}

# bind offset coordinates  
wherepic1 = paste0("+", myoffset_fig1_hori, "+", myoffset_fig1_vert)
wherepic2 = paste0("+", myoffset_fig2_hori, "+", myoffset_fig2_vert)
wherecaption1 = paste0("+", myoffset_cap1_hori, "+", myoffset_cap1_vert )
wherecaption2 = paste0("+", myoffset_cap2_hori, "+", myoffset_cap2_vert)


# layer figure 
ima1 = bg_pic1
ima2 = image_composite(ima1, import_pic1, offset = wherepic1)
ima3 = image_composite(ima2, import_pic2, offset = wherepic2)

# insert caption1 
ima4=image_annotate(ima3, 
                       text= paste(neuraltag, txt_caption1, " "),
                       size = txt_size, 
                       color = txt_color,
                       boxcolor = bck_color,
                       weight = txt_weight,
                     #  degrees = txt_deg,
                       location = wherecaption1,
                       font= txt_font_neu
) 

# insert caption1 
ima5=image_annotate(ima4, 
                       text= paste(humantag, txt_caption2, " "),
                       size = txt_size, 
                       color = txt_color,
                       boxcolor = bck_color,
                       weight = txt_weight,
                       #  degrees = txt_deg,
                       location = wherecaption2,
                       font= txt_font_hum
) 

# image size
piclimit_hori = myinset_hori + pic1_width + myhori_space + pic2_width + myinset_hori
piclimit_vert = myoffset_cap2_vert = myinset_vert + pic1_height + myver_spacefig + txt_size*4 + myver_spacecap*3  

cropsize = paste0(piclimit_hori, "x", piclimit_vert)

# cut 
ima6 = image_crop(ima5, cropsize )
ima6
# resize

ima7 = image_resize(ima6, piclimit_hori*0.75)

# bind

# print
setwd(wd_out1)
image_write(ima7, thefilename)
setwd(wd_sets)
}


#
#
#     SETS OF TEN
#
#

# where the info about images are collected
wd_info = "contextual_emecomm\\clipclap\\short_for_EMNLP\\figures"

# where the folders of images sets are collectes
wd_sets = "contextual_emecomm\\clipclap\\image set\\image-sets\\"

# where the figures are output (series)
wd_out2 = "contextual_emecomm\\clipclap\\short_for_EMNLP\\figures\\series"

inputfile_ser = "temporary_figure_candidates.txt"


# file extension of the output
myfile_ext_ser = ".jpg"

#
# text captions
#

txt_size_ser = 16
txt_color_ser = "black"
bck_color_ser = "white"
txt_font_neu_ser = "mono"
txt_font_hum_ser = "times"
txt_weight_ser = 90

neuraltag_ser = NULL
humantag_ser = NULL


# number of frames per row
numframes_hori = 5

# number of frames per column
numframes_vert = 2

framesize_hori = 180

framesize_vert = 140


# border
bordersize = 4
bordersquare = paste0(bordersize, "x", bordersize)
target_bordercol = "#00FF00"
other_bordercol = "transparent"

# open file with info
setwd(wd_info)
infofile_series = as.data.frame(readr::read_delim(inputfile_ser))

# only keep info for selected examples
num_examples = 10

sel_infofile = head(infofile_series, num_examples)
background_width = (bordersize*8) + (framesize_hori * numframes_hori)
background_height_full = (bordersize*8) + (framesize_vert * numframes_vert) + 2*txt_size_ser + (bordersize*2)
background_height = (bordersize*8) + (framesize_vert * numframes_vert) 

back_image = magick::image_blank(width = background_width, height= background_height_full, color = "#DCDCDC")
back_image_1 = image_border(back_image, color = "#DCDCDC", bordersquare)

partsize_hori = floor(background_width/numframes_hori)
hori_coords=0
for (hori_part in c(1:(numframes_hori-1))){
hori_part_coord = partsize_hori*hori_part
hori_coords= c(hori_coords, hori_part_coord)    
} 

partsize_vert = floor(background_height/numframes_vert)
vert_coords=0
for (vert_part in c(1:(numframes_vert-1))){
  vert_part_coord = partsize_vert*vert_part
  vert_coords= c(vert_coords, vert_part_coord)    
} 

coordtable = NULL
coordtable$horicoords = rep(hori_coords, numframes_vert)
coordtable$vertcoords = rep(vert_coords, each = numframes_hori)
coordtable = as.data.frame(coordtable)

coordtable$coordpoints = paste0("+", coordtable$horicoords, "+", coordtable$vertcoords) 

#coordinates of caption
#caption1
hori_caption1_ser = (min(coordtable$horicoords)) + bordersize
vert_caption1_ser = (max(coordtable$vertcoords)) + framesize_vert + 2*bordersize 
wherecaption1_ser = paste0("+", hori_caption1_ser, "+", vert_caption1_ser)

  #caption2
hori_caption2_ser = (min(coordtable$horicoords)) + bordersize
vert_caption2_ser = vert_caption1_ser + txt_size_ser + bordersize*2
wherecaption2_ser = paste0("+", hori_caption2_ser, "+", vert_caption2_ser)

# get images
for (j in c(1:length(sel_infofile$dirpath))){
  thefilename_ser = paste0("series_example", j, myfile_ext_ser)
  thepath = sel_infofile$dirpath
  used_set = paste0(wd_sets, thepath)
  print (used_set)
  setwd (used_set[j])
  image_names = dir()[grep(".jpg$", dir())]
  print (image_names)
  thetarget_j = sel_infofile$target_num[j]
  thetarget_pic = image_names[thetarget_j]
  print(thetarget_j)
  txt_caption1 = sel_infofile$neur_capt[j]
  txt_caption2 = sel_infofile$hum_capt[j]
  coordtable$image_names= image_names
  
  ser_img1 = back_image_1
  
  for(k in c(1:length(coordtable$image_names))) {
    picture = coordtable$image_names
    mypic_raw = image_read(picture[k])
    resc_pic1 = image_resize(mypic_raw, framesize_hori)
    resc_pic2 = resc_pic1
    #resc_pic2 = image_resize(resc_pic1, framesize_vert)
    if (picture[k] == thetarget_pic) {
      mypic_border = image_border(resc_pic2, target_bordercol, bordersquare)
      mypic_border2 = image_border(mypic_border, other_bordercol, bordersquare)
    } else {
      mypic_border = image_border(resc_pic2, other_bordercol, bordersquare)
    mypic_border2 = image_border(mypic_border, other_bordercol, bordersquare)
    }
    ser_img1= magick::image_composite(ser_img1, mypic_border2, offset = coordtable$coordpoints[k])

    
  }
  # insert caption1 
  ser_img2=image_annotate(ser_img1, 
                          text= paste(neuraltag_ser, txt_caption1, " "),
                          size = txt_size_ser, 
                          color = txt_color_ser,
                          boxcolor = bck_color_ser,
                          weight = txt_weight_ser,
                          #  degrees = txt_deg,
                          location = wherecaption1_ser,
                          font= txt_font_neu_ser
  ) 

  # insert caption2
  ser_img3=image_annotate(ser_img2, 
                          text= paste(humantag_ser, txt_caption2, " "),
                          size = txt_size_ser, 
                          color = txt_color_ser,
                          boxcolor = bck_color_ser,
                          weight = txt_weight_ser,
                          #  degrees = txt_deg,
                          location = wherecaption2_ser,
                          font= txt_font_hum_ser)
 
  setwd(wd_out2)
  image_write(ser_img3, thefilename_ser)

}


