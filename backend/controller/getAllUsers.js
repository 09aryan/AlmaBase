const User=require('../models/userSchema');
exports.getAllUsers=async(req,res)=>{
    try{
        const users=await User.find({},'profilepic userName bio points');
        return res.status(200).json({
            success:true,
            users,
        });
    }catch(err){
        console.error(err);
        return res.status(500).json({
            success:false,
            message:'Error while fetching users',
        });
    }
};