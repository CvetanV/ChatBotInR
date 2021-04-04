#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr); library(tm)
library(NLP)
library(SnowballC)
library("e1071")

# read the training dataset
data <- read.csv('train.csv',stringsAsFactors = TRUE);

# 1. Convert training questions into document term matrix (sparse matrix with 1s and 0s)
#clean the text


corpus = VCorpus(VectorSource(data$Q))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
#corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

# convert to DTM
dtm = DocumentTermMatrix(corpus)

# convert to dataframe
dataset = as.data.frame(as.matrix(dtm))

# 2. Match the matrix of each training question with its corresponding answer to form a training matrix
data_train= cbind(data['A'], dataset)

# 3. Train Naive Bayes model with the training matrix

#naivefit = naiveBayes(A ~ ., data = data_train, laplace = 3)
svmfit = svm(A ~., data= data_train, cost = 100, type = "C", scale = FALSE)
#forest = randomForest(A ~ ., data = data_train, ntree=100, importance=TRUE, na.action=na.omit, do.trace=TRUE)

# 4. Propose a testing quesiton and build the prediction function
pred = function(x){
    
    # 5. Convert the testing question into document term matrix (sparse matrix with 1s and 0s)
    #clean the text
    corpus_test = VCorpus(VectorSource(x))
    corpus_test = tm_map(corpus_test, content_transformer(tolower))
    corpus_test = tm_map(corpus_test, removeNumbers)
    corpus_test = tm_map(corpus_test, removePunctuation)
    #  corpus_test = tm_map(corpus_test, removeWords, stopwords())
    corpus_test = tm_map(corpus_test, stemDocument)
    corpus_test = tm_map(corpus_test, stripWhitespace)
    # convert to DTM
    dtm_test = DocumentTermMatrix(corpus_test)
    # convert to dataframe
    data_test = as.data.frame(as.matrix(dtm_test))
    
    # 6. Merge the testing DTM with training DTM, with testing DTM 1s for all terms and training DTM 0s for all terms
    add_data = dataset[1,]
    add_data[add_data == 1] = 0
    data_test=cbind(data_test,add_data)
    
    # 7. Predict the answer with the trained SVM model
    p = predict(svmfit, data_test)
    answer = as.character(p)
    # Predict
    return(answer)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    randomVals <- eventReactive(input$go, {
        input$inputText
    });

    output$outcome<-renderPrint({
           pred(randomVals())
        });
        
})
