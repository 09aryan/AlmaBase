const Post=require('../models/postSchema');
const Comments=require('../models/commentSchema');
const Like=require('../models/likeSchema');
const Story=require('../models/storySchema');
exports.getPostDetails=async(req,res)=>{
    try{
        const postId=req.params.postId;
        const postDetails = await Post.findById(postId)
        .populate('user', 'userName profilepic')
        .select('caption location media createdAt');
        const postComments = await Comments.find({ post: postId })
        .populate('user', 'userName profilepic') 
        .select('text createdAt');
 
        const userStories = await Story.find({ user: postDetails.user._id })
        .select('text image video createdAt')
        .sort({ createdAt: -1 });
    const postLikes = await Like.find({ post: postId })
        .populate('user', 'userName profilepic') 
        .select('createdAt');
      return res.status(200).json({
        success:true,
        postDetails,
        postComments,
        postLikes,
        userStories
      });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Error fetching post details, comments, and likes',
        });
    }
};
