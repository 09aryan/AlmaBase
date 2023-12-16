const mongoose=require('mongoose');
const postSchema=new mongoose.Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true,
    },
    comments:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:'Comments'
    }],
    likes:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:'Likes'
    }],
    caption:{
        type:String,
        required:true
    },
    location:{
        type:String
    },
    media:[{
        type:String,
    }],
    createdAt:{
        type:Date,
        default:Date.now
    },
    tags: [{
         type: String
    }], 
    taggedUsers:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
       
    }]

    
});
const Post = mongoose.model('Post', postSchema);
module.exports = Post; 