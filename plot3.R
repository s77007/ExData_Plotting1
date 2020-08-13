# load required libraries
library(lubridate)
library(dplyr)

#set working directory
setwd("C:/Rsamples/C4- Exploreratary analysis")

# reading table with header, seperator using na.string and default classes
powerin <- read.table ("./data/household_power_consumption.txt",
                       header = T, 
                       sep = ";",
                       na.strings = "?",
                       colClasses = c("character","character","numeric", "numeric","numeric","numeric","numeric","numeric","numeric")
)

# filtering data by converting date and filtering all other data apart from two dates
powerin <- filter(powerin, 
                  as.Date(Date, format= "%d/%m/%Y") >=  "2007-02-01" & 
                    as.Date(Date,format= "%d/%m/%Y") <=  "2007-02-02"
)   

# use mutate to add new columns etc
# created new date based on existing date
powerin <- mutate(powerin, newDate = as.Date(Date, format= "%d/%m/%Y") )
# created new time using lubridate function
powerin <- mutate(powerin, newTime = hms(Time ))
# concatenated date and time and converted to posixct time format
powerin <- mutate(powerin, newDateTime = as.POSIXct(strptime(paste(powerin$newDate, powerin$Time),
                                                             format = "%Y-%m-%d %H:%M:%S"
)
)
)


# rename column names
colnames(powerin) <- c("Date","Time","globalactivepower","globalreactivepower","voltage", "globalintensity","submet1","submet2","submet3","NewDate","NewTime","NewDateTime")

## Selected required columns and dropped string date and time.
powerin <- select(powerin, globalactivepower:NewDateTime)

# setting filename, size and units
png(file = "./ExData_Plotting1/plot3.png", width = 480, height = 480, units = "px")

# plot3
# setting plot without printing by setting type
plot(powerin$submet1,powerin$NewDateTime, type = "n" )
# Base plot with submetering 1 
plot(powerin$submet1~powerin$NewDateTime,
     powerin, 
     pch  = ".",  
     type = "o", 
     lwd  = 0, 
     xlab = "" ,
     ylab = "Energy Submetering"    
)

# Adding Points to existing chart for submetering 2 
points(powerin$submet2~powerin$NewDateTime,
       powerin, 
       pch  = ".",  
       type = "o", 
       lwd  =0, 
       xlab = "",
       ylab = "", 
       col  ="red"
)


# Adding Points to existing chart for submetering 3
points(powerin$submet3~powerin$NewDateTime,
       powerin, 
       pch  = ".",  
       type = "o", 
       lwd  = 0, 
       xlab = "",
       ylab = "", 
       col  = "blue")

# Adding Legend with a line with width 2 and captions for legend
legend("topright", 
       lwd = 2, 
       col = c("black", "blue", "red"), 
       legend = c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3")
)


dev.off()  # Close the png file device

