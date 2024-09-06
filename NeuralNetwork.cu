#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>

#define BATCH_SIZE 4

std::vector<std::string> split(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(str);
    while (std::getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

void loadCSV(const std::string& filename, std::vector<std::vector<float>>& X, std::vector<float>& Y) {
    std::ifstream file(filename);
    std::string line;
    
    while (std::getline(file, line)) {
        std::vector<std::string> tokens = split(line, ',');
        std::vector<float> x_row;
        
        for (size_t i = 0; i < tokens.size() - 1; ++i) {
            x_row.push_back(std::stof(tokens[i]));
        }
        
        X.push_back(x_row);
        Y.push_back(std::stof(tokens.back()));
    }
}

void createBatches(const std::vector<std::vector<float>>& X, const std::vector<float>& Y, int batchSize) {
    size_t total_samples = X.size();
    
    for (size_t i = 0; i < total_samples; i += batchSize) {
        size_t batch_end = std::min(i + batchSize, total_samples);

        std::cout << "Batch from index " << i << " to " << batch_end - 1 << std::endl;
        std::cout << "X Batch:" << std::endl;
        for (size_t j = i; j < batch_end; ++j) {
            for (float val : X[j]) {
                std::cout << val << " ";
            }
            std::cout << std::endl;
        }
        std::cout << "Y Batch:" << std::endl;
        for (size_t j = i; j < batch_end; ++j) {
            std::cout << Y[j] << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    std::vector<std::vector<float>> X;
    std::vector<float> Y;
    
    // Load CSV
    loadCSV("data/sample.csv", X, Y);

    // Print the data for debugging
    std::cout << "Loaded data successfully." << std::endl;
    std::cout << "Total samples: " << X.size() << std::endl;
    std::cout << "Creating batches of size: " << BATCH_SIZE << std::endl;

    // Create and print batches
    createBatches(X, Y, BATCH_SIZE);
    
    return 0;
}
