import logging
import json
from flask import Blueprint, render_template, request, jsonify, redirect, url_for, flash
from flask_login import login_required, current_user
from models import Conversation, Message
from app import db
from ai_engine import generate_ai_response

chat_bp = Blueprint('chat', __name__)
logger = logging.getLogger(__name__)

@chat_bp.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html')

@chat_bp.route('/chat')
@login_required
def chat_page():
    conversation_id = request.args.get('id')
    
    if conversation_id:
        conversation = Conversation.query.filter_by(id=conversation_id, user_id=current_user.id).first_or_404()
        return render_template('chat.html', conversation=conversation)
    else:
        # Create a new conversation
        new_conversation = Conversation(user_id=current_user.id)
        db.session.add(new_conversation)
        db.session.commit()
        return redirect(url_for('chat.chat_page', id=new_conversation.id))

@chat_bp.route('/api/conversations', methods=['GET'])
@login_required
def get_conversations():
    conversations = Conversation.query.filter_by(
        user_id=current_user.id
    ).order_by(Conversation.updated_at.desc()).all()
    
    result = [{
        'id': conv.id,
        'title': conv.title,
        'created_at': conv.created_at.isoformat(),
        'updated_at': conv.updated_at.isoformat(),
        'message_count': conv.messages.count()
    } for conv in conversations]
    
    return jsonify(result)

@chat_bp.route('/api/conversations/<int:conversation_id>/rename', methods=['POST'])
@login_required
def rename_conversation(conversation_id):
    conversation = Conversation.query.filter_by(
        id=conversation_id, user_id=current_user.id
    ).first_or_404()
    
    data = request.get_json()
    if not data or 'title' not in data:
        return jsonify({'error': 'Title is required'}), 400
    
    conversation.title = data['title']
    db.session.commit()
    
    return jsonify({'success': True})

@chat_bp.route('/api/conversations/<int:conversation_id>', methods=['DELETE'])
@login_required
def delete_conversation(conversation_id):
    conversation = Conversation.query.filter_by(
        id=conversation_id, user_id=current_user.id
    ).first_or_404()
    
    db.session.delete(conversation)
    db.session.commit()
    
    return jsonify({'success': True})

@chat_bp.route('/api/conversations/<int:conversation_id>/messages', methods=['GET'])
@login_required
def get_messages(conversation_id):
    conversation = Conversation.query.filter_by(
        id=conversation_id, user_id=current_user.id
    ).first_or_404()
    
    messages = Message.query.filter_by(
        conversation_id=conversation.id
    ).order_by(Message.created_at).all()
    
    result = [{
        'id': msg.id,
        'role': msg.role,
        'content': msg.content,
        'created_at': msg.created_at.isoformat()
    } for msg in messages]
    
    return jsonify(result)

@chat_bp.route('/api/conversations/<int:conversation_id>/messages', methods=['POST'])
@login_required
def send_message(conversation_id):
    conversation = Conversation.query.filter_by(
        id=conversation_id, user_id=current_user.id
    ).first_or_404()
    
    data = request.get_json()
    if not data or 'message' not in data:
        return jsonify({'error': 'Message is required'}), 400
    
    # Create user message
    user_message = Message(
        conversation_id=conversation.id,
        role='user',
        content=data['message']
    )
    db.session.add(user_message)
    
    # Update conversation title if it's still the default and this is the first message
    if conversation.title == 'New Conversation' and conversation.messages.count() == 0:
        # Use the first 30 chars of the message as the title
        title = data['message'][:30]
        if len(data['message']) > 30:
            title += '...'
        conversation.title = title
    
    # Generate AI response
    try:
        ai_response = generate_ai_response(data['message'])
        
        # Create assistant message
        assistant_message = Message(
            conversation_id=conversation.id,
            role='assistant',
            content=ai_response
        )
        db.session.add(assistant_message)
        
        # Update conversation timestamp
        conversation.updated_at = db.func.now()
        
        db.session.commit()
        
        return jsonify({
            'user_message': {
                'id': user_message.id,
                'role': user_message.role,
                'content': user_message.content,
                'created_at': user_message.created_at.isoformat()
            },
            'assistant_message': {
                'id': assistant_message.id,
                'role': assistant_message.role,
                'content': assistant_message.content,
                'created_at': assistant_message.created_at.isoformat()
            }
        })
    except Exception as e:
        logger.error(f"Error generating AI response: {str(e)}")
        db.session.rollback()
        return jsonify({'error': 'Failed to generate AI response'}), 500
