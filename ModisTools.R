#Install package
install.packages("MODISTools")
library (MODISTools)

#Format the data
modis.subset <- read.table("c:/Profiles/tbolivar/SOIL-R/Manuscripts/Mangroves/coordMODIS.txt",header=T,dec=".")
modis.subset <- read.table("~/SOIL-R/Manuscripts/Mangroves/coordMODIS.txt",header=T,dec=".")
modis.subset

names(modis.subset) 
is.numeric(modis.subset$lat)
is.numeric(modis.subset$long)

#Time-series of MODIS data
modis.subset$start.date <- rep(2011, nrow(modis.subset))
modis.subset$end.date <- rep(2013, nrow(modis.subset))

#Specifing a subset request
GetProducts()

#Listing available bands for MOD13Q1 product
GetBands(Product = "MOD13Q1")

#Checking the time-series of MODIS data we want is available for this data product
GetDates(Product = "MOD13Q1", Lat = modis.subset$lat[81], Long = modis.subset$long[81])

#Downloading information EVI
MODISSubsets(LoadDat = modis.subset, Products = "MOD13Q1", Bands = c("250m_16_days_EVI", "250m_16_days_pixel_reliability"), Size = c(1,1))
subset.string <- read.csv(list.files(pattern = ".asc")[1], header = FALSE, as.is = TRUE)
subset.string[1, ]

#Downloading information NDVI
MODISSubsets(LoadDat = modis.subset, Products = "MOD13Q1", Bands = c("250m_16_days_NDVI", "250m_16_days_pixel_reliability"), Size = c(1,1))
subset.string <- read.csv(list.files(pattern = ".asc")[1], header = FALSE, as.is = TRUE)
subset.string[1, ]

#Finding average each pixel over time, to produce one tile of mean EVI, NDVI and FPAR pixels at each subset location
MODISSummaries(LoadDat = modis.subset, Product = "MOD13Q1", Bands = "250m_16_days_EVI", ValidRange = c(-2000,10000), NoDataFill = -3000, ScaleFactor = 0.0001, QualityScreen = TRUE, QualityBand = "250m_16_days_pixel_reliability", QualityThreshold = 0)

MODISSummaries(LoadDat = modis.subset, Product = "MOD13Q1", Bands = "250m_16_days_NDVI", ValidRange = c(-2000,10000), NoDataFill = -3000, ScaleFactor = 0.0001, QualityScreen = TRUE, QualityBand = "250m_16_days_pixel_reliability", QualityThreshold = 0)

#Calculating EVI mean for each coordinate (mean of 81 pixels)
Mod1=read.csv("C:/Profiles/tbolivar/SOIL-R/Manuscripts/Mangroves/MODIS_Data_MOD13Q1_2015-06-18_h10-m2-s54.csv")
Mod1=read.csv("~/SOIL-R/Manuscripts/Mangroves/MODIS_Data_MOD13Q1_2015-06-18_h10-m2-s54.csv")

meanMod1=data.frame(Mod1[,1:2],meanEVI=apply(Mod1[,6:86],1,mean,na.rm=TRUE))
meanMod1

#Calculating NDVI mean for each coordinate (mean of 81 pixels)
Mod2=read.csv("C:/Profiles/tbolivar/SOIL-R/Manuscripts/Mangroves/MODIS_Data_MOD13Q1_2015-06-23_h12-m0-s60.csv")
Mod2=read.csv("~/SOIL-R/Manuscripts/Mangroves/MODIS_Data_MOD13Q1_2015-06-23_h12-m0-s60.csv")

meanMod2=data.frame(Mod1[,1:2],meanNDVI=apply(Mod1[,6:86],1,mean,na.rm=TRUE))
meanMod2

plotsDataset=cbind(plots,EVI=meanMod1[,3],NDVI=meanMod2[,3],dat)

plot(plotsDataset)

write.csv(plotsDataset,"~/SOIL-R/Manuscripts/Mangroves/plotsDataset.csv")
