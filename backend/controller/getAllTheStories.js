const Story=require('../models/storySchema');
exports.getAllStories=async(req,res)=>{
    try{
    const stories=await Story.find({}).select('text image video createdAt').sort({createdAt:-1});
    return res.statues(200).json({
        success:true,
        stories,
    });
}catch(err){
    console.error(err);
    return res.status(500).json({
        success:false,
        message:'Error fecthing all the stories',
    });
}

};