const mongoose = require('mongoose');
const stroySchema=new mongoose.Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true,
    },
    text:{
        type:String
    },
    image:{
        type:String,
    },
    video:{
        type:String,
    },
    createdAt:{
        type:Date,
        default:Date.now,
    }
});
const Story = mongoose.model('Story', stroySchema);
module.exports = Story;