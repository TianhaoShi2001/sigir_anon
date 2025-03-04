# Repository Overview

This repository provides a comprehensive set of scripts and modules for training recommender systems, focusing on cold-start scenarios. It includes the implementation of  Progressive Influence Functions (PIF), along with a detailed data preprocessing pipeline. Below is a detailed overview of the repository's key functionalities and files.

---

## Part 1: Data Preprocessing

The preprocessing pipeline transforms raw data into a format suitable for training recommender systems, ensuring the dataset is properly split for cold-start and warm-start item scenarios.

### Workflow Overview

1. **`preprocess1.ipynb`**
   - **Purpose**: Processes raw data into intermediate pickle files (`small_Books.pkl` and `small_meta_Books.pkl`).
   - **Details**: Due to the large size of the Amazon Book dataset, the raw file is not included in this repository. It can be downloaded from [Amazon Reviews Dataset 2023](https://amazon-reviews-2023.github.io/), and [MovieLens 32M] (https://grouplens.org/datasets/movielens/). Additionally, when processing ML-32M, we utilizes `title.basics.tsv`, which contains movie information based on metadata indexed from IMDb (dowdloaded from https://datasets.imdbws.com/).

2. **`preprocess2.ipynb`**
   - **Purpose**: Converts the intermediate files into the final dataset by performing the following three steps:
        1. **Item Split by Publish Time**  
        - The data is split into two categories based on publish time:
            - **Candidate Cold-start items**: Items that were published later than October 1st, 2023.
            - **Candidate Warm-start items**: Items published before October 1st, 2023.
            - This operation simulates a scenario where Large Language Models lack sufficient data about cold-start items during pre-training, as they are often published after the LLM’s pre-training phase. This prevents potential information leakage about cold-start items during the LLM's pre-training phase.

        2. **Data Filtering**  
            - The dataset is then split into training and evaluation periods based on the timestamp:
                - Amazon-Book: 
                    - Training data: From January 2016 to December 2022.
                    - Validation/evaluation data: From January 2023 to October 2023.
                - ML-32M:
                    - Training data: From January 2020 to December 2022.
                    - Validation/evaluation data: From January 2023 to October 2023.
            - Historical interactions for candidate cold-start items during the training period are removed.
            - Candidate warm-start items with fewer than 50 / 20 interactions in the training set are removed to ensure sufficient training data for warm-start items.
        
        3. **Format Conversion**  
            - The data is processed into a format suitable further use.

---

## Part 2: Model Training and Inference

### Key Files and Their Purposes

1. **`calculate_IF.py`**
   - **Purpose**: Computes Influence Functions (IF) using the Conjugate Gradient Method for efficient and scalable calculations.

2. **`PIF_iterate.py`**
   - **Purpose**: Implements the iterative process of Progressive Influence Functions (PIF), gradually approximating the final results.

3. **`PIF_inference.py`**
   - **Purpose**: Performs inference using PIF ensembles by calculating Influence Functions multiple times to train the model.

4. **`TALLRec_main.py`**
   - **Purpose**: Trains the TALLRec model and uses it to synthesize user interactions in cold-start scenarios, combining TALLRec's primary functionalities and synthetic interaction generation.

### Training and Script Files

1. **`PIF_iterate.sh`**
   - **Purpose**: A shell script for training Progressive Influence Functions (PIF), automating iterative calculations.

2. **`train_tallrec.sh`**
   - **Purpose**: A shell script for training the TALLRec model, including data loading and model saving steps.

3. **`tallrec_generate_synthetic_data.sh`**
   - **Purpose**: A shell script for synthesizing cold-start interaction data using the trained TALLRec model, enabling experiments in cold-start scenarios.


---

## Usage Guide

1. **Data Preprocessing**:
   - Run `preprocess1.ipynb` to generate intermediate files (`small_Books.pkl` and `small_meta_Books.pkl`).
   - Run `preprocess2.ipynb` to split the dataset, filter data, and prepare the final dataset.

2. **Training and Evaluation**:
   - Change to the appropriate directory using cd.
   - Use `train_tallrec.sh` to train the TALLRec model.
   - Run `tallrec_generate_synthetic_data.sh` to synthesize cold-start interaction data.
    - Execute `PIF_iterate.sh` to run Progressive Influence Functions (PIF).




