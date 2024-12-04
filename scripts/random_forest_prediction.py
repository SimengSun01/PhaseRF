import argparse
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, multilabel_confusion_matrix
import numpy as np

def random_forest_prediction(train_file, valid_file, test_file, metrics_file, confusion_matrix_file, predictions_file):
    # Load datasets
    train_df = pd.read_csv(train_file)
    valid_df = pd.read_csv(valid_file)
    test_df = pd.read_csv(test_file)

    # Extract features and labels
    X_train, y_train = train_df.iloc[:, :-1], train_df.iloc[:, -1]
    X_valid, y_valid = valid_df.iloc[:, :-1], valid_df.iloc[:, -1]
    X_test, y_test = test_df.iloc[:, :-1], test_df.iloc[:, -1]

    # Train a Random Forest model
    model = RandomForestClassifier(random_state=42)
    model.fit(X_train, y_train)

    # Validate the model
    valid_score = model.score(X_valid, y_valid)
    print(f"Validation Accuracy: {valid_score:.2f}")

    # Evaluate on the test set
    y_pred = model.predict(X_test)
    metrics = classification_report(y_test, y_pred, output_dict=True)
    confusion_matrix = multilabel_confusion_matrix(y_test, y_pred)

    # Save evaluation metrics to a file
    with open(metrics_file, "w") as f:
        f.write("Random Forest Evaluation Metrics\n")
        for label, metric_values in metrics.items():
            f.write(f"{label}: {metric_values}\n")
    print("Metrics saved to:", metrics_file)

    # Save confusion matrix to a file
    np.save(confusion_matrix_file, confusion_matrix)
    print("Confusion matrix saved to:", confusion_matrix_file)

    # Save predicted labels with features to a DataFrame
    test_with_predictions = X_test.copy()
    test_with_predictions['True_Label'] = y_test.values
    test_with_predictions['Predicted_Label'] = y_pred
    test_with_predictions.to_csv(predictions_file, index=False)
    print("Test dataset with predictions saved to:", predictions_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Train and evaluate a Random Forest model.")
    parser.add_argument("--train", required=True, help="Path to training data.")
    parser.add_argument("--valid", required=True, help="Path to validation data.")
    parser.add_argument("--test", required=True, help="Path to test data.")
    parser.add_argument("--metrics", required=True, help="Path to save evaluation metrics.")
    parser.add_argument("--confusion_matrix", required=True, help="Path to save confusion matrix.")
    parser.add_argument("--predictions", required=True, help="Path to save test dataset with predictions.")

    args = parser.parse_args()
    random_forest_prediction(
        args.train, args.valid, args.test, args.metrics, args.confusion_matrix, args.predictions
    )
