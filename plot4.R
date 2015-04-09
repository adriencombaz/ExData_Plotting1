setwd("/home/adrien/Work/Training/data-scientist-specialization/04-Exploratory-Data-Analysis/assignment1/ExData_Plotting1/")
rm(list = ls())
library(ggplot2)

#=============================================================================================================
# LOAD AND OBSERVE DATA
#=============================================================================================================
filePath <- "/home/adrien/Work/Training/data-scientist-specialization/04-Exploratory-Data-Analysis/assignment1/"
filename <- file.path(filePath, "household_power_consumption.txt")
data  <- read.table(pipe( paste0("awk -F\";\" -v col=\"Date\" ",                                                 # Define field delimiter and column name that we want to inspect
                                 "'NR==1 {for(i=1; i<=NF ; i++){ if($i==col){ n=i ; print; break; } }} ",        # Find the position of our target column (column names are in the first line of the file, hence the NR=1), prints also the header line
                                 "match($n, \"^[1-2]/2/2007\") {print $0}' ",                                    # Print only the lines for which the value in our target column matches the regular expression 
                                 filename)), 
                    sep=";", header=T, na.strings="?")
data$datetime <- strptime( paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
str(data)
summary(data)
head(data)

#=============================================================================================================
# PRODUCE DESIRED PLOT
#=============================================================================================================
png( filename="plot4.png"
     , width = 480
     , height = 480
     , units = "px"
     , bg = "transparent"
)
par(mfrow = c(2, 2))
with(data, {
  plot(x=data$datetime, y=data$Global_active_power, "l", ylab="Global Active Power (kilowatts)", xlab="")
  plot(x=data$datetime, y=data$Voltage, "l", ylab="Voltage", xlab="datetime")
  {plot(x=data$datetime, y=data$Sub_metering_1, "l", col="black", xlab="", ylab="Energy sub metering")
   with(data, lines(datetime, Sub_metering_2, col="red"))
   with(data, lines(datetime, Sub_metering_3, col="blue"))
   legend("topright", col = c("black", "red", "blue"), lwd=2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  }
  plot(x=data$datetime, y=data$Global_reactive_power, "l", xlab="datetime")
})
dev.off()
