import os
import logging
import uuid
import datetime
from werkzeug.utils import secure_filename
from flask import Blueprint, render_template, request, jsonify, redirect, url_for, flash, current_app
from flask_login import login_required, current_user
from models import TrainingData, TrainingFile
from app import db

training_bp = Blueprint('training', __name__)
logger = logging.getLogger(__name__)

# Allowed file extensions
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'doc', 'docx', 'csv'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@training_bp.route('/training')
@login_required
def training_page():
    return render_template('training.html')

@training_bp.route('/data')
@login_required
def data_page():
    return render_template('data.html')

@training_bp.route('/api/training/manual', methods=['POST'])
@login_required
def add_manual_training():
    data = request.get_json()
    if not data or 'question' not in data or 'answer' not in data:
        return jsonify({'error': 'Question and answer are required'}), 400
    
    question = data['question'].strip()
    answer = data['answer'].strip()
    
    if not question or not answer:
        return jsonify({'error': 'Question and answer cannot be empty'}), 400
    
    # Create training data entry
    training_data = TrainingData(
        user_id=current_user.id,
        question=question,
        answer=answer,
        source_type='manual'
    )
    
    try:
        db.session.add(training_data)
        db.session.commit()
        return jsonify({
            'id': training_data.id,
            'question': training_data.question,
            'answer': training_data.answer,
            'created_at': training_data.created_at.isoformat()
        })
    except Exception as e:
        logger.error(f"Error adding manual training data: {str(e)}")
        db.session.rollback()
        return jsonify({'error': 'Failed to add training data'}), 500

@training_bp.route('/api/training/file', methods=['POST'])
@login_required
def upload_training_file():
    # Check if the post request has the file part
    if 'file' not in request.files:
        logger.error("No file part in the request")
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    
    # If user does not select file, browser also
    # submit an empty part without filename
    if file.filename == '':
        logger.error("Empty filename")
        return jsonify({'error': 'No selected file'}), 400
    
    logger.info(f"Processing uploaded file: {file.filename}")
    
    if file and allowed_file(file.filename):
        # Generate unique filename
        original_filename = secure_filename(file.filename)
        file_extension = original_filename.rsplit('.', 1)[1].lower() if '.' in original_filename else ''
        unique_filename = f"{uuid.uuid4().hex}.{file_extension}" if file_extension else f"{uuid.uuid4().hex}"
        
        logger.info(f"Original filename: {original_filename}, unique filename: {unique_filename}")
        
        # Create training file record
        training_file = TrainingFile(
            user_id=current_user.id,
            filename=unique_filename,
            original_filename=original_filename,
            file_size=0,  # Will update after saving
            file_type=file.content_type if hasattr(file, 'content_type') else 'application/octet-stream',
            status='processing'
        )
        
        try:
            # Ensure the upload directory exists
            upload_dir = current_app.config.get('UPLOAD_FOLDER', 'uploads')
            os.makedirs(upload_dir, exist_ok=True)
            logger.info(f"Ensuring upload directory exists: {upload_dir}")
            
            # Save file
            file_path = os.path.join(upload_dir, unique_filename)
            file.save(file_path)
            logger.info(f"File saved to: {file_path}")
            
            # Update file size
            file_size = os.path.getsize(file_path)
            training_file.file_size = file_size
            logger.info(f"File size: {file_size} bytes")
            
            db.session.add(training_file)
            db.session.commit()
            logger.info(f"Training file record created with ID: {training_file.id}")
            
            # Process the file (in a real app, this would be a background task)
            logger.info(f"Starting file processing for ID: {training_file.id}")
            process_result = process_training_file(training_file.id)
            logger.info(f"File processing result: {process_result}")
            
            # Refresh the training file status from the database
            db.session.refresh(training_file)
            
            return jsonify({
                'id': training_file.id,
                'filename': training_file.original_filename,
                'status': training_file.status,
                'created_at': training_file.created_at.isoformat()
            })
        except Exception as e:
            logger.error(f"Error uploading training file: {str(e)}")
            db.session.rollback()
            return jsonify({'error': f'Failed to upload file: {str(e)}'}), 500
    
    return jsonify({'error': 'File type not allowed'}), 400

