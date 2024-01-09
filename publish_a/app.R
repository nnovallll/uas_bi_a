# Install paket jika belum terinstall
# install.packages(c("shiny", "shinydashboard", "DT"))

# Memuat library
library(shiny)
library(shinydashboard)
library(DT)  # Memuat library DT untuk rendering DataTable
library(ggplot2)

# Data untuk tabel
sales_data <- data.frame(
  Bulan = month.abb,
  x1 = c(150000, 160000, 170000, 180000, 190000, 200000, 210000, 220000, 230000, 240000, 250000, 260000),
  x2 = c(8000, 9500, 10000, 10500, 11000, 9000, 11500, 12000, 12500, 13000, 14000, 15000),
  x3 = c(5, 4.5, 4.8, 4.6, 5.1, 4.7, 4.9, 5.0, 5.2, 5.3, 5.4, 5.5),
  x4 = c(8.5, 8.2, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9, 8.7, 8.8, 8.9, 9.0),
  x5 = c(20000, 22000, 25000, 23000, 30000, 28000, 27000, 35000, 40000, 45000, 50000, 60000),
  y = c(120, 150, 160, 165, 180, 170, 190, 210, 230, 250, 300, 350)
)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard Noval"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Tabel Data", tabName = "tableTab"),
      menuItem("Model Regresi", tabName = "regressionTab"),  # Menambahkan menu untuk model regresi
      menuItem("Prediksi", tabName = "predictionTab")  # Menambahkan menu untuk prediksi
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "tableTab",
              dataTableOutput("table")),
      
      tabItem(tabName = "regressionTab",
              fluidPage(
                dataTableOutput("regressionTableDT"),  # Menambahkan output untuk tabel regresi
                h3("Interpretasi Model Regresi"),
                p("Dalam model regresi ini, monthly sales volume (dalam ribuan USD) (y) dapat dijelaskan oleh variabel-variabel berikut: jumlah pengunjung website per bulan (x1), jumlah transaksi bulanan (x2), rata-rata jumlah barang per transaksi (x3), customer satisfaction rating (skala 1-10) (x4), dan jumlah iklan online yang dijalankan per bulan (x5). Hasil analisis menunjukkan bahwa hanya x2 (number of monthly transactions) dan x5 (number of online advertisements) yang signifikan secara statistik dalam memprediksi penjualan bulanan, dengan x2 memberikan pengaruh positif sekitar 1.112e-02 dan x5 memberikan pengaruh positif sekitar 0.005185."),
                selectInput("variableBoxplot", "Pilih Variabel untuk Boxplot", choices = names(sales_data)),  # Menambahkan input untuk memilih variabel boxplot
                plotOutput("boxplot"),  # Menambahkan output untuk boxplot
                h3("Ringkasan Model Regresi"),
                p("Dalam model regresi ini, nilai Multiple R-squared sebesar 0.991 dan Adjusted R-squared sebesar 0.9834 menunjukkan bahwa sekitar 99.1% variabilitas dalam variabel dependen dapat dijelaskan oleh model ini. Adjusted R-squared memberikan gambaran yang lebih baik dalam situasi multiple regression dengan memperhitungkan jumlah variabel independen."),
                plotOutput("regressionPlot")  # Menambahkan output untuk plot regresi
              )
      ),
      
      tabItem(tabName = "predictionTab",  # Menambahkan konten untuk tab prediksi
              fluidPage(
                titlePanel(title = div("Monthly Sales Volume Analysis Dashboard", style = "color: #333333; font-size: 40px; font-weight: bold; text-align: center; height: 120px")),
                sidebarLayout(
                  sidebarPanel(
                    h3("Prediksi Penjualan Bulanan"),
                    p("Gunakan model regresi untuk memprediksi penjualan bulanan."),
                    numericInput("input_x1", "Jumlah Pengunjung Website per Bulan:", min = 0, value = 120000),  # Input untuk jumlah pengunjung website per bulan
                    numericInput("input_x2", "Jumlah Transaksi Bulanan:", min = 0, value = 10000),  # Input untuk jumlah transaksi bulanan
                    numericInput("input_x3", "Rata-rata Jumlah Barang per Transaksi:", min = 0, value = 6),  # Input untuk rata-rata jumlah barang per transaksi
                    numericInput("input_x4", "Customer Satisfaction Rating (1-10):", min = 0, max = 10, value = 8),  # Input untuk customer satisfaction rating
                    numericInput("input_x5", "Jumlah Iklan Online:", min = 0, value = 30000),  # Input untuk jumlah iklan online
                    actionButton("predictButton", "Prediksi")  # Tombol untuk melakukan prediksi
                  ),
                  mainPanel(
                    plotOutput("predictionPlot")  # Output untuk menampilkan hasil prediksi dalam bentuk plot  
                  )
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  output$table <- renderDataTable({
    sales_data
  })
  
  # Fungsi untuk membuat model regresi dan merender tabelnya
  output$regressionTableDT <- renderDataTable({
    # Estimasi multiple linear regression
    model <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = sales_data)
    
    # Menampilkan tabel koefisien regresi dengan format yang lebih rapi
    coef_summary <- summary(model)$coefficients
    coef_summary <- coef_summary[, c("Estimate", "Std. Error", "t value", "Pr(>|t|)")]
    rownames(coef_summary) <- c("Intercept", "x1", "x2", "x3", "x4", "x5")
    coef_summary
  }, options = list(pageLength = 5, lengthMenu = c(5, 10, 15), scrollX = TRUE))
  
  output$boxplot <- renderPlot({
    # Membuat boxplot sesuai dengan variabel yang dipilih
    var_selected <- input$variableBoxplot
    boxplot(sales_data[, var_selected], main = paste("Boxplot of", var_selected),
            xlab = "Variable", ylab = var_selected)
  })
  
  output$regressionPlot <- renderPlot({
    # Tambahkan plot regresi
    ggplot(sales_data, aes(x = x2, y = y)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(title = "Scatter Plot and Regression Line",
           x = "Number of Monthly Transactions",
           y = "Monthly Sales Volume (in thousands of USD)")
  })
  
  output$predictionPlot <- renderPlot({
    # Menggunakan model regresi yang sudah diestimasi
    new_data <- data.frame(
      x1 = input$input_x1,
      x2 = input$input_x2,
      x3 = input$input_x3,
      x4 = input$input_x4,
      x5 = input$input_x5
    )
    predicted_value <- predict(lm(y ~ x1 + x2 + x3 + x4 + x5, data = sales_data),
                               newdata = new_data)
    
    # Menampilkan hasil prediksi dalam bentuk plot
    plot(new_data$x2, predicted_value, type = "l", col = "red",
         xlab = "Number of Monthly Transactions", ylab = "Predicted Monthly Sales Volume (in thousands of USD)",
         main = "Prediksi Penjualan Bulanan")
    
    # Menambahkan data asli pada plot
    points(sales_data$x2, sales_data$y, col = "blue", pch = 16)
    legend("topright", legend = c("Prediksi", "Data Asli"), col = c("red", "blue"), lty = 1:1, cex = 0.8)
  })
  
}

shinyApp(ui, server)
