// getAllPost.js
const Post = require('../models/postSchema');
const User = require('../models/userSchema');
const Likes = require('../models/likeSchema');
const Comments = require('../models/commentSchema');

exports.getAllPostsDetails = async (req, res) => {
    try {
        const posts = await Post.find()
            .populate('user', 'userName profilepic')
            .populate('likes', 'user')
            .populate({
                path: 'comments',
                populate: { path: 'user', select: 'userName' },
            });

        const postsWithDetails = await Promise.all(
            posts.map(async (post) => {
                const totalLikes = await Likes.countDocuments({ post: post._id });
                const totalComments = await Comments.countDocuments({ post: post._id });

                const likesDetails = await Likes.find({ post: post._id }).populate('user', 'userName');
                const commentsDetails = await Comments.find({ post: post._id }).populate('user', 'userName');

                return {
                    _id: post._id,
                    user: post.user,
                    comments: post.comments,
                    likes: post.likes,
                    caption: post.caption,
                    location: post.location,
                    media: post.media,
                    createdAt: post.createdAt,
                    tags: post.tags,
                    taggedUsers: post.taggedUsers,
                    totalLikes,
                    totalComments,
                    likesDetails,
                    commentsDetails,
                };
            })
        );

        return res.status(200).json({
            success: true,
            posts: postsWithDetails,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Error fetching posts details',
        });
    }
};
