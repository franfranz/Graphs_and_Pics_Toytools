####                                                 
#                                                     
###         P O S T E R   and   T H U M B N A I L                       
#                                           
# ####              G R A P H I C S  for  E V E N T S    
  #                                       
  ###        P T G E   -   v 1.1.1
  #         
  #        https://github.com/franfranz/Graphs_and_Pics_Toytools/new/main

# this code prepares thumbnails and/or posters for series of events
#
# cuts images in squares for 3x4 or 3x3 grids 
# draw a poster of the series 
# annotates with the name and logo of the organizers 
# and the names of speakers inserted manually or from a list


# required packages: imager, magick, tools 

# --
#
# USER ACTION REQUIRED: 
#

# 1) please input the name of the csv table containing names and titles
# the file must have the following columns: "Name", "Surname", "Full_title", "Titleline_1", "Titleline_2", "Titleline_3", "Series"
# 9 or 12 rows for 3x3 or 3x4 thumbnails
# a sample is provided in this repo

titlefiles="Conf_titles_1.csv"
csvsep=";" #type of separator in your csv file

# 2) #please input the filename of image to be used as background
bg_imagetitle="Haeckel_Lichenes.jpg" # Ernst Haeckel, Public domain, Wikimedia Commons, https://commons.wikimedia.org/wiki/File:Haeckel_Lichenes.jpg

# 3) #please input the filename of your logo 
logofigure="mylogo.png"

# input additional information about the organization 
address= "@theplace" #a website or address of the event
descr="A catchy \n description"
credits_to="Organized by \n Person One \n Person Two \n and Person Three"

# INPUT PATHS

# the INPUT directory must contain:
# the csv file with the information about the event (speaker, title, etc...)
# the image to be used 

# the MIDPROCESS directory will contain:
# half processed (cut) pictures, to annotate with text

# the OUTPUT directory will contain
# the grid of cut images (square)
# the poster of the series

# where your logo is stored
logowd=("path")

# set input wd - where the source images are stored
inwd_pic="path"

# where the conference titles are stores
inwd_titles="path"

# set midprocess wd 
midwd="path"

# set output wd - where the output images are saved. Change according to type, if needed
outwd="path"

# image equalization and color parameters
##
# a1) choose dominant color
colorbox="gray34"
# a2) choose transparency (0-100)
colortrasp=50
# b1) choose color of the text
textcol="darkorange"
# b2) choose a second color for the text
textcol_b="white"
# c) choose brightness level (0-100)
pic_bri= 50
# d) choose saturation level (0-100)
pic_sat= 20
# e) choose hue (0-100)
pic_hue= 80

#
# raster cut parameters
## size
# f_cut) proportionally scale logo
logoscale_cut=0.5
# g_cut) text_scale (occupancy of text in picturewidth)
textscale1_cut=0.11
# h_cut) title scale (size of larger text sections such as titles: proportion relative to textscale_1)
textscale2_cut=0.11
# i1_cut) textweight (500 is regular - fixed parameter in magick)
t_weight1=500
# i2_cut) titleweight (700 and above are bold - fixed parameter in magick)
t_weight2=t_weight1+(0.5*t_weight1)
# j1_cut) text kerning (according to text size - text1)

textkern1_cut=  0.08
# j2_cut) text kerning (according to text size - text2)
textkern2_cut=  0.08
## positioning
# k_cut) logo position 
logoposit_cut="southwest"
# l_cut) text 1 position (relative to pic)
textgrav1_cut="east"
# m_cut) text 2 position (relative to pic)
textgrav2_cut="northeast"
# n1x_cut) text 1 position (relative to anchor textgrav)
text1_relpos_x=0.98
# n1y_cut)  text 1 position (relative to anchor textgrav) 
text1_relpos_y=0.92
# o1x_cut
text2_relpos_x=0.98
# o1y_cut
text2_relpos_y=0.92
# multiplier of line spacing, text 1
text1_spacing=1.1
# multiplier of line spacing, text 2
text2_spacing=1.2  


#
## poster parameters
# f_pos) 
logoscale_pos=0.6
# g_pos) text_scale (occupancy of text in picturewidth)
textscale1_pos=0.2
# h_pos) title scale (size of titles compared to text)
textscale2_pos=0.15

