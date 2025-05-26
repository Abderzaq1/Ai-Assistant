import logging
import random
from models import TrainingData

logger = logging.getLogger(__name__)

# In a real application, this would integrate with an actual AI model
# For demo purposes, we'll implement a simple response generator

def generate_ai_response(user_message):
    """
    Generate an AI response based on user input.
    
    In a real application, this would call an AI model API or use a local model.
    For the demo, we'll implement a simple response system.
    
    Args:
        user_message (str): The user's message
        
    Returns:
        str: The AI's response
    """
    logger.debug(f"Generating AI response for: {user_message}")
    
    # Check if there's any matching training data
    user_message_lower = user_message.lower()
    
    # Try to find an exact match in training data
    training_match = TrainingData.query.filter(
        TrainingData.question.ilike(f"%{user_message_lower}%")
    ).first()
    
    if training_match:
        logger.debug(f"Found matching training data: {training_match.id}")
        return training_match.answer
    
    # Generic responses if no match found
    generic_responses = [
        "I'm a banking assistant. How can I help you with your banking needs today?",
        "I don't have information on that specific topic. Could you ask about banking services instead?",
        "I can assist with account information, transfers, payments, and other banking services. What would you like to know?",
        "That's an interesting question. While I don't have a specific answer, I can help with many banking-related inquiries.",
        "I'm designed to help with banking questions. Could you provide more details about what you're looking for?",
        "I'm continuously learning. Your question helps me improve, but I don't have an answer for that yet.",
        "I'd be happy to help with your banking needs. Could you ask something related to banking services?"
    ]
    
    # If the message contains certain banking keywords, provide more specific responses
    banking_keywords = {
        'account': [
            "I can help you with account information. What specific details do you need?",
            "Would you like to check your account balance, recent transactions, or account features?",
            "For account-related inquiries, I can provide information about different types of accounts we offer."
        ],
        'transfer': [
            "I can assist with transfers between accounts. Would you like to proceed with a transfer?",
            "For transfers, you'll need the recipient's account details. Do you have this information ready?",
            "Transfers can be made between your accounts or to external accounts. How would you like to proceed?"
        ],
        'payment': [
            "I can help you set up or manage payments. What type of payment are you interested in?",
            "Would you like to schedule a payment, view upcoming payments, or manage recurring payments?",
            "For bill payments, you can use our online banking system. Would you like more information?"
        ],
        'loan': [
            "I can provide information about our loan options. Are you looking for personal loans, mortgages, or business loans?",
            "Loan rates vary based on many factors. Would you like to discuss specific loan products?",
            "To apply for a loan, you'll need to provide certain documentation. Would you like details about the application process?"
        ],
        'credit': [
            "I can provide information about our credit card options. Would you like to learn about rewards, interest rates, or application processes?",
            "Credit score inquiries are available through our online banking portal. Have you checked your score recently?",
            "Our credit cards offer various benefits depending on your needs. Would you like to compare options?"
        ]
    }
    
    for keyword, responses in banking_keywords.items():
        if keyword in user_message_lower:
            return random.choice(responses)
    
    # Default to generic response
    return random.choice(generic_responses)
