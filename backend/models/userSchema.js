const mongoose=require('mongoose');
const cloudinary=require('cloudinary').v2;
const userSchema=new mongoose.Schema({
    userName:{
        type:String,
        required:true,
        unique:true,
    },
    fullName:{
        type:String,
        required:true
    },
    password: {
        required: true,
        type: String,
    },
    email:{
        type:String,
        required:true,
        unique:true,
    },
    profilepic:{
        type:String,
    },
    bio:{
        type:String,
        default:" "

    },
    points:{
        type:Number,
        default:0,
    },
    stories: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Story',
    }],
    posts: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post',
    }],
});

module.exports = User = mongoose.model('User',userSchema)