# i1_cut) textweight (500 is regular - fixed parameter in magick)
t_weight1_pos=500
# i2_cut) titleweight (700 and above are bold - fixed parameter in magick)
t_weight2_pos=t_weight1+(0.5*t_weight1)
# j1_cut) text kerning (according to text size - text1)
textkern1_pos= 0.08 
# j2_cut) text kerning (according to text size - text2)
textkern2_pos= 0.08 
## positioning
# k_cut) logo position 
logoposit_pos="southwest"
# l_cut) text 1 position (relative to pic)
textgrav1_pos="east"
# m_cut) text 2 position (relative to pic)
textgrav2_pos="northeast"
# n1x_cut) text 1 position (relative to anchor textgrav)
text1_relpos_x_pos=0.98
# n1y_cut)  text 1 position (relative to anchor textgrav) 
text1_relpos_y_pos=0.92
# o1x_cut
text2_relpos_x_pos=0.98
# o1y_cut
text2_relpos_y_pos=0.92
# multiplier of line spacing, text 1
text1_spacing_pos=1.1
# multiplier of line spacing, text 2
text2_spacing_pos=1.2  

pos_width ="1200" #the width of the poster, in px

#   proceed with image preparation
#   
# 

library(magick)
library(imager)

# input your organization logo
setwd(logowd)
mylogo=image_read(logofigure)
seclogo=mylogo

# import file with names
setwd(inwd_titles)
conftitles= read.csv(titlefiles, sep=csvsep, header = T)

if(nrow(conftitles==12)){
  typeimg="4x3"   
} else if (nrow(conftitles==9)){
  typeimg="3x3"    
} else{
  print("none")
}

# input figure
setwd(inwd_pic)
background=load.image(bg_imagetitle) # %>% plot
thename=tools::file_path_sans_ext(bg_imagetitle)
# else, input a name you like for the final set of images
# thename=""


#
#     C U T 
#
#

#
# Measure, cut, resize image
#

dim(background)
#dim(seclogo)

backg_width= width(background)
backg_height= height(background)

#width will be cut in 3 
wideas=backg_width%/% 3
wideas2= wideas*3
backg_width==wideas2

cutwidth=backg_width-wideas2

if (typeimg=="3x3"){
  cutheight=(backg_height-( wideas*3))
} else if (typeimg=="4x3"){
  cutheight=(backg_height-( wideas*4))
} else { 
  print ("error")
}

#backg_height>=cutheight

# a temporary file to modify
temp=background

# cut lower side, right side
temp= imsub(temp,x < (backg_width - cutwidth), y < (backg_height - cutheight)) 

#plot(temp)
#dim(temp)

# cut upper side, left side
temp= imsub(temp,x > cutwidth,y > cutheight)
dim(temp)
dim(background)

# else, cut unintended borders by manually selecting the number of pixels to be cut: 
#hi_side=
#lo_side=
#sx_side=
#dx_side=


# 
#  Slice and save slices as images
#
setwd(midwd)
imaname_vec=NULL
imafilelist=NULL
if  (typeimg=="3x3"){
  for (i in c(1:9)){
    imaname=paste("ima", i, sep="")
    imaname_vec=c(imaname, imaname_vec)
  }
  hori_cut1=wideas
  hori_cut2=((wideas*2)+1)
  vert_cut1=hori_cut1
  vert_cut2=((hori_cut1*2)+1)
  
  for (imas in imaname_vec)  {
    if (imas=="ima1"){
      #first horizontal row
      ima=imsub(temp,x < hori_cut1, y < vert_cut1)
    } else if (imas=="ima2"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), y < vert_cut1)
    } else if (imas=="ima3"){
      ima=imsub(temp,(x > hori_cut2), y < vert_cut1)
      #second horizontal row
    } else if (imas=="ima4"){
      ima=imsub(temp,x < hori_cut1, (y > vert_cut1 & y < vert_cut2))
    } else if (imas=="ima5"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), (y > vert_cut1 & y < vert_cut2))
    } else if (imas=="ima6"){
      ima=imsub(temp,(x > hori_cut2), (y > vert_cut1 & y < vert_cut2))
      #third horizontal row
    } else if (imas=="ima7"){
      ima=imsub(temp,x < hori_cut1, (y > vert_cut2))
    } else if (imas=="ima8"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), (y > vert_cut2))
    } else if (imas=="ima9"){
      ima=imsub(temp,(x > hori_cut2), (y > vert_cut2))
    }
    save.image(ima, paste(imas, thename, ".jpeg", sep=""), quality = 1)
  }
}else if(typeimg=="4x3") {
  
  for (i in c(1:12)){
    imaname=paste("ima", i, sep="")
    imaname_vec=c(imaname, imaname_vec)
  }
  
  hori_cut1=wideas
  hori_cut2=((wideas*2)+1)
  vert_cut1=hori_cut1
  vert_cut2=((hori_cut1*2)+1)
  vert_cut3=((hori_cut1*3)+1)
  
  for (imas in imaname_vec)   {
    if (imas=="ima1"){
      #first horizontal row
      ima=imsub(temp,x < hori_cut1, y < vert_cut1)
    } else if (imas=="ima2"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), y < vert_cut1)
    } else if (imas=="ima3"){
      ima=imsub(temp,(x > hori_cut2), y < vert_cut1)
      #second horizontal row
    } else if (imas=="ima4"){
      ima=imsub(temp,x < hori_cut1, (y > vert_cut1 & y < vert_cut2))
    } else if (imas=="ima5"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), (y > vert_cut1 & y < vert_cut2))
    } else if (imas=="ima6"){
      ima=imsub(temp,(x > hori_cut2), (y > vert_cut1 & y < vert_cut2))
      #third horizontal row
    } else if (imas=="ima7"){
      ima=imsub(temp,x < hori_cut1, (y > vert_cut2 & y < vert_cut3))
    } else if (imas=="ima8"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), (y > vert_cut2 & y < vert_cut3))
    } else if (imas=="ima9"){
      ima=imsub(temp,(x > hori_cut2), (y > vert_cut2 & y < vert_cut3))
      #fourth horizontal row
    } else if (imas=="ima10"){
      ima=imsub(temp,x < hori_cut1, (y > vert_cut3))
    } else if (imas=="ima11"){
      ima=imsub(temp,(x > hori_cut1 & x < hori_cut2), (y > vert_cut3))
    } else if (imas=="ima12"){
      ima=imsub(temp,(x > hori_cut2), (y > vert_cut3))
    }
    imafilename=paste(imas,thename, ".jpeg", sep="")
    save.image(ima, imafilename, quality = 1  )
    imafilelist=c(imafilelist, imafilename)
  }
} else {print("error")
}

