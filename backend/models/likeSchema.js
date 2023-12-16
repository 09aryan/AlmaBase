const mongoose=require('mongoose');
const likeSchema=new mongoose.Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true,
    },
    post:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'Post',
        required:true,
    }
    
});
const Likes = mongoose.model('Likes', likeSchema);
module.exports = Likes;