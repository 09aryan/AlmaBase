const Story = require('../models/storySchema');
const User = require('../models/userSchema');

exports.getUserStories = async (req, res) => {
    try {
        const userId = req.params.userId;
        const stories = await Story.find({ user: userId }).select('text image video createdAt');
        const populatedStories = await Promise.all(stories.map(async (story) => {
            const user = await User.findById(story.user).select('userName bio fullName profilepic');
            return {
                story,
                user: {
                    userName: user.userName,
                    bio: user.bio,
                    fullName: user.fullName,
                    profilepic: user.profilepic,
     },
          };
        }));
        return res.status(200).json({
            success: true,
            stories: populatedStories,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Error fetching user stories',
  });
    }
};
