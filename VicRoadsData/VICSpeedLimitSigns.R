# Install required packages (if not installed)
# install.packages(c("sf", "tmap", "foreign", "RColorBrewer"))

# Load required libraries
library(sf)
library(tmap)
library(foreign)
library(RColorBrewer)

# Read in shapefile
myshapefile <- st_read("~/Documents/UniSA/Personal-R/Spatial_Speed_Limits_Vic/Speed_Signs.shp")

# Read in DBF file
mydbf <- read.dbf("~/Documents/UniSA/Personal-R/Spatial_Speed_Limits_Vic/Speed_Signs.dbf")

# Merge shapefile and DBF file using the appropriate column name (e.g., "SIGN_ID")
mydata <- merge(myshapefile, mydbf, by.x = "SIGN_ID", by.y = "SIGN_ID")

# Remove duplicate columns
mydata <- mydata[, !grepl("\\.y$", colnames(mydata))]

# Rename columns with ".x" suffix
colnames(mydata) <- gsub("\\.x$", "", colnames(mydata))

# Set projection of mydata
mydata <- st_transform(mydata, "+proj=longlat +datum=WGS84")

# Create a factor variable for the SIGN_SPEED column
mydata$SIGN_SPEED_FACTOR <- as.factor(mydata$SIGN_SPEED)

# Check the summary of the SIGN_SPEED_FACTOR column
summary(mydata$SIGN_SPEED_FACTOR)

# Define a custom color palette
my_palette <- colorRampPalette(brewer.pal(9, "Set1"))(length(unique(mydata$SIGN_SPEED_FACTOR)))

# Create map with custom color palette
tm_shape(mydata) +
  tm_dots(col = "SIGN_SPEED_FACTOR", size = 0.1, palette = my_palette, title = "Speed Limit", auto.palette.mapping = FALSE)

