library("shiny")
library("shinydashboard")
library("ggplot2")
library("ggthemes")
library("DT")
library("plotly")
library("shinyjs")


shinyUI(
  hidden(
    div(id = "full_page",
        dashboardPage(
          dashboardHeader(title = "IIIT Bhubaneswar Alumni Wall", titleWidth = 1880),
          
          dashboardSidebar(
            width = 300,
            tags$img(src = "logo.jpg", height = 200, width = 300, align = "bottom"),
            sidebarMenu(
              menuItem(h4("Search by Organization"), tabName = "search_org", icon = icon(name = "industry")),
              menuItem(h4("Search by Name"), tabName = "search_name", icon = icon("address-book-o")),
              menuItem(h4("Search by Location"), tabName = "search_loc", icon = icon("globe")),
              menuItem(h4("Search by Industry"), tabName = "search_ind", icon = icon("rocket")),
              menuItem(h4("About"), tabName = "about", icon = icon("clipboard"))
            )
          ),
          
          dashboardBody(
            tabItems(
              tabItem(tabName = "search_org", 
                      fluidRow(box(status = "primary", plotlyOutput("top_org_plot"), height = 400, width = 10),
                               box(status = "primary", br(), br(), h4(tags$b("Select the range by which you want the top organizations to be shown")), br(), br(), br(), uiOutput("org_range_input"), height = 400, width = 2, background = "light-blue")),
                      
                      fluidRow(box(status = "primary", div(style = 'overflow-x: scroll', DTOutput('org_emp_table')), width = 8),
                               box(status = "primary", br(), br(), h4(tags$b("Select the organization for which you want our alumni to be shown")), br(), br(), br(), uiOutput("org_name_input"), height = 300, width = 4, background = "light-blue"))
              ),
              tabItem(tabName = "search_loc",
                      fluidRow(box(status = "primary", plotlyOutput("top_loc_plot"), height = 400, width = 10),
                               box(status = "primary", br(), br(), br(), h4(tags$b("Select the range to display the top locations for our Alumni base")), br(), br(), br(), uiOutput("loc_range_input"), height = 400, width = 2, background = "light-blue")),
                      
                      fluidRow(box(status = "primary", div(style = 'overflow-x: scroll', DTOutput('loc_emp_table')), width = 9),
                               box(status = "primary", br(), br(), br(), h4(tags$b("Select the location for which you want our alumni to be shown")), br(), br(), br(), uiOutput("loc_name_input"), height = 300, width = 3, background = "light-blue"))
              ),
              tabItem(tabName = "search_ind",
                      fluidRow(box(status = "primary", plotlyOutput("top_ind_plot"), height = 400, width = 10),
                               box(status = "primary", br(), br(), br(), h4(tags$b("Select the range to display the top industries for our Alumni base")), br(), br(), br(), uiOutput("ind_range_input"), height = 400, width = 2, background = "light-blue")),
                      
                      fluidRow(box(status = "primary", div(style = 'overflow-x: scroll', DTOutput('ind_emp_table')), width = 9),
                               box(status = "primary", br(), br(), br(), h4(tags$b("Select the industry for which you want our alumni to be shown")), br(), br(), br(), uiOutput("ind_name_input"), height = 300, width = 3, background = "light-blue"))
              ),
              tabItem(tabName = "search_name",
                      fluidRow(box(status = "primary", br(), br(), br(), h4(tags$b("Select the name for which you require information")), br(), br(), br(), uiOutput("emp_name_input"), height = 300, background = "black", width = 8),
                               tags$head(tags$style(HTML(".small-box {height: 300px}"))),
                               valueBoxOutput(outputId = "participants")),
                      fluidRow(box(status = "primary", div(style = 'overflow-x: scroll', DTOutput('name_emp_table')), width = 12))
              ),
              tabItem(tabName = "about",
                      tags$div(
                        tags$h2(tags$u("Updates: ")), 
                        h3("This dashboard will keep on updating as new profiles are scraped."),tags$br(),tags$br(),
                        tags$h2(tags$u("Contact Me: ")),
                        h3("Found some bug/issue/security flaw in the app ?"),
                        h3(tags$a(href="https://github.com/hinduBale/iiit-bh_alumni_wall/issues/new", "Let me know here")),tags$br(),
                        h3("Found some alumni to be missing or encountered some false information ?"),
                        h3(tags$a(href="https://forms.gle/yY669X1ecmfuvcvR9", "Let me know here")),tags$br(),
                        h3("Want to discuss something ? I can be reached at  "),
                        h3(tags$a(href="mailto:saxenism@gmail.com?Subject=AlumniWall%20Discussions",target="_top", "saxenism@gmail.com")),tags$br(),tags$br(),
                        tags$h2(tags$u("About the Developer: ")),
                        h3("Ciao, I'm", tags$b("Rahul Saxena"), ", a 3rd year Computer Science undergraduate at IIIT-Bhubaneswar. Most probably owing to this COVID-19 pandemic, almost the entire 2017-21 batch is going to face major problems related to placements and internships in this dwindling economy."),
                        h3("Apart from testing my newly gained R knowledge, this dashboard is my way of helping out my batchmates and also college-mates so that they can take informed decisions and contact the right people for job openings or referrals, should the need arise."),
                        h3("You can find me on ") ,
                        h3(tags$a(href="https://github.com/hinduBale", "Github")),
                        h3(tags$a(href="https://www.linkedin.com/in/saxena-rahul/", "LinkedIn")),
                        h3(tags$a(href="https://twitter.com/hinduBale", "Twitter")),
                        h3(tags$a(href="https://www.quora.com/profile/Rahul-Saxena-30", "Quora")),
                        h3(tags$a(href="https://www.instagram.com/saxenism/", "Instagram")),
                        h3("If you liked my work, consider starring", tags$a(href = "https://github.com/hinduBale/iiit-bh_alumni_wall", "the repo."), ", or treating me with Mazhar's Biryani someday :P"),
                        h3("Thanks for dropping by. Peace _/\\_")
                      )
              )
              
            )
          )
        )
        )
  )
    
)
