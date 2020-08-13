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
powerin <- mutate(powerin, 
                  newDateTime = as.POSIXct(strptime(paste(powerin$newDate, powerin$Time),
                                                             format = "%Y-%m-%d %H:%M:%S"
                                          ))
                )


# rename column names
colnames(powerin) <- c("Date","Time","globalactivepower","globalreactivepower","voltage", "globalintensity","submet1","submet2","submet3","NewDate","NewTime","NewDateTime")

## Selected required columns and dropped string date and time.
powerin <- select(powerin, globalactivepower:NewDateTime)

# setting filename, size and units
png(file = "./ExData_Plotting1/plot4.png", width = 480, height = 480, units = "px")

# plot4
# setting column orders for canvas with margin
par(mfcol =c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

# top right plot
plot(powerin$globalactivepower~powerin$NewDateTime,
     powerin, 
     pch  =".",  
     type = "o", 
     lwd  = 0, 
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

# bottom right plot (mix of 3 points)

with(powerin, {
  plot(powerin$submet1~powerin$NewDateTime,
       powerin, 
       pch  = ".",  
       type = "o", 
       lwd  = 0, 
       xlab = "" , 
       ylab = "Energy Submetering" 
       )

  points(powerin$submet2~powerin$NewDateTime,
         powerin, 
         pch = ".", 
         type = "o",  
         col = "red"
         )
  
  points(powerin$submet3~powerin$NewDateTime,powerin, 
         pch  = ".",  
         type = "o", 
         lwd  = 0, 
         xlab = "",
         ylab = "Sub_Metering_3", 
         col  = "blue"
         )
  
  legend("topright", lwd = 2, 
         col = c("black", "blue", "red"), 
         legend = c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3")
         )
})

# Top right plot
plot(powerin$voltage~powerin$NewDateTime,
     powerin, 
     pch  = ".",  
     type = "o", 
     lwd  = 0, 
     xlab = "datetime",
     ylab = "Voltage"
     )

# Bottom right plot
plot(powerin$globalreactivepower ~ powerin$NewDateTime,
     powerin, 
     pch  = ".",  
     type = "o", 
     lwd  = 0, 
     xlab = "datetime",
     ylab = "Global ReActive Power (kilowatts)"
     )

dev.off()  # Close the png file device

