const  User=require('../models/userSchema');
const setBio=async(req,res)=>{
    try{
        const userId=req.params.userId;
        console.log('Received userId:', userId);
        const {bio}=req.body;
        const user=await User.findByIdAndUpdate(
            userId
        );
       
        if(!user){
            return res.status(404).json({
                message:'User not found',
            });
        }
        user.bio=bio;
        await user.save();
        return res.json({
            message:'Bio updated successfull',user
        });

    }
    catch(err){
        console.error(err);
        return res.status(500).json({
            msg:'Internal server Error'
        });
    }
};
module.exports={
    setBio,
}