# slices are numbered from top left - last is 9 (3x3) or 12 (3x4)
conftitles$Image=imafilelist


#
#     C O L O R 
#            A N D  
#               T E X T


for (i in c(1:nrow(conftitles))){
  thespeaker=conftitles$Surname[i]
  speakersname=conftitles$Name[i]
  thetitle_ori=conftitles$Full_title[i]
  titleline_1=conftitles$Titleline_1[i]
  titleline_2=conftitles$Titleline_2[i]
  titleline_3=conftitles$Titleline_3[i]
  print (c((conftitles$Name[i]),(conftitles$Surname[i])), sep=" ")
  setwd(midwd)
  bg_pic_name= (conftitles$Image[i])
  
  # import pic
  bg_pic=  image_read(bg_pic_name)
  # get attributes
  info_df=as.data.frame(image_info(bg_pic))
  pic_width=info_df$width
  pic_height=info_df$height
  
  # rescale elements to be overlaid 
  # rescale logo according to pic size: 1/5 
  logosize=pic_width*logoscale_cut
  logo_resc=image_resize(seclogo, geometry_size_pixels(width = logosize))
  # rescale text size according to pic size: 1/15
  textsize1=ceiling(pic_width*textscale1_cut)
  textsize2=ceiling(textsize1+(textsize1*textscale2_cut))
  
  # process pic 
  # reduce saturation
  bg_pic1= image_modulate(bg_pic, brightness = pic_bri, saturation = pic_sat, hue = pic_hue) 
  # reduce contrast
  #
  # overlay logo
  bg_pic2=image_composite(bg_pic1, logo_resc, 
                          gravity=logoposit_cut,
                          "Minus"
  )
  
  # overlay semitransparent color
  bg_pic1 = image_colorize(bg_pic2, colortrasp, colorbox)
  #
  # overlay name and title
  #
  
  # SPEAKER'S NAME (text1)
  # set position: name
  wherename_x=ceiling(pic_width-(pic_width*text1_relpos_x))
  wherename_y=ceiling(pic_height-(pic_height*text1_relpos_y))
  wherename=paste("+",wherename_x,"+",wherename_y, sep="")
  # set kerning
  textkern1=-(floor(textsize1*textkern1_cut))
  textkern2=-(floor(textsize2*textkern2_cut))
  
  # superimpose name
  bg_pic1=image_annotate(bg_pic1, text= speakersname, 
                         size = textsize1, 
                         color = textcol,
                         weight = t_weight1, 
                         kerning = textkern1,
                         
                         gravity = textgrav1_cut,
                         location = wherename
  )
  # set position: surname
  #wheresurname_x=ceiling(wherename_x+(1.1*wherename_x))
  wheresurname_x=wherename_x
  wheresurname_y=ceiling(wherename_y+(text1_spacing*wherename_y))
  wheresurname=paste("+",wheresurname_x,"+",wheresurname_y, sep="")
  # superimpose surname
  bg_pic1=image_annotate(bg_pic1, text= thespeaker,
                         size = textsize1, 
                         color = textcol,
                         weight = t_weight1, 
                         kerning = textkern1,
                         
                         gravity = textgrav1_cut,
                         location = wheresurname
  )
  # TITLE (text2)
  # set position: title
  # title line 1
  #wheretitle1_x=ceiling(pic_width-(pic_width*0.98))
  wheretitle1_x=wherename_x
  wheretitle1_y=ceiling(pic_height-(pic_height*text2_relpos_y))
  wheretitle1=paste("+", wheretitle1_x,"+",wheretitle1_y, sep="")
  # superimpose title
  bg_pic1=image_annotate(bg_pic1, text= titleline_1, 
                         size = textsize2, 
                         color = textcol,
                         weight = t_weight2,
                         kerning = textkern2,
                         gravity = textgrav2_cut,
                         location = wheretitle1
  )
  
  # title line 2
  #wheretitle2_x=ceiling(wheretitle1_x+(0.9*wheretitle1_x))
  wheretitle2_x=wherename_x
  wheretitle2_y=ceiling(wheretitle1_y+(text2_spacing*wheretitle1_y))
  wheretitle2=paste("+",wheretitle2_x,"+",wheretitle2_y, sep="")
  # superimpose title
  bg_pic1=image_annotate(bg_pic1, text= titleline_2, 
                         size = textsize2, 
                         color = textcol,
                         weight = t_weight2,
                         kerning = textkern2,
                         gravity = textgrav2_cut,
                         location = wheretitle2
  )
  
  # title line 3
  #wheretitle3_x=ceiling(wheretitle2_x+(0.9*wheretitle2_x))
  wheretitle3_x=wherename_x
  wheretitle3_y=ceiling(wheretitle2_y+(text2_spacing*wheretitle1_y))
  wheretitle3=paste("+",wheretitle3_x,"+",wheretitle3_y, sep="")
  # superimpose title
  bg_pic1=image_annotate(bg_pic1, text= titleline_3, 
                         size = textsize2, 
                         color = textcol,
                         weight = t_weight2,
                         kerning = textkern2,
                         gravity = textgrav2_cut,
                         location = wheretitle3
  )
  
  # see result
  print(bg_pic1)
  # save image
  setwd(outwd)
  image_write(bg_pic1, path = paste(thespeaker, "_", i, ".jpeg", sep=""), format = "jpeg")
}



