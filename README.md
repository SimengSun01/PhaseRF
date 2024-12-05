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


