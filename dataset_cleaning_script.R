#setwd("C:\\Users\\Rahul\\Desktop\\R Programming\\alumni_shiny_app")

#dataset <- read.csv(file.choose())

#Removing duplicate entries
dataset <- unique(dataset)

#Checking the dataset
colnames(dataset)

#Removing all unnecessary columns from our dataset
dataset <- subset(dataset, select = -c(Phone.1))
dataset <- subset(dataset, select = -c(Address, Birthday, Phone.1.type,Phone.2.type,Phone.3.type,Phone.2, Phone.3, Messenger.1.type,Messenger.1,Messenger.2,Messenger.2.type,Messenger.3,Messenger.3.type, Website.3, Relationship, Connected.at, Mutual.Count, Mutual, Mutual.1, Mutual.2, Interests))
dataset <- subset(dataset, select = -c(Organization.WWW.1, Organization.WWW.2, Organization.WWW.3, Organization.WWW.4, Organization.WWW.5, Organization.WWW.6, Organization.WWW.7,Organization.Domain.1,Organization.Domain.2,Organization.Domain.3,Organization.Domain.4,Organization.Domain.5,Organization.Domain.6,Organization.Domain.7))
dataset <- subset(dataset, select = -c(Followers, Organization.LI.ID.1,Organization.LI.ID.2,Organization.LI.ID.3,Organization.LI.ID.4,Organization.LI.ID.5,Organization.LI.ID.6,Organization.LI.ID.7))

#Checking the new dataset now.
colnames(dataset)

#Converting all relevant factor levels to characters.
dataset$Organization.1 <- as.character(dataset$Organization.1)
dataset$Organization.2 <- as.character(dataset$Organization.2)

#Finding all entries that do not have any organisation associated with them
student_df_ind <- which(dataset$Organization.1 == "", arr.ind = TRUE)
#Checking whether these entries should be removed or not...
student_df <- NULL
for (i in student_df_ind) {
  student_df <- rbind(student_df, dataset[i, ])
}
student_df$Title

#Updating the dataset by removing all student_df_ind
dataset <- dataset[-(student_df_ind), ]

#Now checking the entries where the Title contains student
student_check <- which(as.character(dataset$Title) == "Student at International Institute of Information Technology, Bhubaneswar", arr.ind = TRUE)
student_check <- c(student_check, which(as.character(dataset$Title) == "Student at IIIT Bhubaneswar", arr.ind = TRUE)) 
for (i in student_check) {
  print(dataset[i, "Organization.1"])
}

student_check_fail <- NULL
for ( i in student_check) {
  if((dataset[i, "Organization.1"] == "IIIT Bhubaneswar" | 
        dataset[i, "Organization.1"] == "International Institute of Information Technology, Bhubaneswar") &
          dataset[i, "Organization.2"] == "") {
    student_check_fail <- c(student_check_fail, i)
  }
}  
  
#Removing students discovered from student_check_fail
dataset <- dataset[-(student_check_fail), ]

#Writing out this dataset into a .csv file
write.csv(dataset, ".//cleaned_alumni_2.csv")


# top_investors_plot <- ggplot(data = top_investors, aes(x = top_investors$CompanyName, y = top_investors$AmountInvested)) + geom_bar(stat = "identity", fill = "SkyBlue") + coord_flip()
# top_investors_plot <- top_investors_plot + xlab("Company Name") + ylab("Amount Invested(in $)") + ggtitle("Top investors")
# top_investors_plot <- top_investors_plot + theme(axis.title.x = element_text(colour = "Red", size = 30),
#                                                  axis.title.y = element_text(colour = "Red", size = 30),
#                                                  axis.text.x = element_text(size = 20),
#                                                  axis.text.y = element_text(size = 10),
#                                                  legend.title = element_text(size = 30),
#                                                  legend.text = element_text(size = 20),
#                                                  legend.justification = c(1,1),
#                                                  plot.title = element_text(colour = "Red", size = 40, family = "Courier", hjust = 0.5)
# )
 

  