const Posts=require('../models/postSchema');
const Comments=require('../models/commentSchema');
const Likes=require('../models/likeSchema');
exports.getPostByTags=async(req,res)=>{
    try{
        const{tags}=req.params;
        const tagList=tags.split(',');
        const posts=await Posts.find({tags:{$in:tagList}}).populate('user','userName profilePic').populate('caption location media createdAt tags');
        postsWithDeatils=await Promise.all(posts.map(async(post)=>{
     const postComments=await Comments.find({post:post._id}).populate('user','userName profilepic').select('text createdAt');
     const postLikes=await Likes.find({post:post._id}).populate('user','userName profilepic').select('createdAt');
     return {
        postDetails:post,
        postComments,
        postLikes
     }
        }));
        return res.status(200).json({
            success:true,
            posts:postsWithDeatils,
        });
    }catch(err){
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Error fetching posts by tags',
        }); 
    }
};