// controllers/messageController.js
const asyncHandler = require('express-async-handler');
const Message = require('../models/messageModel');
const Chat = require('../models/chatModels');

// Get all Messages
const allMessages = asyncHandler(async (req, res) => {
    try {
      const chatId = req.params.chatId;
     // console.log('Received chat ID:', chatId);
  
      const messages = await Message.find({ chat: chatId })
        .populate({
          path: 'sender',
          select: 'name pic email',
        })
        .populate('chat');
  
      //console.log(messages);
      res.json({ messages }); // Return messages as an object
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

// Create New Message
const sendMessage = asyncHandler(async (req, res) => {
  const { content, chatId } = req.body;

  if (!content || !chatId) {
    console.log('Invalid data passed into request');
    return res.sendStatus(400);
  }

  const newMessage = {
    sender: req.user._id,
    content: content,
    chat: chatId,
  };

  try {
    const message = await Message.create(newMessage);

    const populatedMessage = await Message.findById(message._id)
      .populate('sender', 'name pic')
      .populate('chat')
      .exec();

    // Update the latestMessage field in the Chat document
    const updatedChat = await Chat.findByIdAndUpdate(
      chatId,
      { latestMessage: populatedMessage },
      { new: true } // Return the modified document
    );

    res.json(populatedMessage);
  } catch (error) {
    res.status(400);
    throw new Error(error.message);
  }
});

module.exports = { allMessages, sendMessage };
