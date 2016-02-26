## Steps used to clean and merge the Train and Test data

1. First of all the script reads the "features" from the "features.txt" file.
2. With the "features" array, it can crate a filter only for "Mean" and "Standard Deviation" measures.
3. Read the measurements from "X_train.txt" file, filters for the relevant measurements and changes the names of the variables to a more relevant one.
4. Read the measurements from "X_test.txt" file, filters for the relevant measurements and changes the names of the variables to a more relevant one.
5. Bind the subject IDs to the train measurements.
6. Bind the subject IDs to the test measurements.
7. Bind the activity to the train measurements.
8. Bind the activity to the test measurements.
9. Merge both test and train activity.