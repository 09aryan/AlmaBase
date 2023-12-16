const User = require('../models/userSchema');
const Post = require('../models/postSchema');

const cloudinary = require('cloudinary');
const { updatePoints } = require('./updatePoints');


cloudinary.v2.config({
  cloud_name: 'dycjfvkno',
  api_key: '155367423744488',
  api_secret: '9Q207NuD_Saggw02sFjZQoniwks',
  secure: true,
});

const createPost = async (req, res) => {
  try {
    const userId = req.params.userId;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User Not found',
      });
    }

    const { caption, location, tags, taggedUsers } = req.body;
    const imageFiles = req.files && req.files.file;

    if (!imageFiles) {
      return res.status(400).json({
        success: false,
        message: 'Image not provided',
      });
    }

    // Ensure imageFiles is an array
    const imageFilesArray = Array.isArray(imageFiles) ? imageFiles : [imageFiles];

    const uploadResponses = await Promise.all(
      imageFilesArray.map(async (file) => {
        return await cloudinary.uploader.upload(file.tempFilePath);
      })
    );

    const tagsArray = tags ? tags.split(',').map((tag) => tag.trim()) : [];
    const mediaArray = uploadResponses.map((response) => response.secure_url);
    const taggedUsernamesArray = taggedUsers.split(',').map((username) => username.trim());
    const taggedUserObjects = await User.find({ userName: { $in: taggedUsernamesArray } });
    const taggedUserIds = taggedUserObjects.map((user) => user._id);

    if (taggedUsernamesArray.length !== taggedUserIds.length) {
      const notFoundUsers = taggedUsernamesArray.filter((username) => !taggedUserIds.includes(username));
      console.log('User not found:', notFoundUsers);
      return res.status(404).json({
        success: false,
        message: 'One or more tagged users not found',
      });
    }

    const newPost = new Post({
      user: userId,
      caption,
      location,
      media: mediaArray,
      tags: tagsArray,
      taggedUsers: taggedUserIds,
    });

    const savedPost = await newPost.save();
    user.posts.push(savedPost._id);
    await user.save();
    await updatePoints(userId, 'post');

    res.status(201).json({
      success: true,
      message: 'Post Created Successfully',
      post: savedPost,
    });
  } catch (err) {
    console.error('Error creating post:', err);
    res.status(500).json({ success: false, err: 'Internal Server Error' });
  }
};

module.exports = { createPost };
