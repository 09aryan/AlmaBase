const mongoose = require('mongoose');
const Comment = require('../models/commentSchema');
const Post = require('../models/postSchema');

exports.getAllComments = async (req, res) => {
  try {
    const postId = req.params.postId;

    // Find the post by ID and populate the 'comments' field with user details
    const post = await Post.findById(postId).populate({
      path: 'comments',
      populate: {
        path: 'user',
        select: 'userName profilepic', // Select the fields you want to retrieve
      },
    });

    if (!post) {
      return res.status(404).json({
        success: false,
        message: 'Post not found',
      });
    }

    // Extract the comments information from the populated 'comments' field
    const comments = post.comments.map(comment => ({
      userId: comment.user._id,
      userName: comment.user.userName,
      userProfilePic: comment.user.profilepic,
      text: comment.text,
      createdAt: comment.createdAt,
    }));

    return res.status(200).json({
      success: true,
      comments: comments,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Error getting comments for the post',
    });
  }
};