def process_training_file(file_id):
    """Process an uploaded training file and extract question-answer pairs."""
    training_file = TrainingFile.query.get_or_404(file_id)
    
    try:
        # In a real app, this would be more sophisticated and handle different file types
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], training_file.filename)
        logger.info(f"Processing file: {file_path}, original name: {training_file.original_filename}")
        
        # Simple example: process a text file with Q&A pairs separated by a delimiter
        # Format: Q: question\nA: answer\n\n
        if training_file.filename.endswith('.txt'):
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                logger.info(f"File content length: {len(content)} characters")
                
                # Try to detect format
                pairs = []
                if '\n\n' in content:
                    # Format with blank lines between pairs
                    pairs = content.split('\n\n')
                    logger.info(f"Split content into {len(pairs)} potential pairs using blank line delimiter")
                else:
                    # Try to detect Q/A pairs without blank lines
                    # Split by "Q:" pattern
                    raw_chunks = content.split('Q:')
                    logger.info(f"Split content into {len(raw_chunks)} potential chunks using Q: delimiter")
                    
                    # Process each chunk to extract Q&A
                    for chunk in raw_chunks[1:]:  # Skip first empty chunk
                        if 'A:' in chunk:
                            q_part, rest = chunk.split('A:', 1)
                            question = q_part.strip()
                            
                            # Get answer - everything until next Q: or end of text
                            answer = rest.strip()
                            pairs.append(f"Q:{question}\nA:{answer}")
                        else:
                            # No answer part found
                            logger.warning(f"Found Q: without matching A: in chunk: {chunk[:50]}...")
                
                data_count = 0
                
                # Process all pairs to extract Q&A
                for pair in pairs:
                    logger.debug(f"Processing pair: {pair[:50]}...")
                    
                    # Handle Arabic format (س: and ج:)
                    if 'س:' in pair and 'ج:' in pair:
                        try:
                            parts = pair.split('ج:')
                            question_part = parts[0]
                            question = question_part.split('س:')[1].strip()
                            answer = parts[1].strip()
                            
                            if question and answer:
                                logger.info(f"Adding Arabic training data - س: {question[:30]}..., ج: {answer[:30]}...")
                                training_data = TrainingData(
                                    user_id=training_file.user_id,
                                    question=question,
                                    answer=answer,
                                    source_type='file',
                                    source_name=training_file.original_filename
                                )
                                db.session.add(training_data)
                                data_count += 1
                        except Exception as e:
                            logger.error(f"Error processing Arabic Q&A pair: {str(e)}")
                    
                    # Try to handle various English formats: Q:/A:, Question:/Answer:, Q./A., etc.
                    elif ('Q:' in pair or 'Question:' in pair) and ('A:' in pair or 'Answer:' in pair):
                        try:
                            # Split by A: or Answer:
                            if 'A:' in pair:
                                parts = pair.split('A:')
                            else:
                                parts = pair.split('Answer:')
                                
                            # Clean up the question part by removing Q: or Question:
                            question_part = parts[0]
                            if 'Q:' in question_part:
                                question = question_part.split('Q:')[1].strip()
                            elif 'Question:' in question_part:
                                question = question_part.split('Question:')[1].strip()
                            else:
                                question = question_part.strip()
                                
                            answer = parts[1].strip()
                            
                            if question and answer:
                                # Log that we're adding training data
                                logger.info(f"Adding English training data - Q: {question[:30]}..., A: {answer[:30]}...")
                                
                                training_data = TrainingData(
                                    user_id=training_file.user_id,
                                    question=question,
                                    answer=answer,
                                    source_type='file',
                                    source_name=training_file.original_filename
                                )
                                db.session.add(training_data)
                                data_count += 1
                        except Exception as e:
                            logger.error(f"Error processing English Q&A pair: {str(e)}")
                    
                logger.info(f"Successfully extracted {data_count} training pairs from file")
                
        # Handle other file types like PDF, DOCX, etc.
        # ... (to be implemented in future)
        
        # Update file status
        training_file.status = 'completed'
        training_file.processed_at = datetime.datetime.utcnow()
        db.session.commit()
        
        logger.info(f"File {training_file.original_filename} successfully processed")
        return True
    except Exception as e:
        logger.error(f"Error processing training file: {str(e)}")
        training_file.status = 'failed'
        db.session.commit()
        return False

@training_bp.route('/api/training/data', methods=['GET'])
@login_required
def get_training_data():
    training_data = TrainingData.query.filter_by(
        user_id=current_user.id
    ).order_by(TrainingData.created_at.desc()).all()
    
    result = [{
        'id': data.id,
        'question': data.question,
        'answer': data.answer,
        'source_type': data.source_type,
        'source_name': data.source_name,
        'created_at': data.created_at.isoformat()
    } for data in training_data]
    
    return jsonify(result)

@training_bp.route('/api/training/data/<int:data_id>', methods=['DELETE'])
@login_required
def delete_training_data(data_id):
    training_data = TrainingData.query.filter_by(
        id=data_id, user_id=current_user.id
    ).first_or_404()
    
    try:
        db.session.delete(training_data)
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        logger.error(f"Error deleting training data: {str(e)}")
        db.session.rollback()
        return jsonify({'error': 'Failed to delete training data'}), 500

@training_bp.route('/api/training/data/<int:data_id>', methods=['PUT'])
@login_required
def update_training_data(data_id):
    training_data = TrainingData.query.filter_by(
        id=data_id, user_id=current_user.id
    ).first_or_404()
    
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    if 'question' in data:
        training_data.question = data['question']
    
    if 'answer' in data:
        training_data.answer = data['answer']
    
    try:
        db.session.commit()
        return jsonify({
            'id': training_data.id,
            'question': training_data.question,
            'answer': training_data.answer,
            'source_type': training_data.source_type,
            'source_name': training_data.source_name,
            'created_at': training_data.created_at.isoformat()
        })
    except Exception as e:
        logger.error(f"Error updating training data: {str(e)}")
        db.session.rollback()
        return jsonify({'error': 'Failed to update training data'}), 500

@training_bp.route('/api/training/files', methods=['GET'])
@login_required
def get_training_files():
    training_files = TrainingFile.query.filter_by(
        user_id=current_user.id
    ).order_by(TrainingFile.created_at.desc()).all()
    
    result = [{
        'id': file.id,
        'filename': file.original_filename,
        'file_size': file.file_size,
        'file_type': file.file_type,
        'status': file.status,
        'created_at': file.created_at.isoformat(),
        'processed_at': file.processed_at.isoformat() if file.processed_at else None
    } for file in training_files]
    
    return jsonify(result)
