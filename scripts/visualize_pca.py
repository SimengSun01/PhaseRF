import argparse
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

def visualize_pca(predictions_file, output_file):
    data = pd.read_csv(predictions_file)

    #####################
    features = data.select_dtypes(include=[float, int])
    predicted_labels = data['Predicted_Label']

    # standardization 
    scaler = StandardScaler()
    standardized_features = scaler.fit_transform(features)

    #PCA
    pca = PCA(n_components=2)
    pca_result = pca.fit_transform(standardized_features)
    pca_df = pd.DataFrame(pca_result, columns=['PC1', 'PC2'])
    pca_df['Predicted_Label'] = predicted_labels

    ######
    plt.figure(figsize=(10, 8))
    for label in pca_df['Predicted_Label'].unique():
        subset = pca_df[pca_df['Predicted_Label'] == label]
        plt.scatter(subset['PC1'], subset['PC2'], label=f"{label}", alpha=0.7)

    plt.title("PCA Visualization of Predictions", fontsize=16)
    plt.xlabel("Principal Component 1", fontsize=12)
    plt.ylabel("Principal Component 2", fontsize=12)
    plt.legend(title="Predicted Label")
   

    plt.savefig(output_file, dpi=300)
    print(f"PCA visualization saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="PCA Visualization of test predictions")
    parser.add_argument("--predictions", required=True, help="the predictions CSV file.")
    parser.add_argument("--output", required=True, help="PCA visualization figs.")

    args = parser.parse_args()
    visualize_pca(args.predictions, args.output)




