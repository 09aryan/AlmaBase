const Likes = require('../models/likeSchema');
const Post=require('../models/postSchema');
const User=require('../models/userSchema');
const { updatePoints } = require('./updatePoints');
exports.likePost=async(req,res)=>{
    try{
        const postId=req.params.postId;
        const userId = req.user.id ;
        const post=await Post.findById(postId);
        console.log('postIdl:', postId);
    console.log('userIdl:', userId);
    // console.log('Post:', post);
        if(!post){
            return res.status(404).json({
                success:false,
                message:'Post not found',
            });
        }
        if(post.likes.includes(userId)){
            return res.status(400).json({
                success:false,
                message:'You have already liked this post',
            });
        }
     post.likes.push(userId);
   
     await post.save();
     await updatePoints(userId, 'like');
     await User.findByIdAndUpdate(userId,{$inc:{points:1}},{new:true});
     return res.status(200).json({
        success:true,
        message:'Post liked successfully',
     });

    }
    catch(err){
        console.error(err);
        return res.status(500).json({
            success:false,
            message:'Error liking the post',
        });
    }
};
// const Post = require('../models/postSchema');
// const User = require('../models/userSchema');
// const Likes = require('../models/likeSchema');

// exports.likePost = async (req, res) => {
//   try {
//     const postId = req.params.postId;
//     const userId =  req.user.id ;
//     console.log('hello');
//     console.log('User:', req.user);

//     console.log(userId);
//     console.log(postId);
//     // Check if the user is logged in
//     if (!userId) {
//       return res.status(401).json({
//         success: false,
//         message: 'User not authenticated',
//       });
//     }

//     // Find the post by ID
//     const post = await Post.findById(postId);

//     if (!post) {
//       return res.status(404).json({
//         success: false,
//         message: 'Post not found',
//       });
//     }

//     // Check if the user has already liked the post
//     if (post.likes.includes(userId)) {
        
//       return res.status(400).json({
//         success: false,
//         message: 'You have already liked this post',
//       });
//     }

//     // Create a new like
//     const like = new Likes({
//       user: userId,
//       post: postId,
//     });
   
//     // Save the like
//     await like.save();

//     // Add the like to the post
//     post.likes.push(like._id);
//     await post.save();

//     // Increment user points (if needed)
//     await User.findByIdAndUpdate(userId, { $inc: { points: 1 } }, { new: true });

//     return res.status(200).json({
//       success: true,
//       message: 'Post liked successfully',
//     });
//   } catch (err) {
//     console.error(err);
//     return res.status(500).json({
//       success: false,
//       message: 'Error liking the post',
//     });
//   }
// };
