# **PhaseRF: Random Forest Pipeline for Cell Phase Prediction**

## **Background and Rationale**
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
5. After completing the training and testing process, you can find the results by entering: `cd output`
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
   

