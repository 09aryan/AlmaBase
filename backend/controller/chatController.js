const asyncHandler = require('express-async-handler');
const authMiddleware = require('../middleware/auth');
const Chat = require('../models/chatModels');
const User = require('../models/userSchema');

// @description Create or fetch One to One Chat
// @route POST /api/chat/
// @access Protected
const accessChat = asyncHandler(async (req, res) => {
    const { userId } = req.body;
    console.log(`user id`, userId);

    if (!userId) {
        return res.status(400).json({ error: 'UserId param not sent with the request' });
    }

    try {
        // Check if req.user is defined and has _id property
        if (!req.user || !req.user.id) {
            console.log("bye");
            console.log('req.user:', req.user); // Add this line for additional logging
            return res.status(400).json({ error: 'User information not available' });
        }

        console.log(`req.user`, req.user);
        console.log(`req.user.id`, req.user.id);

        let isChat = await Chat.findOne({
            isGroupChat: false,
            users: { $all: [req.user.id, userId] },
        })
            .populate({
                path: 'users latestMessage.sender',
                select: '-password', // Exclude password from the result
            });

        if (!isChat) {
            const user = await User.findById(userId); // Fetch the user details
            const chatData = {
                chatName: user.userName, // Set chatName to the userName of the user
                isGroupChat: false,
                users: [req.user.id, userId],
            };

            const createdChat = await Chat.create(chatData);
            console.log(`chatId`, createdChat._id);
            isChat = await Chat.findOne({ _id: createdChat._id }).populate({
                path: 'users latestMessage.sender',
                select: '-password', // Exclude password from the result
            });
        }

        res.status(200).json(isChat);
    } catch (error) {
        console.error('Access Chat Error:', error);
        res.status(500).json({ error: `Internal Server Error: ${error.message}` });
    }
});

//@description     Fetch all chats for a user
//@route           GET /api/chat/
//@access          Protected
const fetchChats = (async (req, res) => {
    console.log('chat');
  try {
   
    console.log(req.user.id);
    const chats = await Chat.find({ users: req.user.id })
      .populate('users', '-password')
      .populate('groupAdmin', '-password')
      .populate('latestMessage.sender')
      .sort({ updatedAt: -1 });

    res.status(200).json(chats);
    // console.log(`chats ${chats}`);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

//@description     Create New Group Chat
//@route           POST /api/chat/group
//@access          Protected
const createGroupChat = asyncHandler(async (req, res) => {
  if (!req.body.users || !req.body.name) {
    return res.status(400).json({ message: 'Please fill in all the fields' });
  }

  const users = JSON.parse(req.body.users);

  if (users.length < 2) {
    return res.status(400).json({ message: 'More than 2 users are required to form a group chat' });
  }

  users.push(req.user);

  try {
    const groupChat = await Chat.create({
      chatName: req.body.name,
      users,
      isGroupChat: true,
      groupAdmin: req.user._id,
    });

    const fullGroupChat = await Chat.findOne({ _id: groupChat._id })
      .populate('users', '-password')
      .populate('groupAdmin', '-password');

    res.status(200).json(fullGroupChat);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// @desc    Rename Group
// @route   PUT /api/chat/rename
// @access  Protected
const renameGroup = asyncHandler(async (req, res) => {
  const { chatId, chatName } = req.body;

  const updatedChat = await Chat.findByIdAndUpdate(chatId, { chatName }, { new: true })
    .populate('users', '-password')
    .populate('groupAdmin', '-password');

  if (!updatedChat) {
    res.status(404).json({ error: 'Chat Not Found' });
  } else {
    res.status(200).json(updatedChat);
  }
});

// @desc    Remove user from Group
// @route   PUT /api/chat/groupremove
// @access  Protected
const removeFromGroup = asyncHandler(async (req, res) => {
  const { chatId, userId } = req.body;

  const removed = await Chat.findByIdAndUpdate(chatId, { $pull: { users: userId } }, { new: true })
    .populate('users', '-password')
    .populate('groupAdmin', '-password');

  if (!removed) {
    res.status(404).json({ error: 'Chat Not Found' });
  } else {
    res.status(200).json(removed);
  }
});

// @desc    Add user to Group / Leave
// @route   PUT /api/chat/groupadd
// @access  Protected
const addToGroup = asyncHandler(async (req, res) => {
  const { chatId, userId } = req.body;

  const added = await Chat.findByIdAndUpdate(chatId, { $push: { users: userId } }, { new: true })
    .populate('users', '-password')
    .populate('groupAdmin', '-password');

  if (!added) {
    res.status(404).json({ error: 'Chat Not Found' });
  } else {
    res.status(200).json(added);
  }
});

module.exports = {
  accessChat,
  fetchChats,
  createGroupChat,
  renameGroup,
  addToGroup,
  removeFromGroup,
};
