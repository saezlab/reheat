# UI
source("sub/global.R")
source("sub/helper.R")
ui = function(request) {
  fluidPage(
    useShinyjs(),
    tags$head(includeScript("google-analytics.js")),
    navbarPage(
      id = "menu", 
      title = div(img(src="logo_saezlab.png", width="25", height="25"),
                  "ReHeat-App"),
      windowTitle = "ReHeat",
      collapsible=T,
      
      #### Welcome ####
      tabPanel(
        title = "Welcome",
        icon = icon("home"),
        sidebarPanel(
          includeMarkdown("inst/landingpage_sidebar.md")
        ),
        mainPanel(
          includeMarkdown("inst/landingpage.md")
        )
      ),
      
      #### Query genes ####
      tabPanel(
        title = "Query genes",
        icon = icon("search"),
        sidebarPanel(
          includeMarkdown("inst/query_genes_sidebar.md"),
          pickerInput(inputId = "select_gene", label = "Select gene(s)",
                      choices = sort(unique(contrasts$gene)), multiple = T,
                      options = list(`live-search` = TRUE,
                                     size=10, `max-options` = 10))
        ),
        mainPanel(
          h4("Expression of queried genes"),
          plotlyOutput("gene_regulation_boxplot", width = "100%", height = "600px") %>%
            withSpinner(),
          h4("Ranking of queried genes"),
          plotlyOutput("rank_position", width = "100%", height = "125px") %>%
            withSpinner(),
          h4("Distribution of mean t-values"),
          plotlyOutput("mean_t_dist", width = "100%", height = "250px") %>%
            withSpinner(),
          hr(),
          h4("Raw data"),
          tabsetPanel(
            type = "tabs",
            tabPanel("Consensus", DT::dataTableOutput("summary_sub")),
            tabPanel("Individual", DT::dataTableOutput("individual_sub"))
          )
        )
      ),
      
      #### Input data ####
      tabPanel(
        title = "Enrichment analysis",
        icon = icon("file-upload"),
        sidebarPanel(
          includeMarkdown("inst/input_data_sidebar.md"),
          h5("Use example data?"),
          switchInput(inputId = "take_example_data",
                      onLabel = "Yes", offLabel = "No", value=F), 
          p("Gene sets must be uploaded as .csv file. The gene set members must 
             be stored in column named 'gene'. In case of multiple gene sets a 
             second column named 'geneset' must be added containing the gene set 
             name/identifier."),
          fileInput("user_input", label="Upload gene sets (.csv)"),
          p("Choose whether you would like to test your gene set agains a 
             directed or undirected signature."),
          radioButtons("signature_source", "Signature", 
                       choices = c("directed", "undirected")),
          p("GSEA will be performed upon clicking the submit button."),
          actionButton("submit", label="Submit",
                       icon=icon("send")) 
          ),
        mainPanel(
          h4("GSEA result"),
          DT::dataTableOutput("gsea_res_table"),
          hr(),
          h4("GSEA plots"),
          plotOutput("gsea_res_plots", width = "100%", height = "600px") %>%
            withSpinner()
        )
      ),
      #### Meta analysis results ####
      tabPanel(
        title = "Consensus signature",
        icon = icon("table"),
        sidebarPanel(
          includeMarkdown("inst/meta_analysis_results_sidebar.md")
          ),
        mainPanel(
          tabsetPanel(
            type = "tabs",
            tabPanel("Consensus", DT::dataTableOutput("summary")),
            tabPanel("Individual", DT::dataTableOutput("individual"))
          )
        )
      ),
      
      #### Functional analysis ####
      tabPanel(
        title = "Functional analysis",
        icon = icon("chart-line"),
        sidebarPanel(
          includeMarkdown("inst/functional_analysis_sidebar.md")
        ),
        mainPanel(
          tabsetPanel(
            type = "tabs",
            tabPanel("PROGENy", DT::dataTableOutput("progeny_table")),
            tabPanel("DoRothEA", DT::dataTableOutput("dorothea_table")),
            tabPanel("GSEA", DT::dataTableOutput("gsea_table")),
            tabPanel("GSEA to microRNAs", DT::dataTableOutput("mi_gsea_table"))
            )
          )
        ),
      
      #### Study overview ####
      tabPanel(
        title = "Study overview",
        icon = icon("database"),
        sidebarPanel(
          includeMarkdown("inst/overview_sidebar.md")
        ),
        mainPanel(
          DT::dataTableOutput("overview"),
          br(),
          includeMarkdown("inst/overview.md")
        )
      ),
      
      #### Footer ####
      footer = column(12, align="center", "ReHeaT-App 2020")
    ) # close navbarPage
  ) # close fluidPage
}
