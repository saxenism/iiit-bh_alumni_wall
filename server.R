library("plotly")
library("ggplot2")
library("ggthemes")
library("DT")
library("googlesheets4")
library("dplyr")

sheets_deauth()

test_df <- readRDS("input_data/cleaned_alumni_4.rds")

prepare_df <- function() {
  test_df <- readRDS("input_data/cleaned_alumni_4.rds")
  #Creating 7 different data frames consisting of names and organizations
  df1 <- test_df[ , c("Full.name", "Organization.1", "id", "Location", "Industry")]  
  colnames(df1) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df2 <- test_df[ , c("Full.name", "Organization.2", "id", "Location", "Industry")]  
  colnames(df2) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df3 <- test_df[ , c("Full.name", "Organization.3", "id", "Location", "Industry")]  
  colnames(df3) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df4 <- test_df[ , c("Full.name", "Organization.4", "id", "Location", "Industry")]  
  colnames(df4) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df5 <- test_df[ , c("Full.name", "Organization.5", "id", "Location", "Industry")]  
  colnames(df5) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df6 <- test_df[ , c("Full.name", "Organization.6", "id", "Location", "Industry")]  
  colnames(df6) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  df7 <- test_df[ , c("Full.name", "Organization.7", "id", "Location", "Industry")]  
  colnames(df7) <- c("Full.name", "Organization", "id", "Location", "Industry")  
  
  #Created a final dataframe that consists of all entries with their associated companies.
  df_final <- rbind(df1, df2, df3, df4, df5, df6, df7)
  
  #Removing all entries where company was not listed.
  no_org_ind <- which(df_final$Organization == "", arr.ind = TRUE)
  df_final <- df_final[-no_org_ind, ]
  
  #Removing duplicate entries
  df_final <- unique(df_final)
  
  #Identifying IIIT-Bh as an organization
  iiit_ind <- which((df_final$Organization == "INTERNATIONAL INSTITUTE OF INFORMATION TECHNOLOGY BHUBANESWAR UNIVERSITY") |
                      (df_final$Organization == "International Institute of Information Technology, Bhubaneswar") |
                      (df_final$Organization == "IIIT Bhubaneswar"),
                    arr.ind = TRUE)
  
  #Removing iiit as organization
  df_final <- df_final[ -(iiit_ind), ]
  
  df_final
}


org_df <- function(df_final) {
  resultant_org_df <- df_final %>% 
    group_by(df_final$Organization) %>% 
    summarise(no_of_emp = n()) 
  
  resultant_org_df <- resultant_org_df[order(-resultant_org_df$no_of_emp), ]
  colnames(resultant_org_df) <- c("Orgs", "Employees")
  
  resultant_org_df
}

loc_df <- function(df_final){
  resultant_loc_df <- df_final %>% 
    group_by(df_final$Location) %>% 
    summarise(residents = n())
  
  #Removing the "" waali entry
  resultant_loc_df <- resultant_loc_df[-1, ]
  resultant_loc_df <- resultant_loc_df[order(-resultant_loc_df$residents), ]
  colnames(resultant_loc_df) <- c("Location", "Employees")
  
  resultant_loc_df
}

ind_df <- function(df_final) {
  resultant_ind_df <- df_final %>% 
    group_by(df_final$Industry) %>% 
    summarise(workers = n())
  
  #Removing the "" waali entry
  resultant_ind_df <- resultant_ind_df[-1, ]
  resultant_ind_df <- resultant_ind_df[order(-resultant_ind_df$workers), ]
  colnames(resultant_ind_df) <- c("Industry", "Employees")
  
  resultant_ind_df
}

