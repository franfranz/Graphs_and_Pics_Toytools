####                                                 
#                                                     
###         Faux                        
#                Anaglyph                         
# ####                     Text
  #                                       
  ###        https://github.com/franfranz/Graphs_and_Pics_Toytools
  #         
  #        

# code to draw text resembilng anaglyph images 
# using the package Magick


library(magick)

#
#   SET INPUTS
#

# input your text
txt_title="MY FAUX \n ANAGLYPH \n     TEXT"

# choose font
txt_font="Impact"


# create or import background image
bg_pic1 = image_blank(width = 600, height= 600, color = "transparent")


#
#   SOME SETTINGS
#

# choose text weight - 400 is normal, 700 is bold
# (won't affect most fonts actually) 
txt_weight=400

# text inclination - 0 for horizontal 
txt_deg= 350

# size of text is adjusted to the width of image. 
# choose the proportion of text/background
txt_prop=0.15

# choose the horizontal start point of the text
# this will be related to image width 
txt_start_w=1/5 

# choose the vertical start point of the text
# this will be related to image height 
txt_start_h=1/5 


#
#   Default text parameters
#

# get width and height
imstats=as.data.frame(image_info(bg_pic1))
ima_width=imstats$width
ima_height=imstats$height

txt_size0= txt_prop*ima_width

# this parameter rules the size and space shift between the text layers
# higher values give some more "depth" - too high values make text a bit confused, though
txt_shiftprop=0.03

txt_sizediff= floor(txt_size0*txt_shiftprop)
txt_size1=txt_size0+ txt_sizediff
txt_size2=txt_size0- txt_sizediff

#textkern2=-(floor(txt_size0*0.02))

startx0= floor(ima_width*txt_start_w)
starty0= floor(ima_height*txt_start_h)

startdiff1=floor((txt_sizediff/2))
startx1= startx0 + startdiff1
starty1= starty0 + startdiff1

startdiff2=(txt_sizediff+1)
startx2= startx0 + startdiff2
starty2= starty0 + startdiff2


wheretitle=paste("+",startx0,"+",starty0, sep="")
wheretitle2=paste("+",startx1,"+",starty1, sep="")
wheretitle3=paste("+",startx2,"+",starty2, sep="")


#
#   Text generation
#

# white layer to have colors stand out frombackground
# a color may be added to the "boxcolor" parameter for a pop touch
bg_pic1box=image_annotate(bg_pic1, text= txt_title, 
                          size = txt_size0+(txt_size0*0.05), 
                          color = "#FFFFFF",
                          #strokecolor = "#FF339990",
                          boxcolor = "transparent",
                          weight = txt_weight,
                          degrees = txt_deg,
                          location = wheretitle,
                          font= txt_font
)

# first magenta layer
bg_pic2=image_annotate(bg_pic1box, text= txt_title, 
                       size = txt_size0, 
                       color = "#FF339990",
                       weight = txt_weight,
                       degrees = txt_deg,
                       location = wheretitle,
                       font= txt_font
)

# first cyan layer
bg_pic3=image_annotate(bg_pic2, text= txt_title, 
                       size = txt_size1, 
                       color = "#7FFFD480",
                       weight = txt_weight,
                       degrees = txt_deg,
                       location = wheretitle2,
                       font= txt_font
)

# semitransparent (.8) magenta overlay
bg_pic2L2=image_annotate(bg_pic3, text= txt_title, 
                         size = txt_size0, 
                         color = "#FF339980",
                         weight = txt_weight,
                         degrees = txt_deg,
                         location = wheretitle,
                         font= txt_font
)


# semitransparent (.8) cyan overlay
bg_pic3L3=image_annotate(bg_pic2L2, text= txt_title, 
                         size = txt_size1, 
                         color = "#7FFFD480",
                         weight = txt_weight,
                         degrees = txt_deg,
                         location = wheretitle2,
                         font= txt_font
)


# semitransparent (.9) white layer
bg_pic4=image_annotate(bg_pic3L3, text= txt_title, 
                       size = txt_size2, 
                       color = "#FFFFFF90",
                       weight = txt_weight,
                       degrees = txt_deg,
                       location = wheretitle2,
                       font= txt_font
) 

# semitransparent (.5) final white layer, shifted position
bg_pic5=image_annotate(bg_pic4, text= txt_title, 
                       size = txt_size0, 
                       color = "#FFFFFF50",
                       weight = txt_weight,
                       degrees = txt_deg,
                       location = wheretitle3,
                       font= txt_font
) 


#
#   OUTPUT
#

# preview
bg_pic5

# paste your Faux Anaglyph text where you like using magick functions as "image_composite", "image_append"

# or write a file with your image 
your_file_id= "My_text"
image_write(bg_pic5, path = paste0(your_file_id, "_Faux_Anaglyph.png", sep=""), format = "png")