#
#
#     P O S T E R
#  
#

poster_bg=cimg2magick(temp, rotate = TRUE)
poster_bg = image_scale(poster_bg, pos_width)
poster_bg = image_colorize(poster_bg, colortrasp, colorbox)

info_df_pos=as.data.frame(image_info(poster_bg))
pic_width_pos=info_df_pos$width
pic_height_pos=info_df_pos$height

# rescale elements to be overlaid 
# rescale logo according to pic size 
logosize_pos=pic_width_pos*logoscale_pos
logo_resc_pos=image_resize(seclogo, geometry_size_pixels(width = logosize_pos))
# rescale text size according to pic size: 1/15
textsize1_pos=ceiling(pic_width*textscale1_pos)
textsize2_pos=ceiling(textsize1+(textsize1*textscale2_pos))


# overlay logo
poster_bg1=image_composite(poster_bg, logo_resc_pos, 
                           gravity=logoposit_pos,
                           "Minus"
)

wherename_x_pos=ceiling(pic_width-(pic_width*text1_relpos_x))
wherename_y=ceiling(pic_height-(pic_height*text1_relpos_y))
wherename=paste("+",wherename_x,"+",wherename_y, sep="")
# set kerning
textkern1=-(floor(textsize1*textkern1_cut))
textkern2=-(floor(textsize2*textkern2_cut))

# superimpose text

# title
poster_bg1=image_annotate(poster_bg1, text= descr, 
                          size = textsize1, 
                          color = textcol,
                          weight = t_weight2_pos, 
                          kerning = textkern1,
                          
                          gravity = textgrav2_pos,
                          location = wheretitle1
)

# names
poster_bg1=image_annotate(poster_bg1, text= credits_to, 
                          size = textsize1, 
                          color = textcol,
                          weight = t_weight1_pos, 
                          kerning = textkern1,
                          
                          gravity = textgrav1_pos,
                          location = wherename
)

# address
poster_bg1=image_annotate(poster_bg1, text= address, 
                          size = 40, 
                          color = textcol_b,
                          weight = t_weight2_pos, 
                          kerning = 0,
                          
                          gravity = "southeast"
)
seriesnum=unique(conftitles$Seriesnum)
image_write(poster_bg1, path = paste("XX_poster_S_", seriesnum, ".jpeg", sep=""), format = "jpeg")
