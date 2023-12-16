const User=require('../models/userSchema');
const cloudinary=require('../config/cloudinary');
exports.editUserProfile=async(req,res)=>{
    try{
        const userId=req.userId.id;
        const {userName,fullName,email,bio}=req.body;
        const user=await User.findById(userId);
        const profilePicFile = req.files.profilePicFile;
        if(!user){
            return res.status(404).json({
             success:false,
            message:'User not flund',
            });
        }
        if (profilePicFile) {
            const cloudinaryResponse = await cloudinary.uploader.upload(profilePicFile.tempFilePath);
            user.profilepic = cloudinaryResponse.secure_url;
        }
        user.userName=userName||user.userName;
        user.fullName=fullName||user.fullName;
        user.email=email||user.email;
        user.profilepic=profilepic||user.profilepic;
        user.bio=bio||user.bio;
        await user.save();
        return res.status(200).json({
            success:true,
            message:'User profile updated successfully',
            user
        });
    }
    catch(err){
        console.error(err);
            return res.status(500).json({
                success:false,
                message:'Error updating user profile',
            });
        }
    
};