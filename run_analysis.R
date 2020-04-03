library(data.table)
library(dplyr)

x_train <- data.table::fread("UCI HAR Dataset\\train\\x_train.txt")
x_test <- data.table::fread("UCI HAR Dataset\\test\\x_test.txt")
x <- data.table::rbindlist(list(x_train, x_test))
rm(x_train, x_test)
y_train <- data.table::fread("UCI HAR Dataset\\train\\y_train.txt")
y_test <- data.table::fread("UCI HAR Dataset\\test\\y_test.txt")
y <- data.table::rbindlist(list(y_train, y_test))
rm(y_train, y_test)
my_names <- data.table::fread("UCI HAR Dataset\\features.txt")
my_labels <- data.table::fread("UCI HAR Dataset\\activity_labels.txt")
my_names$kept_col_names <- grepl("mean\\(\\)|std\\(\\)", my_names$V2)
my_names$V1 <- paste("V", my_names$V1, sep = "")
cols_to_select <- my_names[kept_col_names == TRUE, V1]
x[,..cols_to_select]
x <- x[,..cols_to_select]
cols_names_to_select <- my_names[kept_col_names == TRUE, V2]
names(x) <- cols_names_to_select
rm(my_names)
rm(cols_to_select)
rm(cols_names_to_select)

y <- dplyr::left_join(y, my_labels)
y <- data.table::data.table(y$V2)
rm(my_labels)
xy <- x
xy$Activity <- y$V1
rm(x, y)
my_summary <- group_by(xy, Activity) %>% summarise_all(mean)