shinyServer(function(input, output, session){
  
  raw_df <- test_df
  df <- prepare_df()
  df_org <- org_df(df)
  df_loc <- loc_df(df)
  df_ind <- ind_df(df)
  
###################################################################################################################################################################################################################  
# Helper functions
###################################################################################################################################################################################################################  

top_org_plot_fun_helper <- function(org_test){
  df <- prepare_df()
  df_org <- org_df(df)
  if(is.na(org_test) | length(org_test) == 0 | is.null(org_test)){
    df_org <- df_org[c(1:10), ]
  } else if(org_test == "1-10") {
    df_org <- df_org[c(1:10), ]  
  } else if(org_test == "11-20"){
    df_org <- df_org[c(11:20), ] 
  } else if(org_test == "21-30"){
    df_org <- df_org[c(21:30), ] 
  } else if(org_test == "31-40"){
    df_org <- df_org[c(31:40), ] 
  } else{
    df_org <- df_org[c(41:50), ] 
  }
  Organisation <- reorder(df_org$Orgs,-df_org$Employees)
  top_org_plot <- ggplot(data = df_org, aes(x= Organisation, y=Employees)) + geom_bar(stat = "identity", fill = "Light Yellow", colour = "Red") + coord_flip()
  top_org_plot <- top_org_plot + xlab("Organizations") + ylab("Employee Count") + ggtitle("Top Orgs for IIIT-Bh Alumni") + theme_clean()
  top_org_plot <- top_org_plot + theme(axis.title.x = element_text(colour = "Black", size = 30),
                                       axis.title.y = element_text(colour = "Black", size = 30),
                                       axis.text.x = element_text(size = 10),
                                       axis.text.y = element_text(size = 10),
                                       legend.title = element_text(size = 30),
                                       legend.text = element_text(size = 20),
                                       legend.justification = c(1,1),
                                       plot.title = element_text(colour = "Black", size = 25, family = "Courier"),
                                       )
  
}

top_org_plot_fun <- eventReactive(input$org_rank_in, {
  top_org_plot_fun_helper(input$org_rank_in)
})

org_emp_table_fun <- function(in_name) {
  raw_df[which((raw_df$Organization.1 == in_name) |
                 (raw_df$Organization.2 == in_name) |
                 (raw_df$Organization.3 == in_name) |
                 (raw_df$Organization.4 == in_name) |
                 (raw_df$Organization.5 == in_name) |
                 (raw_df$Organization.6 == in_name) |
                 (raw_df$Organization.7 == in_name), arr.ind = TRUE), c("Full.name", "Profile.url", "Title", "Location", "Organization.1", "Organization.2", "Organization.3", "Organization.4", "Organization.5", "Organization.6", "Organization.7")]
}

org_emp_rec_table <- reactive({org_emp_table_fun(input$org_name_in)})


############################################################################################################################################################################################  

top_loc_plot_fun_helper <- function(loc_test){
  df_fun <- prepare_df()
  df_loc_fun <- loc_df(df_fun)
  if(loc_test == "1-10") {
    df_loc_fun <- df_loc_fun[c(1:10), ]  
  } else if(loc_test == "11-20"){
    df_loc_fun <- df_loc_fun[c(11:20), ] 
  }else if(loc_test == "21-30"){
    df_loc_fun <- df_loc_fun[c(21:30), ] 
  }else if(loc_test == "31-40"){
    df_loc_fun <- df_loc_fun[c(31:40), ] 
  }else{
    df_loc_fun <- df_loc_fun[c(41:50), ] 
  }
  Locale <- reorder(df_loc_fun$Location,-df_loc_fun$Employees)
  top_loc_plot <- ggplot(data = df_loc_fun, aes(x=Locale, y=Employees)) + geom_bar(stat = "identity", fill = "Light Yellow", colour = "Red") + coord_flip()
  top_loc_plot <- top_loc_plot + xlab("Locations") + ylab("Employee Count") + ggtitle("IIIT-Bh Location Chart") + theme_clean()
  top_loc_plot <- top_loc_plot + theme(axis.title.x = element_text(colour = "Black", size = 30),
                                       axis.title.y = element_text(colour = "Black", size = 30),
                                       axis.text.x = element_text(size = 10),
                                       axis.text.y = element_text(size = 10),
                                       legend.title = element_text(size = 30),
                                       legend.text = element_text(size = 20),
                                       legend.justification = c(1,1),
                                       plot.title = element_text(colour = "Black", size = 25, family = "Courier"))
  
}  

top_loc_plot_fun <- eventReactive(input$loc_rank_in,{
  top_loc_plot_fun_helper(input$loc_rank_in)
})
loc_emp_table_fun <- function(in_loc) {
  raw_df[which(raw_df$Location == in_loc, arr.ind = TRUE), c("Full.name", "Profile.url", "Title", "Location", "Organization.1", "Organization.2", "Organization.3", "Organization.4", "Organization.5", "Organization.6", "Organization.7")]
}

loc_emp_rec_table <- reactive({loc_emp_table_fun(input$loc_name_in)})



############################################################################################################################################################################################  

top_ind_plot_fun_helper <- function(ind_test){
  df_fun <- prepare_df()
  df_ind_fun <- ind_df(df_fun)
  if(ind_test == "1-10") {
    df_ind_fun <- df_ind_fun[c(1:10), ]  
  } else if(ind_test == "11-20"){
    df_ind_fun <- df_ind_fun[c(11:20), ] 
  }else if(ind_test == "21-30"){
    df_ind_fun <- df_ind_fun[c(21:30), ] 
  }else if(ind_test == "31-40"){
    df_ind_fun <- df_ind_fun[c(31:40), ] 
  }else{
    df_ind_fun <- df_ind_fun[c(41:43), ] 
  }
  Sector <- reorder(df_ind_fun$Industry,-df_ind_fun$Employees)
  top_ind_plot <- ggplot(data = df_ind_fun, aes(x=Sector, y=Employees)) + geom_bar(stat = "identity", fill = "Light Yellow", colour = "Red") + coord_flip()
  top_ind_plot <- top_ind_plot + xlab("Industries") + ylab("Alumni Count") + ggtitle("IIIT-Bh Industry Chart") + theme_clean()
  top_ind_plot <- top_ind_plot + theme(axis.title.x = element_text(colour = "Black", size = 30),
                                       axis.title.y = element_text(colour = "Black", size = 30),
                                       axis.text.x = element_text(size = 10),
                                       axis.text.y = element_text(size = 10),
                                       legend.title = element_text(size = 30),
                                       legend.text = element_text(size = 20),
                                       legend.justification = c(1,1),
                                       plot.title = element_text(colour = "Black", size = 25, family = "Courier"))
  
}  

top_ind_plot_fun <- eventReactive(input$ind_rank_in,{
  top_ind_plot_fun_helper(input$ind_rank_in)}
)

ind_emp_table_fun <- function(in_ind) {
  raw_df[which(raw_df$Industry == in_ind, arr.ind = TRUE), c("Full.name", "Profile.url", "Title", "Industry", "Organization.1", "Organization.2", "Organization.3", "Organization.4", "Organization.5", "Organization.6", "Organization.7")]
}

ind_emp_rec_table <- reactive({ind_emp_table_fun(input$ind_name_in)})

###############################################################################################################################################################################################  

name_emp_table_fun <- function(in_name) {
  show_df <- raw_df[which(raw_df$Full.name == in_name, arr.ind = TRUE), ]
  show_df <- subset(show_df, select = -c(Avatar, id))
}

name_emp_rec_table <- reactive({name_emp_table_fun(input$emp_name_in)})

  
###################################################################################################################################################################################################################  
# "search_org" tab
###################################################################################################################################################################################################################  
  
  
  output$org_range_input <- renderUI({
    selectInput(inputId = "org_rank_in", "Select Range", choices = c("1-10","11-20","21-30","31-40","41-50")) 
  })
  
  output$org_name_input <- renderUI({
    selectInput(inputId = "org_name_in", "Select Org Name", choices = sort(unique(df_org$Orgs)), selected = "Amazon Web Services (AWS)")
  })
  
  output$top_org_plot <- renderPlotly({top_org_plot_fun()})
  
  output$org_emp_table <- renderDT({org_emp_rec_table()})
  
###################################################################################################################################################################################################################  
# "search_loc" tab
###################################################################################################################################################################################################################  
  
  output$loc_range_input <- renderUI({
    selectInput(inputId = "loc_rank_in", "Select Range", choices = c("1-10","11-20","21-30","31-40","41-50")) 
  })
  
  output$loc_name_input <- renderUI({
    selectInput(inputId = "loc_name_in", "Select Location", choices = levels(df_loc$Location))
  })
  
  output$top_loc_plot <- renderPlotly({top_loc_plot_fun()})
  
  output$loc_emp_table <- renderDT({loc_emp_rec_table()})
  
###################################################################################################################################################################################################################  
# "search_ind" tab
###################################################################################################################################################################################################################  
  
  output$ind_range_input <- renderUI({
    selectInput(inputId = "ind_rank_in", "Select Range", choices = c("1-10","11-20","21-30","31-40","41-43")) 
  })
  
  output$ind_name_input <- renderUI({
    selectInput(inputId = "ind_name_in", "Select Industry", choices = df_ind$Industry)
  })
  
  output$top_ind_plot <- renderPlotly({top_ind_plot_fun()})
  
  output$ind_emp_table <- renderDT({ind_emp_rec_table()})
  
###################################################################################################################################################################################################################  
# "search_name" tab
###################################################################################################################################################################################################################  
  
  output$emp_name_input <- renderUI({
    selectInput(inputId = "emp_name_in", "Select Name", choices = sort(df$Full.name), selected = df$Full.name[1])
  })
  
  output$participants <- renderValueBox({
    valueBox(
      value = tags$p("1077",tags$b(), tags$b(), style = "font-size: 300%;"),
      subtitle = tags$p("Profiles scraped so far, more coming your way!!", style = "font-size: 170%;"),
      icon = icon("user-plus"),
      color = "light-blue"
    )
  })
  
  output$name_emp_table <- renderDT({name_emp_rec_table()})
  
###################################################################################################################################################################################################################  
# "miss_info" tab
###################################################################################################################################################################################################################  

googleform_data_url <- "https://docs.google.com/spreadsheets/d/1Zw09p_AgJyNqRpKuR0e5FyM0-O0k2_VUgblE4Mx70Ic/edit?usp=sharing"
  
output$googleFormData <- DT::renderDataTable({
  input$refresh
  ss_dat <- read_sheet(googleform_data_url)
  DT::datatable(ss_dat)
})
  
})