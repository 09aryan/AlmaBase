const mongoose = require('mongoose');
const Post = require('../models/postSchema');
const User = require('../models/userSchema');

exports.getPostLikes = async (req, res) => {
  try {
    const postId = req.params.postId;

    // Find the post by ID and populate the 'likes' field with user documents
    const post = await Post.findById(postId).populate({
      path: 'likes',
      model: 'User', // Assuming 'User' is the model name for users
      select: 'userName profilepic', // Include only necessary fields
    });

    if (!post) {
      return res.status(404).json({
        success: false,
        message: 'Post not found',
      });
    }

    // Extract the user information from the populated 'likes' field
    const likes = post.likes.map(like => ({
      userId: like._id, // Use '_id' directly from the user document
      userName: like.userName,
      profilepic: like.profilepic, // Include the profile picture
      // Add more user details as needed
    }));
    console.log(likes);

    return res.status(200).json({
      success: true,
      likes: likes,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Error getting likes for the post',
    });
  }
};
