#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

// Structure to hold our dataset
struct Dataset {
    std::vector<std::vector<float>> X;
    std::vector<float> y;
};

// Function to load CSV file
Dataset loadCSV(const std::string& filename) {
    Dataset data;
    std::ifstream file(filename);
    std::string line;

    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::string value;
        std::vector<float> row;

        while (std::getline(iss, value, ',')) {
            row.push_back(std::stof(value));
        }

        // Last column is y, rest are X
        data.y.push_back(row.back());
        row.pop_back();
        data.X.push_back(row);
    }

    return data;
}

// Function to create batches
std::vector<Dataset> createBatches(const Dataset& data, int batchSize) {
    std::vector<Dataset> batches;
    int numSamples = data.X.size();
    int numBatches = (numSamples + batchSize - 1) / batchSize;

    for (int i = 0; i < numBatches; ++i) {
        Dataset batch;
        int start = i * batchSize;
        int end = std::min(start + batchSize, numSamples);

        batch.X.assign(data.X.begin() + start, data.X.begin() + end);
        batch.y.assign(data.y.begin() + start, data.y.begin() + end);

        batches.push_back(batch);
    }

    return batches;
}

// Function to print batches (for debugging)
void printBatches(const std::vector<Dataset>& batches) {
    for (size_t i = 0; i < batches.size(); ++i) {
        std::cout << "Batch " << i + 1 << ":\n";
        for (size_t j = 0; j < batches[i].X.size(); ++j) {
            std::cout << "  Sample " << j + 1 << ": ";
            for (float val : batches[i].X[j]) {
                std::cout << val << " ";
            }
            std::cout << "| " << batches[i].y[j] << "\n";
        }
        std::cout << "\n";
    }
}

int main() {
    // Load the CSV file
    Dataset data = loadCSV("data/sample.csv");

    // Create batches
    std::vector<Dataset> batches = createBatches(data, 3); // Batch size of 32

    // Print batches for debugging
    printBatches(batches);

    return 0;
}
