const Story = require('../models/storySchema');
const cloudinary = require('cloudinary');
// Import the User model

cloudinary.v2.config({
  cloud_name: 'dycjfvkno',
  api_key: '155367423744488',
  api_secret: '9Q207NuD_Saggw02sFjZQoniwks',
  secure: true,
});

exports.createStory = async (req, res) => {
  try {
    const userId = req.user.id;
    const { text } = req.body;
  const imageFile = req.files && req.files.file;
    const videoFile = req.files?.videoFile;
    let image, video;
    
    if (imageFile) {
      const imageResponse = await cloudinary.uploader.upload(
        imageFile.tempFilePath
      );
      image = imageResponse.secure_url;

      // Move the console.log here after the assignment
      console.log('image:', image);
    }

    if (videoFile) {
      const videoResponse = await cloudinary.uploader.upload(
        videoFile.tempFilePath,
        {
          resource_type: 'video',
        }
      );
      video = videoResponse;
    }

    const newStory = new Story({
      user: userId,
      text,
      image,
      video,
    });

    await newStory.save();

    // Update points if userId exists
    if (userId) {
      await User.findByIdAndUpdate(userId, { $inc: { points: 3 } }, { new: true });
    }

    return res.status(201).json({
      success: true,
      message: 'Story created successfully',
      Story: newStory,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: 'Error creating story',
    });
  }
};
