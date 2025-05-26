# Bank AI Assistant

## Project Overview

The Bank AI Assistant is an advanced Arabic language chatbot designed specifically for banking services. It uses natural language processing and machine learning techniques to understand and respond to customer inquiries about banking products, services, and procedures.

## Features

- **Arabic Language Support**: Optimized for Arabic language processing with specialized text preprocessing
- **Intelligent Question Answering**: Uses hybrid matching algorithms to find the most relevant answers
- **Sentiment Analysis**: Detects user sentiment to provide emotionally appropriate responses
- **Learning Capability**: Improves over time by learning from interactions
- **Document Processing**: Extracts information from PDF, CSV, and JSON files
- **Web Interface**: User-friendly chat interface for easy interaction

## Technologies and Algorithms

### Core Technologies

- **Python 3.10+**: Primary programming language
- **Flask**: Web framework for the application interface
- **PyTorch**: Deep learning framework for NLP models
- **Transformers**: Hugging Face library for pre-trained models
- **Sentence-Transformers**: For semantic text embeddings
- **PyPDF2**: For PDF document processing
- **Docker**: For containerization and deployment

### Algorithms and Techniques

1. **Text Preprocessing**
   - Arabic stopword removal
   - Diacritics removal
   - Text normalization
   - Special character handling

2. **Question Matching**
   - **TF-IDF Vectorization**: Term Frequency-Inverse Document Frequency for text representation
   - **Cosine Similarity**: Measures similarity between question vectors
   - **SBERT Embeddings**: Sentence-BERT for semantic understanding
   - **Hybrid Matching**: Combines TF-IDF and SBERT for optimal results

3. **Sentiment Analysis**
   - Uses **ArabERT** (Arabic BERT) model for sentiment classification
   - Categorizes text as positive, negative, or neutral
   - Adjusts responses based on detected sentiment

4. **Question Classification**
   - Rule-based classification into categories:
     - How-to questions
     - Comparison questions
     - Definition questions
     - Requirement questions
     - General questions

5. **Response Generation**
   - Template-based response formatting
   - Dynamic content selection based on confidence scores
   - Contextual examples for how-to questions
   - Related question suggestions

6. **Continuous Learning**
   - Stores successful interactions
   - Periodically retrains models with new data
   - Confidence threshold-based learning

## Installation and Setup

### Prerequisites

- Python 3.10 or higher
- pip (Python package manager)
- Docker and Docker Compose (for containerized deployment)

### Option 1: Local Installation

1.
   ```bash
   cd bank-ai-assistant
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the application:
   ```bash
   python main.py  (Recommended)      or      python app.py
   ```

4. Access the application at http://localhost:5000

### Option 2: Docker Deployment

1. bash
   cd bank-ai-assistant
   ```

2. Build and run with Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Access the application at http://localhost:5000

## Usage Guide

### Basic Usage

1. Open the application in your web browser at http://localhost:5000
2. Type your banking-related question in Arabic in the chat input
3. The AI will process your question and provide a relevant answer
4. Continue the conversation as needed

### Uploading Data

1. Click on the "Upload" button in the interface
2. Select a file (supported formats: JSON, CSV, PDF)
3. The system will process the file and add the data to its knowledge base
4. You can now ask questions related to the newly added data

### Training the Model

1. Use the "Train" feature to add custom question-answer pairs
2. Enter a question and its corresponding answer
3. Submit to add to the knowledge base
4. The system will learn from these additions to improve future responses

## Performance Optimization

- **Memory Usage**: The application uses approximately 500MB-1GB of RAM depending on loaded models
- **Response Time**: Average response time is 0.5-2 seconds depending on question complexity
- **Scaling**: The Docker configuration allows for easy scaling in production environments

## Troubleshooting

### Common Issues

1. **Model Loading Errors**
   - Ensure you have sufficient RAM (minimum 4GB recommended)
   - Check internet connection for initial model downloads
   - Verify that all dependencies are correctly installed

2. **File Upload Issues**
   - Ensure file size is under 10MB
   - Verify file format is supported (JSON, CSV, PDF)
   - Check that the uploads directory is writable

3. **Slow Response Times**
   - Consider using a machine with GPU support for faster processing
   - Reduce the size of the knowledge base if it has grown very large
   - Optimize the Docker configuration for your specific hardware

## Development and Extension

### Adding New Features

1. **New Data Sources**:
   - Extend the `load_data` method in the `AdvancedBankAssistant` class
   - Implement appropriate data parsing for the new source

2. **Additional Languages**:
   - Add new stopword lists for other languages
   - Implement language-specific preprocessing in `_advanced_text_processing`
   - Load appropriate language models in the initialization

3. **Enhanced UI**:
   - Modify the templates in the templates directory
   - Update the static CSS files as needed

### Code Customization

The main customization points are:

- `AdvancedBankAssistant` class in `main.py` or `core/bank_ai.py`
- Template response generation in `_generate_main_answer`
- Question classification in `_analyze_question_structure`
- Sentiment analysis configuration in the initialization
 

## Acknowledgments

- ArabERT team for the Arabic BERT model
- Hugging Face for the Transformers library
- Sentence-Transformers for the multilingual embedding models
