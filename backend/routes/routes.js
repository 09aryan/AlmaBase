const express=require('express');
const fileUpload = require('express-fileupload');
const asyncHandler = require("express-async-handler");
const { signUp, login } = require('../controller/auth');
const { createPost } = require('../controller/postController');
const { addComment } = require('../controller/addCommet');
const { likePost } = require('../controller/addLike');
const { getAllStoriesWithDetails } = require('../controller/getAllStories');
const { createStory } = require('../controller/addstory');
const { editUserProfile } = require('../controller/editProfile');
const { getAllPosts, getAllPostsDetails } = require('../controller/getAllPost');
// const { getAllStories } = require('../controller/getAllTheStories');
const { getAllUsers } = require('../controller/getAllUsers');
const { getPostDetails } = require('../controller/getPostDetails');
const { getPostByTags } = require('../controller/getPostsBytags');
const { getUserDetails } = require('../controller/getUserDetails');
const { getUserStories } = require('../controller/getUserStories');
const { setBio } = require('../controller/addBio');
const userSchema = require('../models/userSchema');
const { searchUsersByUsername } = require('../controller/searchAuser');
const { getPostLikes } = require('../controller/getPostLikes');
const { getAllComments } = require('../controller/getPostComments');
const { createChat, sendMessage, getUserChats, accessChat, createGroupChat, renameGroup, addToGroup, fetchChats, removeFromGroup } = require('../controller/chatController');
const { allMessages } = require('../controller/messageController');
const authMiddleware = require('../middleware/auth');
const Message = require('../models/messageModel');
const Chat = require('../models/chatModels');
const router=express.Router();
// const http = require('http');
const socketIO = require('socket.io');
router.use(fileUpload({ useTempFiles: true }));
// const app = express();
// const server = http.createServer(app);
// const io = socketIO(server);

// io.on('connection', (socket) => {
//   console.log('A user connected');

//   socket.on('disconnect', () => {
//     console.log('User disconnected');
//   });
// });
// const multer = require('multer');

// // Set up Multer storage
// const storage = multer.memoryStorage(); // Use memory storage for handling files

// // Set up Multer upload
// const upload = multer({ storage: storage });

// Example route using Multer
router.get('/all-likes/:postId',getPostLikes);
router.post('/signup', signUp);
router.post('/login',login);
router.put('/set-Bio/:userId',setBio);
router.post('/add-comment/:postId',addComment);
router.post('/create-post/:userId',createPost);
// router.post('/like/:postId/:userId',likePost);
router.get('/stories',getAllStoriesWithDetails);
router.post('/like/:postId', authMiddleware, likePost);
router.post('/post-story',authMiddleware,createStory)
//  router.post('/create-story',createStory);
 router.put('/edit-profile',editUserProfile);
router.get('/all-posts',getAllPostsDetails);
// router.get('/all-stories',getAllStories);
router.get('/all-users',getAllUsers);
router.get('/post-details/:postid',getPostDetails);
router.get('/posts-by-tags/:tags',getPostByTags);
 router.get('/user-details/:userId',getUserDetails);
 router.get('/user-stories/:userId',getUserStories);
 router.get('/posts/:postId/likes',getPostLikes);
 // Adjust the path based on your project structure
 router.get('/post/:postId/comments', getAllComments);
 router.get('/search/:userName', searchUsersByUsername);

///chats
router.post('/chat/access',authMiddleware, asyncHandler(accessChat));

// Fetch all chats for a user
router.get('/chat/:userId', authMiddleware, (fetchChats));


// Create New Group Chat
router.post('/chat/group', asyncHandler(createGroupChat));

// Rename Group
router.put('/chat/rename', asyncHandler(renameGroup));

// Add user to Group / Leave
router.put('/chat/groupadd', asyncHandler(addToGroup));

// Remove user from Group
router.put('/chat/groupremove', asyncHandler(removeFromGroup));
//routes for message
// router.get('/message/:chatId', asyncHandler(allMessages));
// Instead of using express-async-handler
// const asyncHandler = require("express-async-handler");

// ...

// Your route handler without express-async-handler
router.get('/message/:chatId',  async (req, res) => {
    try {
      const chatId = req.params.chatId;
     // console.log('Received chat ID:', chatId);
  
      const messages = await Message.find({ chat: chatId })
        .populate({
          path: 'sender',
          select: 'userName fullName profilepic', // Select the fields you want to populate
        })
        .exec();
  //  console.log('message');
   // io.to(chatId).emit('messages', messages);
    //  console.log(messages);
      res.json(messages);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  const cloudinary = require('cloudinary');




  cloudinary.v2.config({
    cloud_name: 'dycjfvkno',
    api_key: '155367423744488',
    api_secret: '9Q207NuD_Saggw02sFjZQoniwks',
    secure: true,
  });
  
  router.post('/message', authMiddleware, async (req, res) => {
    try {
      const { content, chatId } = req.body;
      if( !chatId ){
        console.log('Invalid data passed into request');
        return res.sendStatus(400);
      }
      if (!content && (!req.files ))  {
        console.log('Invalid data passed into request');
        return res.sendStatus(400);
      }
  
      let mediaType;
      let mediaURLs = []; // Initialize to an empty array
  
      // console.log('Received message content:', content);
      // console.log('Received chat ID:', chatId);
      // console.log('Received files:', req.files);
  
      // Check if the request contains files
      if (req.files && req.files.media) {
        const files = Array.isArray(req.files.media) ? req.files.media : [req.files.media];
  
        for (const file of files) {
          // Use Cloudinary to upload each file
          const cloudinaryResponse = await cloudinary.v2.uploader.upload(file.tempFilePath, {
            resource_type: 'auto', // Automatically detect the resource type (image or video)
          });
  
          mediaType = cloudinaryResponse.resource_type;
          mediaURLs.push(cloudinaryResponse.secure_url);
  
          console.log('File uploaded to Cloudinary. Media URL:', cloudinaryResponse.secure_url);
        }
      }
  
      const newMessage = {
        sender: req.user.id,
        content: content ||' ',
        mediaType: mediaType || 'text',
        mediaURLs: mediaURLs,
        chat: chatId,
      };
  
      const message = await Message.create(newMessage);
  
      const populatedMessage = await Message.findById(message._id)
        .populate('sender', 'userName fullName profilepic')
        .exec();
  
      const updatedChat = await Chat.findByIdAndUpdate(
        chatId,
        { latestMessage: populatedMessage },
        { new: true }
      );
  
   //  console.log('Message sent with media:', mediaURLs);
     // io.to(chatId).emit('newMessage', populatedMessage); 
      res.json(populatedMessage);
      
    } catch (error) {
      console.error(error);
      res.status(500).send('Internal Server Error');
    }
  });
  
  
  router.get('/messages/:id', async (req, res) => {
    try {
        console.log('req.params.id');
        console.log(req.params.id);
      const messageId = req.params.id;
      const message = await Message.findById(messageId);
      if (!message) {
        return res.status(404).json({ error: 'Message not found' });
      }
      res.json(message);
    } catch (error) {
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
 module.exports = router;
 
