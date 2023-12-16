const mongoose = require('mongoose');
const User=require('../models/userSchema');

const updatePoints=async(userId,action)=>{
try{
    const pointValues={
        like:1,
        Comment:2,
        post:5,
        story:3,
    };
    const pointsToadd=pointValues[action]||0;
    const updatedUser=await User.findByIdAndUpdate(
        userId,
        {$inc:{points:pointsToadd}},
        {new:true}
    );
    return updatedUser;
    }
    
catch (err) {
    throw new Error(`Error while updating points: ${err.message}`);
        
    }

    

};
module.exports={updatePoints};

