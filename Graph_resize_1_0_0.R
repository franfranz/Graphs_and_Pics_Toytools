####                                                   
#            Graphresize                                          
###                                  
#   ####     Adapt baseR graphs to different print formats           
#   #          
    ###      v 1.0.0
    #              
    #        https://github.com/franfranz/Graphs_and_pics_toytools                                


#   print/resize/change resolution to base R graphs 
#
#   the code for plotting graphs may be input here or in another file and needs to be saved as an <Active binding> 
#   

# INPUT REQUIRED: graphs code
# in your analysis file, save the code to generate each graph using pryr::%<a-%{} 
library(pryr)

# example:
mygraph1 %<a-% {
  hist(rnorm(1000,10,2), breaks=20)
}
mygraph2 %<a-% {
  plot(runif(1000, 50, 400), col="black")
  points(runif(1000, 100, 200), col="green")
}
mygraph3 %<a-% {
  plot(density(rpois(1000,3)), lwd=2, col="purple")
}

# and generate a vector collecting the name of the graphs to plot
complete_graphlist=ls()[grep(("mygraph"), ls())]

# choose the plots you would like to print/save
graphlist=complete_graphlist[c(1,3)]


# INPUT REQUIRED: paths
# 

# this is the folder to save graphics to
graphwd= "PATH"

# set directory 
setwd(graphwd)


# INPUT REQUIRED: choose graphical settings:
#
# size of output images: uncoment your preferred 

imagesize= "small" # gset1, for small, low-quality portable images
#imagesize= "medium" # gset2, average 
#imagesize= "big" # gset3 is high-res raster image (for poster printing)

g_type="cairo" 
g_units="px" 

# gset 1 
g1_width=600 
g1_height=600 
g1_pointsize=12 
g1_res=100
rescom1=png
resext_1=".png"

# gset 2 
g2_width=1200 
g2_height=1200 
g2_pointsize=12 
g2_res=200
rescom2=jpeg
resext_2=".jpeg"

# gset 3 
g3_width=2400 
g3_height=2400 
g3_pointsize=10 
g3_res=800
rescom3=tiff
resext_3=".tiff"

if (imagesize=="small"){
  g_width=  g1_width
  g_height= g1_height 
  g_pointsize= g1_pointsize 
  g_res= g1_res
  rescom=rescom1
  resext=resext_1
}else if (imagesize=="medium") {
  g_width=  g2_width
  g_height= g2_height 
  g_pointsize= g2_pointsize 
  g_res= g2_res
  rescom=rescom2
  resext=resext_2
} else {
  g_width=  g3_width
  g_height= g3_height 
  g_pointsize= g3_pointsize 
  g_res= g3_res
  rescom=rescom3
  resext=resext_3
}  

# save all graphs as images
for (eachgraph in graphlist) {
  thename=as.character(eachgraph)
  thefilename=paste0(thename, resext_1)
  rescom(filename=thefilename, 
         type=g_type, 
         units=g_units, 
         width=g_width, 
         height=g_height, 
         pointsize=g_pointsize, 
         res=g_res
  )
  eval(str2lang(eachgraph))
  dev.off()
}

# save one of the graphs: "mygraph2"
  # thename="mygraph2"
  # thefilename=paste0(thename, resext_1)
  # rescom(filename=thefilename, 
  #        type=g_type, 
  #        units=g_units, 
  #        width=g_width, 
  #        height=g_height, 
  #        pointsize=g_pointsize, 
  #        res=g_res
  # )
  # mygraph2
  # dev.off()
  # 


