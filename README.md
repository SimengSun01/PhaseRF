# **PhaseRF: Random Forest Pipeline for Cell Phase Prediction**

## **Background and Rationale**!

![Blank diagram](https://github.com/user-attachments/assets/1e042a7d-cad4-476a-bc9f-bc65489b2724)


In this five-step Nextflow pipeline project, the goal is to train a **RandomForest model** for cell phase prediction. The input is a **preprocessed expression matrix** in CSV format annotated with cell phase information (`G0`, `G1`, `S2M`, and `G2`). Through training, the RandomForest model learns patterns within the data to predict the phase of each cell. The pipeline also includes:

- Visualization of evaluation metrics using a **confusion matrix**.
- **Principal Component Analysis (PCA)** on the test data, with cells visualized in low-dimensional space distinguished by predicted labels.

The following Python packages are utilized:

- `pandas`
- `numpy`
- `scikit-learn`
- `matplotlib`
- `seaborn`

---

## **Usage**

### **Installation**
1. Open the terminal and clone the repository:
   ```bash
   git clone https://github.com/SimengSun01/PhaseRF.git
2. Change to the project directory:
   ```bash
   cd PhaseRF
3. Pull the Docker image:
   ```bash
   docker pull selinasun01/phaserf:latest
4. Run the pipeline using NextFlow:
   ```bash
   nextflow run test.nf -profile docker
5. After completing the training and testing process, you can find the results by entering: `cd output` where intermediate results are saved
6. For the testing metrics, confusion matrix visualization and PCA visualization, enter `cd results` from `output`
The input data is already included in input, no adjustment needed to run the pipeline.


### **Steps**
1. Preprocess Data
   Read the csv, in which the raw data is already preprocessed and only contains cycling genes, with a label column (string) named as “phase”; we use MinMaxScaler to normalize the gene expression data, and produce an intermediate output called “preprocessed_data.csv"

2. Split dataset
   In this step, we split our dataset into 3 parts: train, test and validation and save them in the output directory for future usage.

3. Random Forest Prediction Training and Testing
   Random Forest model training and testing. Classification report and model performance are calculated in this step. The scores are saved in `output/result` for future reference.

5. Confusion Matrix Visualization
   Visualize the scores and classification reports saved from previous steps.
   
7. PCA and Visualization
   Applying dimension reduction on the testing data, such that we plot the first 2 principal components, in which each dot represents a cell, and each dot is coloured based on the predicted labels. We expect to see cells (predicted) to cluster with cells in the same phase.

## **Input**
The input is a set of human fibroblast cells gene expression data originally curated by Rita (2022). The dataset used by the project is in the CSV format, a raw count expression matrix that is preprocessed (cells filtered following the standard scRNA preprocessing protocol, filtered to keep only the set of annotated cycling & G0 marker genes) before the proeject, with an extra column named as “phase” representing the phase the cells. 
Overall, the sample dataset is a raw count expression matrix with 4457 rows (cells) and 2121 columns (2120 genes and 1 label column). Within the label column, “phase”, we have 4 distinct labels: G0, G1, S2M, G2 in strings, while the rest of the data is consisted of integers representing the count of gene expressions. 


## **Output**
The pipeline provides multiple levels of outputs, including the intermediate outputs that are used for further analysis. For the final outputs that can be found in `PhaseRF/output/results`:
1. multiple (depends on th number of distinct labels in the dataset; in this case, it is 4) distinct confusion matrix figures are generated to illustrate the classification prediction on a label level. They are named following this pattern: `confusion_matrix_label_n.png`
2. an Evaluation metrics computed based on the model performance is generated; evaluation metrics such as precision, recall, support are included. The calculations can be found in `metrics.txt` and `confusion_matrix.npy`
3. a PCA visualization figure (`pca_plot.png`) computed based on the test set is provided, with each dot representing a cell in the testing data, and each cell is coloured based on their predicted labels. In detail, G0 cells are coloured in blue G1 coloured in orange, S cells coloured in green and G2M cells in red.
4. a csv called `predictions.csv` that contains the detailed predicted label for each cell, which is useful for future analysis.

Sample dataset created by Riba (2022): https://zenodo.org/records/4719436

