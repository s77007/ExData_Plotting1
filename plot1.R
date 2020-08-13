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
png(file = "./ExData_Plotting1/plot1.png", width = 480, height = 480, units = "px")

# first histogram plot1 sent to png device
hist(powerin$globalactivepower, 
     col="red", 
     xlab = "Global Active Power(kilowatts)", 
     ylab = "Frequency", 
     main="Global Active Power"
     )


dev.off()  # Close the png file device