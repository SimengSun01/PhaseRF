#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//parameters 
params.input_csv = "${projectDir}/input/data.csv"
params.preprocess_script = "${projectDir}/scripts/preprocess_data.py"
params.split_script = "${projectDir}/scripts/split_dataset.py"
params.rf_script = "${projectDir}/scripts/random_forest_prediction.py"
params.visualize_script = "${projectDir}/scripts/visualize_confusion_matrix.py"
params.pca_script = "${projectDir}/scripts/visualize_pca.py"
params.output_dir = "./output"
params.seed = 42


workflow {
//channels(?)
    input_csv_ch = Channel.fromPath(params.input_csv)
    preprocess_script_ch = Channel.fromPath(params.preprocess_script)
    split_script_ch = Channel.fromPath(params.split_script)
    rf_script_ch = Channel.fromPath(params.rf_script)
    visualize_script_ch = Channel.fromPath(params.visualize_script)
    pca_script_ch = Channel.fromPath(params.pca_script)

    //Preprocess data
    preprocessed_data_ch = preprocessData(input_csv_ch, preprocess_script_ch)

    //Split dataset
    split_output = splitDataset(preprocessed_data_ch, split_script_ch)

    //RF prediction
    rf_results = randomForestPrediction(split_output, rf_script_ch)

    // visualize confusion matrix
    confusion_matrix_ch = rf_results.map { it[1] } // Extract confusion_matrix.npy
    visualizeConfusionMatrix(confusion_matrix_ch, visualize_script_ch)

    //PCA Visualization
    predictions_file_ch = rf_results.map { it[2] } // Extract predictions.csv
    visualizePCA(predictions_file_ch, pca_script_ch)
}


process preprocessData {

    input:
    path input_csv
    path script_file

    output:
    path "preprocessed_data.csv"

    container 'selinasun01/phaserf:latest'

    script:
    """
    mkdir -p ${params.output_dir}
    python ${script_file} --input ${input_csv} --output preprocessed_data.csv
    cp preprocessed_data.csv ${params.output_dir}/preprocessed_data.csv
    """
}


process splitDataset {

    input:
    path preprocessed_file
    path script_file

    output:
    tuple path("train.csv"), path("valid.csv"), path("test.csv")

    container 'selinasun01/phaserf:latest'

    script:
    """
    mkdir -p ${params.output_dir}
    python ${script_file} --input ${preprocessed_file} --output_dir . --seed ${params.seed}
    cp train.csv ${params.output_dir}/train.csv
    cp valid.csv ${params.output_dir}/valid.csv
    cp test.csv ${params.output_dir}/test.csv
    """
}

process randomForestPrediction {

    input:
    tuple path(train_file), path(valid_file), path(test_file)
    path script_file

    output:
    tuple path("results/metrics.txt"), path("results/confusion_matrix.npy"), path("results/predictions.csv")

    container 'selinasun01/phaserf:latest'

    script:
    """
    mkdir -p results
    python ${script_file} \
        --train ${train_file} \
        --valid ${valid_file} \
        --test ${test_file} \
        --metrics results/metrics.txt \
        --confusion_matrix results/confusion_matrix.npy \
        --predictions results/predictions.csv

    mkdir -p ${params.output_dir}/results
    cp results/metrics.txt ${params.output_dir}/results/metrics.txt
    cp results/confusion_matrix.npy ${params.output_dir}/results/confusion_matrix.npy
    cp results/predictions.csv ${params.output_dir}/results/predictions.csv
    """
}

process visualizeConfusionMatrix {

    input:
    path confusion_matrix
    path script_file

    output:
    path "results/confusion_matrix_label_*.png"

    container 'selinasun01/phaserf:latest'

    script:
    """
    mkdir -p results
    python ${script_file} \
        --input ${confusion_matrix} \
        --output results/confusion_matrix.png

    # Copy outputs to the desired output directory
    mkdir -p ${params.output_dir}/results
    cp results/confusion_matrix_label_*.png ${params.output_dir}/results/
    """
}


process visualizePCA {

    input:
    path predictions_file
    path script_file

    output:
    path "results/pca_plot.png"

    container 'selinasun01/phaserf:latest'

    script:
    """
    mkdir -p results
    python ${script_file} \
        --predictions ${predictions_file} \
        --output results/pca_plot.png

    # Copy the PCA plot to the desired output directory
    mkdir -p ${params.output_dir}/results
    cp results/pca_plot.png ${params.output_dir}/results/pca_plot.png
    """
}





