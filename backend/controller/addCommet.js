const mongoose = require('mongoose');
const Post = require('../models/postSchema');
const User = require('../models/userSchema');
const Comment = require('../models/commentSchema');

exports.addComment = async (req, res) => {
  try {
    const postId = req.params.postId;
    // Set req.user statically for testing
    //  req.user = { id: '655e53299bd40c1986321463' };
// Inside your authentication middleware
// Inside your authentication middleware
console.log('Authentication Middleware - User ID:', req.user ? req.user.id : 'Not authenticated');


    const userId = req.body.userId;
    const { text } = req.body;
 console.log(postId);
 console.log(userId);
 console.log(text);
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({
        success: false,
        message: 'Post not found',
      });
    }

    const userObjectId = userId ? new mongoose.Types.ObjectId(userId) : null;


    const newComment = new Comment({
      user: userObjectId,
      post: postId,
      text,
    });

    await newComment.save();
    post.comments.push(newComment._id);
    await post.save();

    if (userId) {
      await User.findByIdAndUpdate(userId, { $inc: { points: 2 } }, { new: true });
    }

    return res.status(201).json({
      success: true,
      message: 'Comment added successfully',
      comment: newComment,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Error adding comment to the post',
    });
  }
};
